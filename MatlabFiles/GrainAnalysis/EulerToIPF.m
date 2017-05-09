function IPFvector = EulerToIPF(h, Eu)


g = getEuler_rad_neg(Eu);

h = h /norm(h);

h = g * h;  % rotate axis to the correct orientation

theta = acos(h(3));
phi = atan2(h(2), h(1));  % atan(h(2)/h(1))

IPFvector = zeros(2, 1);
IPFvector(1) = tan(theta/2) * cos(phi);
IPFvector(2) = tan(theta/2) * sin(phi);
