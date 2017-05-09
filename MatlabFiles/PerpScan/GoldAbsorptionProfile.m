%
%  Purpose:  Our model of the beam profile under absorption of gold wire.
%
%  P(x) +  Gaussian
%
%  P(x) being:
%  
%  A_0 ( x- origin ) + B_0 ( x - origin ) ^2 + Background
%
%  Gaussian =  Absorption * exp( -4 * log(2) * xDiff.^2 /FWHM^2 )
%
%  parm is listed as:
%  [ 
%    origin
%    Background
%    A_0
%    B_0
%    Absoprtion
%    FWHM
%
%    ]
function [ F, F_J ]= GoldAbsorptionProfile(parm, xData);

Origin = parm(1);
Background = parm(2);
A_0 = parm(3);
B_0 = parm(4);
Absorption = parm(5);
FWHM = parm(6);

xDiff = xData - Origin;

F = Background + A_0 * xDiff + B_0 * xDiff.^2 + ...
    Absorption * exp( -4 * log(2) * xDiff.^2 /FWHM^2 );


if nargout > 1   % two output arguments
    F_J = ProfileJacobian( parm, xData );
end

% %
%
% For debugging only
%
% P = Background + A_0 * xDiff + B_0 * xDiff.^2;
% G = Absorption * exp( -4 * log(2) * xDiff.^2 /FWHM^2 );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%
%
%
function F = ProfileJacobian( parm, xData )

Origin = parm(1);
Background = parm(2);
A_0 = parm(3);
B_0 = parm(4);
Absorption = parm(5);
FWHM = parm(6);

% dF/d(origin)
deltaX = xData - Origin;

F_x_origin = - A_0 - 2 * B_0 * deltaX  + 8 * Absorption * deltaX * log(2) / FWHM^2 .*...
           exp( - 4 * log(2) * deltaX.^2 / FWHM^2 );
       
F_x_Background = ones( length( xData ), 1 );

F_x_A_0 = deltaX;

F_x_B_0 = deltaX .^ 2;

F_x_Absorption = exp( - 4 * log(2) * deltaX .^ 2 / FWHM^2 );

F_x_FWHM = 8 * Absorption * deltaX .^ 2 * log(2) / FWHM^3 .* exp( - 4 * log(2) * deltaX .^ 2 / FWHM^2 );

F = [F_x_origin, F_x_Background, F_x_A_0, F_x_B_0, F_x_Absorption, F_x_FWHM];

disp('done');

