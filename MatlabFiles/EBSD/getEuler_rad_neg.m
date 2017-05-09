%
%
%  Return v' = R v - transforming column vectors
%%
function R = getEuler_rad_neg(e)


% % R = getR(e);
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
    R(1,2) =  somega * cphi + comega * cchi * sphi;
    R(1,3) =  schi * sphi;

    R(2,1) = -comega * sphi - somega * cchi * cphi;
    R(2,2) = -somega * sphi + comega * cchi * cphi;
    R(2,3) =  schi * cphi;

    R(3,1) =  somega * schi;
    R(3,2) = -comega * schi;
    R(3,3) =  cchi;
