%
%  LocateAbsorptionCenter
%
%  
%
%  Purpose:  Find the x-ray beam, fit a Gaussian to the aborption peak due to
%            the gold wire in the perp-test.
%
%
%
%  Parmaters:  snp - tif files read in by imread 
%              threshold - minimum fraction of the minimum that will be counted as the beam (horizontal)
%              edges - the location of the edges of the beam (top and bottom)
%              number of iterations to run the nonlinear fit
%
%  Return:   Center - location of the peak in the original image coordinate
%            x - the pixel locations for the profile
%            F - the fitted function 
%            yData - original beam profile
%            newParm - new set of parmater, there are 6 of them in our beam profile model 
%                                             (see GoldAbsorptionProfile.m )
%            residual - F(x_i) - y_i
%            F_Ci     - (95%) confident interval of the parameters
%
%
function [center, x, yFitted, yError, yData,  newParm, newParm_Ci, residual, F_Cov] ...
    = LocateAbsorptionCenter( snp, threshold, edges, numIter )

%
%
%  The beam is "vertical" in the image.  First find the location, or the
%  horizontal extent of the beam.
%
%

imageSize = size( snp );
yDim = imageSize(1);
xDim = imageSize(2);

horProfile = sum( snp, 1);

amp = max( horProfile ) - min( horProfile );
findvec = find( horProfile > amp * threshold + min( horProfile ) );


vertProfile = sum( snp( :, findvec ), 2 );
tmp = [1:length(vertProfile)];
vertProfile = [ tmp', vertProfile ];

% not finding edge right now, just using input

vertProfile = vertProfile( edges(1):edges(2), :);

%
% set initial parameter for curve fit
%

% find A_0 and B_0 for the part of the fit: A_0 x + B_0 x^2
%
% A_0 x_0 + B_0 x_0^2 = y_0
% A_0 x_1 + B_0 x_1^2 = y_1
% A_0 x_2 + B_0 x_2^2 = y_2
% Then:
%
% X  * [A; B; C]  = [y_0; y_1, y_2]
%
% choose some x_0, x_1, x_2


findmax = find(vertProfile(:, 2) == max(vertProfile(:, 2) ) );


origin = findOrigin( vertProfile );
x0 = vertProfile(10, 1) - origin;
y0 = vertProfile(10, 2);

x1 = vertProfile(findmax(1), 1) - origin;
y1 = vertProfile(findmax(1), 2);

x2 = vertProfile(end - 10, 1) - origin;
y2 = vertProfile(end - 10, 2);

mat = [x0, x0^2, 1;...
       x1, x1^2, 1;...
       x2, x2^2, 1];
   
tmp = inv( mat ) * [y0; y1; y2];
originLoc = find( vertProfile(:, 1) == origin );
% assign A_0 and B_0
initParm(1) = origin;
initParm(3) = tmp(1);
initParm(4) = tmp(2);
initParm(2) = tmp(3);
initParm(5) = vertProfile(originLoc, 2) - max(vertProfile(:, 2));
initParm(6) = 5;

yData = vertProfile(:, 2);
%
% curve fit
%
[ newParm,residual,F_J] = nlinfit( vertProfile(:, 1), vertProfile(:, 2), @GoldAbsorptionProfile, initParm );

%
%
%  Note that a square root is involved with newParm(6), FWHM, so we have to
%  make sure that it is positive.

newParm(:, 6) = abs( newParm(:, 6) );

newParm_Ci = nlparci( newParm, residual, F_J );  % get 95% confidence interval


x = vertProfile(:, 1);


center = newParm(1) + edge(1);
[yFitted, yError] = nlpredci( @GoldAbsorptionProfile, x, newParm, residual, F_J );


%
%  Remember to divide by degrees of freedom
%
F_Cov = sum(residual.^2) * inv( F_J' * F_J ) / ( length( vertProfile(:, 1) )...
                                             - length( initParm ) );
% plotting ---

close all;
figure;
hold on;
tmpP = sum( snp( :, findvec ), 2 );
tmpX = [1:length(tmpP)];
% errorbar( x, yFitted, yError);

plot( tmpX, tmpP, 'k.',x, yFitted,'r' );

title('Fitted Peak Profile');
ylabel('Intensity (arb. unit)');
xlabel('pixel position');
hold off;


disp('test');



%
%
%
%
function origin = findOrigin( profile )

%
%
%  Look for maximum change in diffential in window
%

profile_diff = diff( profile(:, 2) );

window_size = 3;
max_diff = 0;
for i = 1+ window_size : length(profile_diff) - window_size
    window = profile_diff( i - window_size: i );
    window_diff = abs( max( window ) - min( window ) );  % signature of derivative of a gaussian

    if ( window_diff > max_diff )
        max_diff = window_diff;
        max_index = floor( i - window_size /2 );
    end
end

origin = profile( max_index, 1 );

%
%  Old Method
%

% get the central 20%
% len = length( profile(:, 2) );
% central = profile( floor(len* 0.4):floor(len*0.6), 2 );
% findvec = find(profile(:,2) == min(central) );
% if( numel(findvec) > 1 )
%     findvec = findvec(1)
% end
% origin = profile(findvec, 1);

