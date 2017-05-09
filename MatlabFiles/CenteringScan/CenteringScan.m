 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    CenteringScan
%
%    Takes in mulitple images of direct beam as ROI, 
%    fits the beam profile to a model Perp function,
%    using the fit center position,
%    determines which directions the sample motors must move
%
%    Usage:
%    CenteringScan( sImagePrefix, nImageStart, nImageEnd, nStartAngle, nIncrementAngle, fPixelSize, nAveragePoints, nAutoFindRegion )
%
%    if nAutoFindRegion = 1, will cut the beam
%    else give range of profile
%
%    Example:
%    CenteringScan( 'CenteringImage_', 4, 8, -90, 90, 1.50, 5, 1 )
%    CenteringScan( 'CenteringImage_', 4, 8, -90, 90, 1.50, 5, 600:1200 )
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = CenteringScan(sImagePrefix, nImageStart, nImageEnd, nStartingAngle, nIncrementAngle, fPixelSize, nAv,nAutoFindRegion)

modelPerp = @(p,x) p(1).*exp(-4*log(2)*(((x - p(5)).^2)./(p(7)).^2)) + p(2) + p(3).*(x-p(6)) + p(4)*((x-p(6)).^2);

i=1;
bFailure=0;
FullParameters = zeros(length(nImageStart:nImageEnd),7);
nAv = 3;
for j=nImageStart:nImageEnd
   im = imread( strcat(sImagePrefix, padZero(j,4), '.tif') );
   %background subtracted image
   im = abs(im - min(min(im)));
   %apply median filter
   im = medfilt2(im);
   %background-subtracted filter profile of the beam
   Profile = sum( im, 1);
   
   
   
%%%% need all profiles to be offset by same amount, show on scale of pixels
%%%% done 10/15/09
   
%%% think about applying median filter in future
%%% done 10/15/09

    if( nAutoFindRegion(1) == 1 )
        %autofindregion
        SProfile = NoiseReduceProfile( Profile, nAv );
        [CProfile, CutLeftIndex] = CutProfile( SProfile );
        Offset(j) = CutLeftIndex*nAv;
        x = 1:length(CProfile);
    else
        %user defined cut region
        CProfile = Profile( nAutoFindRegion );
        Offset(j) = min(nAutoFindRegion);
        SProfile = NoiseReduceProfile( CProfile, nAv );
        clear CProfile
        CProfile = SProfile;
        x = 1:legth(CProfile);
    
    end
    %if statement essential returns CProfile and x

   %fit cut profile to model perp function
   [InitialGuessParameters, FittedParameters, FittedModel, Goodness, Output] = FitPerpFunction(x,CProfile);
   
   %passing data outside of this loop
   FullParameters(i,:) = FittedParameters;
   %needs to be done becuse not all profiles are same length
   eval( strcat('FullProfile', int2str(i), ' = CProfile;') );
   
   %vector of exit flags
   EF(i) = Output.exitflag;
   if( EF(i) < 1 )
        fprintf( 'Error: Fit failed! \n' );
        bFailure = 1;
   end
      
   i=i+1; 
end


%do not analyze unless fits have completed
if( bFailure == 0 )

    %showing the fits

    %if 4 images
    if( length(nImageStart:nImageEnd) == 4 )
        figure
        for i=1:4
            subplot(2,2,i);
            eval( strcat('SProfile = FullProfile', int2str(i), ';') );
            %plot(1:length(SProfile), SProfile, 'go', 1:length(SProfile), modelPerp(squeeze(FullParameters(i,:)),1:length(SProfile)) , 'rx');
            plot(Offset(i):nAv:(Offset(i)+ nAv*(length(SProfile)-1)), SProfile, 'go', Offset(i):nAv:(Offset(i)+ nAv*(length(SProfile)-1)), modelPerp(squeeze(FullParameters(i,:)),1:length(SProfile)) , 'rx');
            %title(strcat('\omega =  ',int2str(nStartingAngle + nIncrementAngle*(i-1)), ' center at  ', num2str((FullParameters(i,5)) ) ));
            title(strcat('\omega =  ',int2str(nStartingAngle + nIncrementAngle*(i-1)), ' center at  ', num2str( Offset(i) + nAv*((FullParameters(i,5))-1) ) ));
            legend( 'Data', 'Fit');
            clear SProfile;
        end

    %if 5 images
    elseif( length(nImageStart:nImageEnd) == 5 )
        figure
        for i=1:5
            subplot(2,3,i);
            eval( strcat('SProfile = FullProfile', int2str(i), ';') );
            %plot(1:length(SProfile), SProfile, 'go', 1:length(SProfile), modelPerp(squeeze(FullParameters(i,:)),1:length(SProfile)) , 'rx');
            plot(Offset(i):nAv:(Offset(i)+ nAv*(length(SProfile)-1)), SProfile, 'go', Offset(i):nAv:(Offset(i)+ nAv*(length(SProfile)-1)), modelPerp(squeeze(FullParameters(i,:)),1:length(SProfile)) , 'rx');
            if( i~=5 )
                %title(strcat('\omega =  ',int2str(nStartingAngle + nIncrementAngle*(i-1)), ' center at  ', num2str(FullParameters(i,5))));
                title(strcat('\omega =  ',int2str(nStartingAngle + nIncrementAngle*(i-1)), ' center at  ', num2str( Offset(i) + nAv*((FullParameters(i,5))-1) ) ));
            else
                %title(strcat('\omega =  ',int2str(nStartingAngle), ' center at  ', num2str(FullParameters(i,5))) );
                title(strcat('\omega =  ',int2str(nStartingAngle + nIncrementAngle*(i-1)), ' center at  ', num2str( Offset(i) + nAv*((FullParameters(i,5))-1) ) ));
            end
            legend( 'Data', 'Fit');
            clear SProfile;
        end
    end

    %determining motor movement

    if( length(nImageStart:nImageEnd) == 4 || length(nImageStart:nImageEnd) == 5 )

        if((nStartingAngle == 0)||(nStartingAngle == 180)||(nStartingAngle == -180))
            %change samXb (1,3)
            %change samZb (2,4)
            dZ = FullParameters(2,5) - FullParameters(4,5);
            dX = FullParameters(1,5) - FullParameters(3,5);
%             dZ = nAv*(OffSet(2) + FullParameters(2,5) - (OffSet(4) + FullParameters(4,5)));
%             dX = nAv*(OffSet(1) + FullParameters(1,5) - (OffSet(3) + FullParameters(3,5)));
            
            
            %convert to appropriate coordinate system of the hutch
            if(nStartingAngle == 0)

            else
                dX = -1.0*dX;
                dZ = -1.0*dZ;
            end

        elseif((nStartingAngle == -90)||(nStartingAngle == 90))
            %change samZb (1,3)
            %change samXb (2,4)
            dX = FullParameters(2,5) - FullParameters(4,5);
            dZ = FullParameters(1,5) - FullParameters(3,5);
%            dX = nAv*(Offset(2) + FullParameters(2,5) - (Offset(4) + FullParameters(4,5)));
%            dZ = nAv*(Offset(1) + FullParameters(1,5) - (Offset(3) + FullParameters(3,5)));
            
            if(nStartingAngle == 90)

            else
                dX = -1.0*dX;
                dZ = -1.0*dZ;
            end

        else
            dX = 0;
            dZ = 0;
            fprintf('Error in the starting angle \n');
        end

        fprintf(' \n');
        fprintf('Move samXb %f pixels \n', nAv*dX/2.0);
        fprintf('Move samZb %f pixels \n', nAv*dZ/2.0);
        %fprintf('Move samXb %f pixels \n', dX/2.0);
        %fprintf('Move samZb %f pixels \n', dZ/2.0);

        fprintf(' \n');
        fprintf('Move samXb %f microns \n', nAv*(dX/2.0)*fPixelSize);
        fprintf('Move samZb %f microns \n', nAv*(dZ/2.0)*fPixelSize);
        %fprintf('Move samXb %f microns \n', (dX/2.0)*fPixelSize);
        %fprintf('Move samZb %f microns \n', (dZ/2.0)*fPixelSize);
        
        clear dX;
        clear dZ;

        %consistency check on image 1 and 5
        if(length(nImageStart:nImageEnd) == 5)
            nCenterDifference = abs( (Offset(5) + nAv*FullParameters(5,5)) - (Offset(1) + nAv*FullParameters(1,5)) );
            fprintf(' \n ');
            fprintf(' Original center and 360 degree rotated position off by %f pixels', nAv*nCenterDifference);
            fprintf(' \n ' );
            fprintf(' Original center and 360 degree rotated position off by %f microns', nAv*nCenterDifference*fPixelSize);
            fprintf( '\n ');
        end
    end


    
end

end
