% returns R that rotates a row vector
% i.e., v'  = R * v in active rotation 

function R = getR(e)

phi = e(1);
theta = e(2);
psi = e(3);

R= zeros(3,3);
R(1,1) = cos(psi)*cos(phi) - cos(theta) *sin(phi) * sin(psi);
R(2,1) = -sin(psi)*cos(phi) - cos(theta) * sin(phi) * cos(psi);
R(3,1) = sin(theta) * sin(phi);

R(1,2) = cos(psi)*sin(phi) + cos(theta) * cos(phi) * sin(psi);
R(2,2) = -sin(psi) * sin(phi) + cos(theta)*cos(phi)*cos(psi);
R(3,2) = -sin(theta)*cos(phi);

R(1,3) = sin(psi)*sin(theta);
R(2,3) = cos(psi)* sin(theta);
R(3,3) = cos(theta);
