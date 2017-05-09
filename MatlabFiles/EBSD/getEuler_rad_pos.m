%
%
%  Return v' = R v - transforming column vectors
%%
function R = getEuler_rad_pos(e)

% % 
% % eInv = e;
% % eInv(3) = -e(1);
% % eInv(2) = -e(2);
% % eInv(1) = -e(3);
% % 
% % R = getR(eInv);
% % R = R;

omega = e(1);
chi = e(2);
phi = e(3);
comega = cos(omega);
somega = sin(omega);

cchi = cos(chi);
schi = sin(chi);

cphi = cos(phi);
sphi = sin(phi);



    R(1,1) =  comega * cphi - somega * cchi * sphi;
    R(1,2) = -comega * sphi - somega * cchi * cphi;
    R(1,3) =  somega * schi;

    R(2,1) =  somega * cphi + comega * cchi * sphi;
    R(2,2) = -somega * sphi + comega * cchi * cphi;
    R(2,3) = -comega * schi;

    R(3,1) =  schi * sphi;
    R(3,2) =  schi * cphi;
    R(3,3) =  cchi;
