%%
%%   CSLFamilyGenerator
%%   Implementation of "The Generating Function for Coincidence Site
%%   Lattices in a Cubic System", *Hans Grimmer*, Acta Cryst. ( 1984), A40,
%%   108-112
%%
%%   Authors:  Chris Hefferan
%%   
%%
%%
%%
%%
function [axis,angle] = GenerateCSLFromFamily(m0,u0,v0,w0)

q(1,:) = abs([m0,u0,v0,w0]);
q(2,:) = abs([m0+u0, m0-u0, v0+w0, v0-w0]);
q(3,:) = abs([m0+v0, m0-v0, u0+w0, u0-w0]);
q(4,:) = abs([m0+w0, m0-w0, u0+v0, u0-v0]);
q(5,:) = abs([m0+u0+v0+w0, m0+u0-v0-w0, m0-u0+v0-w0, m0-u0-v0+w0]);
q(6,:) = abs([m0+u0+v0-w0, m0+u0-v0+w0, m0-u0+v0+w0, m0-u0-v0-w0]);

for i=1:6
    q(i,:) = sort(q(i,:));
    q(i,:) = flipdim(q(i,:),2);
end

Q = q;
Q = unique(Q,'rows');

for i=1:size(Q,1)
    q_cur = [];
    q_cur = Q(i,:);
        ang(i) = 2*atan(sqrt(q_cur(2)^2 + q_cur(3)^2 + q_cur(4)^2)/q_cur(1))*(180/pi);
        axis(i,:) = [q_cur(2), q_cur(3), q_cur(4)];
end

idxMinAng = find(ang == min(ang));
angle = ang(idxMinAng);
axis = axis(idxMinAng,:);
