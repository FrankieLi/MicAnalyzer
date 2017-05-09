%
%
%  Purpose:  Go through each of the file specified by [prefix, '_0000x.tif'] and
%  fit each tiff to the absorption profile.  Note that edges are still required.
%
%  Parameters:  prefix - a string designating the prefix of the filename, i.e., 
%               'myTiff_04912.tif', prefix = 'myTiff_'
%
%
%               startNum, stopNum - first and last number
%
%               edges - edges of the beam profile
%
function [centers, params, param_errors, intensities, intensity_errors] = PeakLocationFitting( prefix, startNum, stopNum, edges )


centers = length([startNum:stopNum]);
params = zeros( length(centers), 6 );
param_errors = zeros( length(centers), 6 );
intensities = centers;
intensity_errors = centers;

j = 1;
for i = startNum:stopNum
   
    numStr = padZero( i, 5 );
    filename = [prefix, numStr, '.tif'];
    img = imread( filename );
    

    [center, x, F, F_error, yData, newParm, newParm_Ci, residual, F_var] = LocateAbsorptionCenter( img, 0.1, edges );
    
    AbsorptionIntensity = newParm(5) .* newParm(6);
    AbsorptionIntensity = AbsorptionIntensity ./ newParm(2);
    
    intensities(j) = AbsorptionIntensity;
    

    if i == 17 
        i = i;
    end
 
    
    
    %
    % Uncertainty propagation - This has to be done manually
    %  
    % calculate the partial derivatives, dI/d(parm(i))
    % 
    % Note that this is the intensity coefficient
    %
    %  I = param(5)/ ( 3 * param(2) )
    %
    %  a. k. a.  I = Absorption / (3* background)
    %
    % [ dI/ d Absorption, dI/ d background ]
    %
    %
    dV = [ 1 / (3 * newParm(2)); - newParm(5) / ( 3 * newParm(2)^2 ) ];
    
    % calculate the covariance matrix for the variables used to calculate intensity
    Intensity_Cov =[  F_var(5, 5),  F_var(5, 2) ;...
                      F_var(2, 5),  F_var(2, 2) ];
    
                  
    %  Errors = d' * Cov * d, where d is the partial derivative vector
    intensity_errors(j) = sqrt(dV' * Intensity_Cov * dV);
    
    
    centers(j) = center;
    params(j, :) = newParm;
    param_errors(j, :) = sqrt( diag( F_var ) );
    j = j + 1;
end

Cov = F_var;

disp('done');

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% %  A0    = parm(1)
% %  omega = parm(2)
% %  phi   = parm(3)
% function [ F, F_J ] = PositionTimeSeries( parm, xData )
% 
% 
% F = parm(1) * sin( parm(2) * xData + parm(3) );
% 
% if nargout > 1   % two output arguments
% 
%     F_x_A0 = sin( parm(2) * xData - parm(3) );
%     
%     F_x_omega = parm(1) * cos( parm(2) * xData - parm(3) ) .* xData;
%     
%     F_x_phi = -parm(1) * cos( parm(2) * xData - parm(3) );
%     
%     F_J = [ F_x_A0, F_x_omega, F_x_phi ];
% end
