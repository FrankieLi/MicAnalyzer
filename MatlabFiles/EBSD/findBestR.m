function misorient_list = findBestR(ebsd, grain)

ebsd = ebsd /180.0 * pi;
grain = grain / 180.0 * pi;
%
%
%  1 - ebsd index
%  2 - grain index
%  3 - misorientation

ebsd_size = size(ebsd);
ebsd_length = ebsd_size(1);
grain_size = size(grain);
grain_length = grain_size(1);

misorient_list = zeros(ebsd_length * grain_length, 3);
k = 1;


for i = 1:ebsd_length
    for j = 1:grain_length
        d_angle = misorient_rad(ebsd(i, :), grain(j, :));
        misorient_list(k, 1) = i;
        misorient_list(k, 2) = j;
        misorient_list(k, 3) = d_angle;
        k = k +1;
    end
    i
end

misorient_list(:, 3) = misorient_list(:, 3) * 180/pi;