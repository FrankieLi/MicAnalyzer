%
%
%  Going to switch to the Cornell ODFPF
%
%
function q = EulerToQuaternion(Eu)

q = QuatOfRMat( RMatOfBunge(Eu', 'radians' ) );

q = circshift( q, -1 )';  % get it back to our convention of x, y, z, w