function snp = ReduceMic(snp)

Eu = snp(:, 7:9) * pi/180;
symOps = GetCubicSymOps();
for i = 1:length(Eu)
   
    Eu(i, 1:3) = ReduceToFundamentalZone(Eu(i, 1:3), symOps, 24);
    
end
snp(:, 7:9) = Eu * 180/pi;
