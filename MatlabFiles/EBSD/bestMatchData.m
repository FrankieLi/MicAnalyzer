function output = bestMatchData(ebsd, ebsd_sidewidth, mic, mic_sidewidth)


% convert to correct units
%
% ebsd data - micron
% mic files - mm
%
%
% ebsd data:  radian
% mic file:  degree
%
% !Convert everything to micron!

% convert into microns

mic_sidewidth = mic_sidewidth * 1000;
mic(:,1:3) = mic(:, 1:3) * 1000; 
min_mic_sidewidth = (mic_sidewidth/( 2^max( mic(:, 5) ) ) );

micData= GetMicVoxelCenter(mic, mic_sidewidth);


dx = min( [ebsd_sidewidth, min_mic_sidewidth] );
dy = dx;


%%%%%%%%%%%%%%%%%%%%%%%%%%%  grid mic file data
mic_x = mic(:, 1);
mic_y = mic(:, 2);

mic_data = mic(:, 7:9);
minMicX = min(mic_x);
maxMicX = max(mic_x);
minMicY = min(mic_y);
maxMicY = max(mic_y);



nx = uint32( (maxMicX - minMicX) /dx ) + 1;
ny = uint32( (maxMicY - minMicY) /dy ) + 1;

micMesh = zeros(nx, ny, 3);

xIndex = int16( (mic_x - minMicX)/dx) + 1;
yIndex = int16( (mic_y - minMicY)/dy) + 1;

for i = 1:length(mic_x)
    micMesh(xIndex(i), yIndex(i), :) = mic_data(i, :);
end


meshX = [minMicX:dx:(maxMicX+dx)];
meshY = [minMicY:dx:(maxMicY+dy)];

%%%%%%%%%%%%%%%%%%%%%%%%%% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%  grid ebsd data

ebsd_x = ebsd(:, 4);
ebsd_y = ebsd(:, 5);

ebsd_data = ebsd(:, 1:3);
minEBSDX = min(ebsd_x);
maxEBSDX = max(ebsd_x);
minEBSDY = min(ebsd_y);
maxEBSDY = max(ebsd_y);

nx = uint32( (maxEBSDX - minEBSDX) /dx ) + 1;
ny = uint32( (maxEBSDY - minEBSDY) /dy ) + 1;

ebsdMesh = zeros(nx, ny, 3);
 
xIndex  = int16( (ebsd_x - minEBSDX ) /dx) + 1;
yIndex = int16( (ebsd_y - minEBSDY) /dy) + 1;

for i = 1:length(ebsd_x)
    ebsdMesh(xIndex(i), yIndex(i), :) = ebsd_data(i, :);
end
%%%%%%%%%%%%%%%%%%%%%%%%%% 




disp('stuff');



function output = GetMicVoxelCenter(snp, sidewidth)


snp(:,5) = 2.^ snp(:, 5);
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
ups_c = ups(:, 1:2);
ups_c(:, 1) = ups_c(:, 1) + ups_sides/2;  % (x+s/2, y) direction
ups_c(:, 2) = ups_c(:, 2) + (ups_sides/2 * sqrt(3))/2; % (x+s/2, y + (s/2 *sqrt(3))/2);

% calculate downs v1, downs v2, and downs v3
downs_c = downs(:, 1:2);
downs_c(:, 1) = downs_c(:, 1) + downs_sides/2;  % (x+s/2, y) direction
downs_c(:, 2) = downs_c(:, 2) + (downs_sides/2 * sqrt(3))/2; % (x+s/2, y + (s/2 *sqrt(3))/2);

output = [ups_c; downs_c];