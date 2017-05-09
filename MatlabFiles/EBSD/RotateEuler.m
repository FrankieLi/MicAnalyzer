%
%
%
%  Do a basis transformation to the rotation matrix given by the euler
%  angles inputted.
%
%  input in radian, output in radian
function output = RotateEuler(origEuler, Eu)


transformMatrix = getEuler_rad_pos(Eu);

origSize = size(origEuler);

origEuler = origEuler;

origR = getEuler_rad_posV(origEuler);

output = zeros(origSize(1), origSize(2));

% doing this:
% tmpR = transformMatrix * origR(:, :, i);%* transformMatrix';
% in a hopefully faster way

TR = zeros(3, 3, origSize(1));
for i = 1:3
    for j = 1:3
        TR(i, j, :) = transformMatrix(i, j);
    end
end
tmpR = multiprod(TR, origR);


for i = 1:origSize(1)
%    tmpOrigR = origR(i, :, :);
    
    output(i, :) = EulerFromR(tmpR(:, :, i), 1);  % run with positive rotation
end

output = output;