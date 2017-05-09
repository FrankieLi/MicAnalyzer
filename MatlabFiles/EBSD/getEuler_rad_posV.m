function R = getEuler_rad_posV(e)




% % 
% % phi = e(1);
% % theta = e(2);
% % psi = e(3);
% % 
% % R= zeros(3,3);
% % R(1,1, :) = cos(psi)*cos(phi) - cos(theta) *sin(phi) * sin(psi);
% % R(2,1, :) = -sin(psi)*cos(phi) - cos(theta) * sin(phi) * cos(psi);
% % R(3,1, :) = sin(theta) * sin(phi);
% % 
% % R(1,2, :) = cos(psi)*sin(phi) + cos(theta) * cos(phi) * sin(psi);
% % R(2,2, :) = -sin(psi) * sin(phi) + cos(theta)*cos(phi)*cos(psi);
% % R(3,2, :) = -sin(theta)*cos(phi);
% % 
% % R(1,3, :) = sin(psi)*sin(theta);
% % R(2,3, :) = cos(psi)* sin(theta);
% % R(3,3, :) = cos(theta);



omega = e(:, 1);
chi = e(:, 2);
phi = e(:, 3);
comega = cos(omega);
somega = sin(omega);

cchi = cos(chi);
schi = sin(chi);

cphi = cos(phi);
sphi = sin(phi);

% if(pm == 1)
eSize = size(e);
R = zeros(3, 3, eSize(1));
R(1,1, :) =  comega .* cphi - somega .* cchi .* sphi;
R(2,1, :) =  somega .* cphi + comega .* cchi .* sphi;
R(3,1, :) =  schi .* sphi;

R(1,2, :) = -comega .* sphi - somega .* cchi .* cphi;
R(2,2, :) = -somega .* sphi + comega .* cchi .* cphi;
R(3,2, :) =  schi .* cphi;

R(1,3, :) =  somega .* schi;
R(2,3, :) = -comega .* schi;
R(3,3, :) =  cchi;
% % else
% %     R(1,1) =  comega * cphi - somega * cchi * sphi;
% %     R(2,1) = -comega * sphi - somega * cchi * cphi;
% %     R(3,1) =  somega * schi;
% % 
% %     R(1,2) =  somega * cphi + comega * cchi * sphi;
% %     R(2,2) = -somega * sphi + comega * cchi * cphi;
% %     R(3,2) = -comega * schi;
% % 
% %     R(1,3) =  schi * sphi;
% %     R(2,3) =  schi * cphi;
% %     R(3,3) =  cchi;
% % end