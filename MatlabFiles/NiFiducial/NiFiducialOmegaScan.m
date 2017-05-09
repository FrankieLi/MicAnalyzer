%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    NiFiducialOmegaScan
%
%    Takes in mulitple images of direct beam as ROI, 
%    plots the beam profile
%    fit to some kind of step function
%    plot width of step function vs omega value
%    ##fits the beam profile to a model Perp function,
%    ##using the fit center position,
%    ##determines which directions the sample motors must move
%
%    Usage:
%    NiFiducialOmegaScan( sImagePrefix, nImageStart, nImageEnd, sImagePostfix,
%                           nDigits, nStartAngle, nIncrementAngle, nAutoFindRegion )
%
%    if nAutoFindRegion = 1, will cut the beam
%    else give range of profile
%
%    Example:
%    NiFiducialOmegaScan( 'NiFiducialImage_', 1, 50, '.tif', ...
%                               5, -12, 0.1, 1 )
%    NiFiducialOmegaScan( 'NiFiducialImage_', 1, 50, '.tif', ...
%                               5, -12, 0.1, 600:1200 )
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = NiFiducialOmegaScan(sImagePrefix, nImageStart, nImageEnd, sImagePostfix, nDigits, nStartingAngle, nIncrementAngle, nAutoFindRegion)

bFailure=0;
nAv = 1;
CutRightIndex = 0;
CutLeftIndex = 0;
figure
hold on
color_range = length( nImageStart:nImageEnd );
max_d_ind = -1;
max_d = -1;
legend_string = 'legend( ';
for j=nImageStart:nImageEnd
    if( j ~= nImageEnd )
        legend_string = [legend_string, char(39), num2str( nStartingAngle + (j-nImageStart)*nIncrementAngle ), char(39), ' , ' ];
    else
        legend_string = [legend_string, char(39), num2str( nStartingAngle + (j-nImageStart)*nIncrementAngle ), char(39), ' );'];
    end
    im = imread( [sImagePrefix, padZero(j,nDigits), sImagePostfix] );
    %background subtracted image
    im = abs(im - min(min(im)));
    %apply median filter
    im = medfilt2(im);
    %background-subtracted filter profile of the beam
    Profile = sum( im, 1);
    CProfile = 0;
    if( nAutoFindRegion(1) == 1 )
        %autofindregion
        if( j == nImageStart )%only search for region on first image, rest will fall in the same range for easy comparison
            nAvBroad = 32;%searching to max and min values, need only a coarse profile
            SProfile = NiNoiseReduceProfile( Profile, nAvBroad );
            [CProfile, CutRightIndex, CutLeftIndex] = NiCutProfile( SProfile );
            CutRightIndex = (nAvBroad/nAv)*CutRightIndex;
            CutLeftIndex = (nAvBroad/nAv)*CutLeftIndex;
            clear SProfile
        end
        SProfile = NiNoiseReduceProfile( Profile, nAv );
        Offset(j) = CutLeftIndex*nAv;
        clear CProfile
        CProfile = SProfile( CutLeftIndex:CutRightIndex );
        x = 1:length(CProfile);        
        %Normalize profiles
        CProfile = CProfile - min( CProfile );
        CProfile = CProfile/(max(CProfile));
        
        %figure
        plot( CProfile, 'Color', [(j-nImageStart)/color_range 0 (nImageEnd-j)/color_range] )
        
        %calculate the max value of the derivative
        %finds which plot has largest value
        if( max( abs( diff( CProfile ) ) ) > max_d )
            max_d = max( abs( diff( CProfile ) ) );
            max_d_ind = j;
        end
        
    else
        %user defined cut region
        %%CProfile = Profile( nAutoFindRegion );
        %%Offset(j) = min(nAutoFindRegion);
        %%SProfile = NiNoiseReduceProfile( CProfile, nAv );
        %%clear CProfile
        %%CProfile = SProfile;
        %%x = 1:legth(CProfile);
    end
    %if statement essentialy returns CProfile and x

    % in this convention (seeing the L), edges should be peaks
    % of difference of profile
    
    
end

eval( legend_string )

fprintf( ['\n Max derivative value found within cut range in image ', int2str( max_d_ind ), '\n Omega : ', num2str( nStartingAngle + (max_d_ind - nImageStart)*nIncrementAngle ), '\n \n'] );

end
