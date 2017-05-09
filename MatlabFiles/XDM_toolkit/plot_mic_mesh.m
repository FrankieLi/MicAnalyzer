%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%  plot_mic_mesh.m
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File Format:
% Col 1-3 x, y, z
% Col 4   1 = triangle pointing up, 2 = triangle pointing down
% Col 5 generation number; triangle size = sidewidth /(2^generation number )
% Col 6 Phase - 1 = exist, 0 = not fitted
% Col 7-9 orientation
% Col 10  Confidence
%
function plot_mic(snp, sidewidth, minConfidence)


findvec = find(snp(:, 10) > minConfidence);
snp = snp(findvec, :);

% saving the dividing factor to generation column
snp(:,5) = 2.^ snp(:, 5);


% find range

max_x = 1*sidewidth;
max_y = 1*sidewidth;
min_x = -1*sidewidth;
min_y = -1*sidewidth;

% find all fitted triangles
snp = sortrows(snp, 6);
findvec = find(snp(:, 6) > 0);
snp = snp(findvec, :);

% sort by triangle
snp = sortrows(snp, 4);

% find triangles pointing up
downsIndex = find(snp(:, 4) > 1);
upsIndex = find(snp(:, 4) <= 1);

ups = snp(upsIndex, :);
downs = snp(downsIndex, :);


ups_sides = sidewidth ./ ups(:, 5);
downs_sides = sidewidth ./ downs(:, 5);

% calculate ups v1, ups v2, and ups v3
ups_v1 = ups(:, 1:2);      % (x, y)
ups_v2 = ups(:, 1:2);
ups_v2(:, 1) = ups_v2(:, 1) + ups_sides;  % (x+s, y) direction
ups_v3 = ups(:, 1:2);
ups_v3(:, 1) = ups_v3(:, 1) + ups_sides/2; % (x+s/2, y)
ups_v3(:, 2) = ups_v3(:, 2) + ups_sides/2 * sqrt(3); % (x+s/2, y+s/2 *sqrt(3));


% calculate downs v1, downs v2, and downs v3
downs_v1 = downs(:, 1:2);      % (x, y)
downs_v2 = downs(:, 1:2);
downs_v2(:, 1) = downs_v2(:, 1) + downs_sides;  % (x+s, y) direction
downs_v3 = downs(:, 1:2);
downs_v3(:, 1) = downs_v3(:, 1) + downs_sides/2; % (x+s/2, y)
downs_v3(:, 2) = downs_v3(:, 2) - downs_sides/2 * sqrt(3); % (x+s/2, y - s/2 *sqrt(3));

% format is in [v1; v2; v3], where v1, v2, and v3 are rol vectors
tri_x = [ [ups_v1(:, 1); downs_v1(:, 1)]'; [ups_v2(:, 1); downs_v2(:, 1)]'; [ups_v3(:, 1); downs_v3(:, 1)]'];
tri_y = [ [ups_v1(:, 2); downs_v1(:, 2)]'; [ups_v2(:, 2); downs_v2(:, 2)]'; [ups_v3(:, 2); downs_v3(:, 2)]'];




figure;
axis([min_x, max_x, min_y, max_y]);

tri_size = size(tri_x);
tri_length = tri_size(2);
hold on;
for i = 1:tri_length
    line(tri_x(:, i), tri_y(:, i));
end
hold off;