%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    PerpTest
%
%    Takes in mulitple images of direct beam as ROI, 
%    fits the beam profile to a model Perp function,
%    using the fit amplitude of gaussian (absorber),
%    plots A as a function of omega
%
%    Usage:
%    PerpTest( sImagePrefix, nImageStart, nImageEnd, nStartAngle, nIncrementAngle)
%
%    Example:
%    PerpTest( 'CenteringImage_', 4, 8, -90, 90)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = PerpTest(sImagePrefix, nImageStart, nImageEnd, nStartingAngle, nIncrementAngle)

modelPerp = @(p,x) p(1).*exp(-4*log(2)*(((x - p(5)).^2)./(p(7)).^2)) + p(2) + p(3).*(x-p(6)) + p(4)*((x-p(6)).^2);

nAv = 5;

i=1;
bFailure=0;
FullParameters = zeros(length(nImageStart:nImageEnd),7);
for j=nImageStart:nImageEnd
   im = imread( strcat(sImagePrefix, padZero(j,5), '.tif') );
   %background subtracted image
   im = abs(im - min(min(im)));
   %apply median filter
   im = medfilt2( im );
   %background subtracted profile of the beam
   Profile = sum( im, 1);
   

%   %cut off edges of the profile that do not include the beam
%   CProfile = CutProfile( Profile );
%   
%   nAv = 5;
%   
%   SProfile = NoiseReduceProfile( CProfile, nAv);
%   x=1:length(SProfile);
 
   SProfile = NoiseReduceProfile( Profile, nAv );
   [CProfile, CutLeftIndex] = CutProfile( SProfile );
   Offset(j) = CutLeftIndex*nAv;
   x = 1:length(CProfile);

  
   %fit cut profile to model perp function
   [InitialGuessParameters, FittedParameters, FittedModel, Goodness, Output] = FitPerpFunction(x,SProfile);
   
   %passing data outside of this loop
   FullParameters(i,:) = FittedParameters;
   %needs to be done because not all profiles are same length
   eval( strcat('FullProfile', int2str(i), ' = SProfile;') );
   
   %vector of exit flags
   EF(i) = Output.exitflag;
   if( EF(i) < 1 )
        fprintf( 'Error: Fit failed! \n' );
        bFailure = 1;
   end
      
   i=i+1; 
end

nEndAngle = nStartingAngle + (length(nImageStart:nImageEnd) - 1)*nIncrementAngle;
%do not analyze unless fits have completed
if( bFailure == 0 )

    %if 4 or 5 images
    if( length(nImageStart:nImageEnd) == 4 || length(nImageStart:nImageEnd) == 5 )
        figure
        nStartingAngle
        plot(nStartingAngle:nIncrementAngle:nEndAngle, abs( FullParameters(:,1) ) );
        title(strcat('Amplitude vs. \omega'));
        xlabel( '\omega' );
    end
    
end

end
