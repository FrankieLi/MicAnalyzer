function snp = ReduceEBSDToFZ(snp)

symOps = GetCubicSymOps();
for i = 1:length(snp)
   
    snp(i, 1:3) = ReduceToFundamentalZone(snp(i, 1:3), symOps, 24);
    
end

