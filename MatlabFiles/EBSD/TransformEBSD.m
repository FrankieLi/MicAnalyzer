function snpOut = TransformEBSD(snp, PosEu, gEu)

snpOut = snp;

snpOut(:, 1:3) = RotateEuler(snp(:, 1:3), gEu);


curPos  = zeros(length(snp), 3);
curPos(:, 1:2) =  snpOut(:, 4:5);

PosTrans = getEuler_rad_pos(PosEu);
curPos = (PosTrans * curPos')';

snpOut(:, 4:5) = curPos(:, 1:2);
