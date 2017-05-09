function angle = misorient_rad(e1, e2)


m1 = getEuler_rad_neg(e1);
m2 = getEuler_rad_pos(e2);

Dg = m1 * m2; %MatMult(m1, m2, Dg);

dg_trace = trace(Dg);

if(dg_trace >= 3)
    angle = 0.;
else
    angle = acos(0.5 * (dg_trace - 1.0) );

end
