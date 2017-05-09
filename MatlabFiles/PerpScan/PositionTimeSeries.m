

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  A0    = parm(1)
%  omega = parm(2)
%  phi   = parm(3)
%  Bkg   = parm(4)
function [ F, F_J ] = PositionTimeSeries( parm, xData )


F = parm(1) * sin( parm(2) * xData + parm(3) ) + parm(4);

if nargout > 1   % two output arguments

    F_x_A0 = sin( parm(2) * xData - parm(3) );
    
    F_x_omega = parm(1) * cos( parm(2) * xData - parm(3) ) .* xData;
    
    F_x_phi = -parm(1) * cos( parm(2) * xData - parm(3) );
    
    F_x_Bkg = ones(1, xData);
    
    F_J = [ F_x_A0, F_x_omega, F_x_phi ];
end