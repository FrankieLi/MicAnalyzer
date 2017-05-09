function [axis, angle] = AxisAngleOfQuat(q)
% AxisAngleOfQuat - angle/axis pair from quaternions.
%
%   USAGE:
%
%   quat = QuatOfAngleAxis(angle, rotaxis)
%
%   INPUT:
%
%   angle is an n-vector, 
%         the list of rotation angles
%   raxis is 3 x n, 
%         the list of rotation axes, which need not
%         be normalized (e.g. [1 1 1]'), but must be nonzero
%
%   OUTPUT:
%
%   quat is 4 x n, 
%        the quaternion representations of the given
%        rotations.  The first component of quat is nonnegative.
%   


angle = 2 * acos( min( q(1, :), 1));
axis = q(2:4, :);

w =  sqrt( max( 1 - q(1, :).^2, 0) );
axis(1, :) = axis(1, :) ./ w;
axis(2, :) = axis(2, :) ./ w;
axis(3, :) = axis(3, :) ./ w;

end