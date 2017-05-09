%%
%%
%%  MakeInitialMic
%%   sw - sidewidth
%%   center - center of the sample
%%
function snp = MakeInitialMic( sw, center )

snp = zeros(6, 10);

snp(:, [1:2,4] ) = [ [ 0, 0, 1 ];...
                     [ 0, 0, 2 ];...
                     [ -1, 0, 1];...
                     [ -1, 0, 2];...
                     [ -.5, -sqrt(3)/2, 1];...
                     [ -.5, sqrt(3)/2, 2] ];

snp(:, 1:2) = snp(:, 1:2) * sw;
snp(:, 1) = snp(:, 1) + center(1);
snp(:, 2) = snp(:, 2) + center(2);
snp(:, 3) = snp(:, 3) + center(3);
snp(:, 5) = 0;
snp(:, 6) = 1;

end