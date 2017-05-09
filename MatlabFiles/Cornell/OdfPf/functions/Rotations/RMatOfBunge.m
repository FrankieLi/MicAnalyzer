function rmat = RMatOfBunge(bunge, units)
% RMatOfBunge - Rotation matrix from Bunge angles.
%
%   USAGE:
%
%   rmat = RMatOfBunge(bunge, units)
%
%   INPUT:
%
%   bunge is 3 x n,
%         the array of Bunge parameters
%   units is a string,
%         either 'degrees' or 'radians'
%       
%   OUTPUT:
%
%   rmat is 3 x 3 x n,
%        the corresponding rotation matrices
%   
if (nargin < 2)
  error('need second argument, units:  ''degrees'' or ''radians''')
end
%
if (strcmp(units, 'degrees'))
  %
  indeg = 1;
  bunge = bunge*(pi/180);
  %
elseif (strcmp(units, 'radians'))
  indeg = 0;
else
  error('angle units need to be specified:  ''degrees'' or ''radians''')
end
%
n    = size(bunge, 2);
cbun = cos(bunge);
sbun = sin(bunge);
%
rmat = [
     cbun(1, :).*cbun(3, :) - sbun(1, :).*cbun(2, :).*sbun(3, :);
     sbun(1, :).*cbun(3, :) + cbun(1, :).*cbun(2, :).*sbun(3, :);
     sbun(2, :).*sbun(3, :);
    -cbun(1, :).*sbun(3, :) - sbun(1, :).*cbun(2, :).*cbun(3, :);
    -sbun(1, :).*sbun(3, :) + cbun(1, :).*cbun(2, :).*cbun(3, :);
     sbun(2, :).*cbun(3, :);
     sbun(1, :).*sbun(2, :);
    -cbun(1, :).*sbun(2, :);
     cbun(2, :)
    ];
rmat = reshape(rmat, [3 3 n]);
%
%  From MPS:  pxutils.f
%
%        mat(1, 1) =  c1*c3 - s1*c2*s3
%        mat(2, 1) =  s1*c3 + c1*c2*s3
%        mat(3, 1) =  s2*s3
%        mat(1, 2) = -c1*s3 - s1*c2*c3
%        mat(2, 2) = -s1*s3 + c1*c2*c3
%        mat(3, 2) =  s2*c3
%        mat(1, 3) =  s1*s2
%        mat(2, 3) = -c1*s2
%        mat(3, 3) =  c2
