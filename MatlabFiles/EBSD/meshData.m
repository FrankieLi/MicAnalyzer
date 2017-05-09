function meshData(snp, nx, ny)

% (x, y, data, minX, maxX, minY, maxY, nx, ny)

x = snp(:, 4);
y = snp(:, 5);
data = snp(:, 7);
minX = min(x);
maxX = max(x);
minY = min(y);
maxY = max(y);


dx = (maxX - minX) /nx;
dy = (maxY - minY) /ny;


myMesh = zeros(nx, ny);
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(data)
     xIndex  = int16(x(i)/dx) + 1;
     yIndex = int16(y(i)/dy) + 1;
 
     myMesh(xIndex, yIndex) = data(i);
 
end
meshX = [minX:dx:maxX];
meshY = -[minY:dy:maxY];
 
pcolor(meshX, meshY, myMesh');