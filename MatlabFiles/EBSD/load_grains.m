function GrainList = load_grains(filename)


snp = dlmread(filename);
GrainList = zeros(0, 5);
i = 1;

GListIndex = 1;
while i <= length(snp)

    currentID = snp(i, 4);
    GrainList(GListIndex, 1) = currentID;
    GrainList(GListIndex, 2:4) = snp(i, 5:7);
    j = currentID;
    
    numPoints = 0;
    while (j == currentID) && (i <= length(snp))
      
      j = snp(i, 4);
      i = i + 1;  
      numPoints = numPoints + 1;
    end
    GrainList(GListIndex, 5) = numPoints;
    GListIndex = GListIndex +1;
end

