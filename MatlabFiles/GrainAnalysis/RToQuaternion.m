function q = EulerToQuaternion(R)

q = zeros(1, 4);

%q4 is the scalar

% 
% 
% q(1) = (R(3, 2) - R(2, 3))/ (2 * sqrt(1 + trace(R)) );
% q(2) = (R(1, 3) - R(3, 1))/ (2 * sqrt(1 + trace(R)) );
% q(3) = (R(2, 1) - R(1, 2))/ (2 * sqrt(1 + trace(R)) );
% q(4) = ( sqrt( 1 + trace(R) ) /2 );




q(1) = (R(2, 3) - R(3, 2))/ (2 * sqrt(1 + trace(R)) );
q(2) = (R(3, 1) - R(1, 3))/ (2 * sqrt(1 + trace(R)) );
q(3) = (R(1, 2) - R(2, 1))/ (2 * sqrt(1 + trace(R)) );
q(4) = ( sqrt( 1 + trace(R) ) /2 );






