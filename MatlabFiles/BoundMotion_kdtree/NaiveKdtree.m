function NaiveKdtree(map1, map2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function simply produces a kdtree using x,y,z points and GrainID pairs.
%
% INPUT : 
%         map# - x,y,z,GID_1, GID_2
% OUTPUT:
%        Figure 1 - red dots -> map1
%                   black dots -> map2
%
%        Figure 2 - red dots -> map1
%                   black dots -> map2
%                   lines -> displacement from map 1 to map 2
%                         produced with kdtree on map1 finding single 
%                         nearest points to map2.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
map1_spatial = map1(:,1:3);
map1_spatial_GN = map1;

map2_spatial = map2(:,1:3);
map2_spatial_GN = map2;

%First naively get the nearest points using a tree with GrainNs and spatial
%coords
[close_in1to2, dist_in1to2, kdholder1] = kdtree(map1_spatial_GN, map2_spatial_GN);
[close_in2to1, dist_in2to1, kdholder2] = kdtree(map2_spatial_GN, map1_spatial_GN);

kdtree(kdholder1, [],[]);
kdtree(kdholder2, [],[]);

%close_in1to2(i,:) is the point in map1_spatial_GN that is closest to
%map2_spatial_GN(i,:);

%dist_in1to2(i) is the euclid distance from close_in1to2(i,:) to
%map1_spatial_GN(i,:)

%Overlay the two maps
figure(1)
plot(map1_spatial_GN(:,1), map1_spatial_GN(:,2), '.r');
hold on
plot(map2_spatial_GN(:,1), map2_spatial_GN(:,2), '.k');
axis equal


%Draw lines from nearest points in 1 to thier counterparts in 2. (every pt
%in map2 has a line.)
figure(2)
plot(map1_spatial_GN(:,1), map1_spatial_GN(:,2), '.r');
hold on
plot(map2_spatial_GN(:,1), map2_spatial_GN(:,2), '.k');
hold on
size(close_in1to2)
size(map2_spatial_GN)
for i=1:size(close_in1to2,1)
    line([close_in1to2(i,1),map2_spatial_GN(i,1)], [close_in1to2(i,2), map2_spatial_GN(i,2)], 'Color','g');
    hold on
end
% hold on
% Draw lines from nearest points in 2 to counterpart in 1.
% for i=1:size(close_in1to2,1)
%     line([close_in2to1(i,1),map1_spatial_GN(i,1)], [close_in2to1(i,2), map1_spatial_GN(i,2)], 'Color','g');
%     hold on
% end
axis equal
