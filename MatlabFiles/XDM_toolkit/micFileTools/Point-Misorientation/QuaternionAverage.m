function [aveQuat] = QuaternionAverage(quatList)
% QuaternionAverage - 
%
%   USAGE:
%
%   [aveQuat] = QuaternionAverage(quatList)
%
%   INPUT:
%
%   quatList is 4 x n,
%       a list of n unit quaternions that are to be averaged
%
%   OUTPUT:
%
%   aveQuat is 4 x 1,
%       is the unit quaternion corresponding to the quaternion average of
%       the list of input quaternions.
%
%   NOTES:  
%
%   none
%

    M=0;
    temp = size(quatList);
    listSize = temp(2);
    for i=1:listSize
        q = quatList(:, i);
        qt = transpose(q);
        M = M + q * qt;
    end
    [vectors, values] = eig(M);
    maxValue = max(max(values));
    ind= find(values(:) == maxValue);
    ind = ind(1);
    ind = sqrt(ind);
    aveQuat = vectors(:,ind);
    norm = sqrt(aveQuat(1)^2 + aveQuat(2)^2 + aveQuat(3)^2 + aveQuat(4)^2);
    aveQuat = aveQuat/norm;
end