%%
%%  calculate the misorientation angle between e1 and e2,
%%  which is in degree.
%%
%%
function minAngle = misorient_deg(e1, e2, symOps)

% change to radians
e1 = e1 * pi/180;
e2 = e2 * pi/180;

m1 = getEuler_rad_neg(e1);
m2 = getEuler_rad_pos(e2);

Dg = m1 * m2; %MatMult(m1, m2, Dg);

symOpsSize = size(symOps);
angle = [];
for i = 1:symOpsSize(3) 
    
    dg_trace = trace(symOps(:, :, i) * Dg);
    
    if dg_trace >= 3
        angle(i) = 0.;
    else
        angle(i) = acos(0.5 * (dg_trace - 1.0) );
    end

end
minAngle = min(angle) * 180/pi; % convert back to degree

