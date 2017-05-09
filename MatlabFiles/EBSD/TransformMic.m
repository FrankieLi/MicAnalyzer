%
%  All input are in degrees
%
%
function snpOut = TransformMic(snp, PosEu, gEu)

gEu = gEu * pi/180;
PosEu = PosEu * pi/180;

snpOut = snp;

snpOut(:, 7:9) = RotateEuler(snp(:, 7:9) * pi/180, gEu);
snpOut(:, 7:9) = snpOut(:, 7:9) * 180/pi;

curPos  = zeros(length(snp), 3);
curPos(:, 1:2) =  snpOut(:, 1:2);

PosTrans = getEuler_rad_pos(PosEu);
curPos = (PosTrans * curPos')';

snpOut(:, 1:2) = curPos(:, 1:2);
