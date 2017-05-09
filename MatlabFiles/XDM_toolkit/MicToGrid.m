%%
%%
%%  Return a grid with  at most one data point per element
%%  of the original mic file
function micGrid = MicToGrid(snp, sideWidth, useRange, range, useGridSize, gridSize)


%origSnp = snp;
%snp = [snp, [1:length(snp)]'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File Format:
% Col 1-3 x, y, z
% Col 4   1 = triangle pointing up, 2 = triangle pointing down
% Col 5 generation number; triangle size = sidewidth /(2^generation number )
% Col 7-9 orientation
% Col 10  Confidence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get min side length


%% old method
% % snp(:, 5) = 2 .^ (snp(:, 5)+2);  % get the actual sidewidth prefactor
% % 
% % allSideWidth =   sideWidth ./ snp(:, 5);
% % minSideWidth = min(allSideWidth);
% % 
% % minX = min(snp(:, 1));
% % maxX = max(snp(:, 1));
% % 
% % minY = min(snp(:, 2));
% % maxY = max(snp(:, 2));
% % 
% % % get grid size
% % nX = ceil( (maxX - minX)/minSideWidth );
% % nY = ceil( (maxY - minY)/minSideWidth );


snp(:, 5) = 2 .^ (snp(:, 5));  

allSideWidth = sideWidth ./ snp(:, 5);
minSideWidth = min(allSideWidth);
snp(:, 5) = allSideWidth;

buf = sprintf('minSideWidth = %g', minSideWidth);
disp(buf);

minX = min(snp(:, 1));
maxX = max(snp(:, 1));

minY = min(snp(:, 2));
maxY = max(snp(:, 2));

if(useRange == 1)
    minX = range(1);
    maxX = range(2);
    minY = range(3);
    maxY = range(4); 
    
    if(useGridSize == 1)
        minSideWidth = gridSize;
    end
end

% get grid size
nX = round( (maxX - minX)/minSideWidth ) + 1
nY = round( (maxY - minY)/minSideWidth ) + 1

micGrid = zeros(nX, nY, 10);


%%%  calculate center of triangle

snp(:, 1) = snp(:, 1) + 0.5 * allSideWidth; 



% find triangles pointing up
downsIndex = find(snp(:, 4) > 1);
upsIndex = find(snp(:, 4) <= 1);

ups = snp(upsIndex, :);
downs  = snp(downsIndex, :);

ups(:, 2) =  ups(:, 2) + 1 / sqrt(3) * 0.5 * ups(:, 5);
downs(:, 2)  = downs(:, 2) - 1 / sqrt(3) * 0.5 * downs(:, 5);

%% re-merge the list
snp = [ups; downs];
allSideWidth = snp(:, 5);

snpNonempty = find(snp(:, 6) > 0);
snp = snp(snpNonempty, :);

snpSize = size(snp);

xVec = zeros(snpSize(1), 1);
yVec = zeros(snpSize(1), 1);

% 
% %% find min radius
% 
% minRadius = zeros(1, 0);
% for i = 1:snpSize(1)
%     radiiSq = (snp(:, 1) - snp(i, 1)).^2 + (snp(:, 2) - snp(i, 2)).^2;
%     radiiSq = sort(radiiSq);
%     minRadius = sqrt(min(radiiSq(2:end)));
% end
% 
% minRadius
% minSideWidth

for i = 1:snpSize(1)
   
    curX =  round( (snp(i, 1) - minX) / minSideWidth ) + 1;
    curY =  round( (snp(i, 2) - minY) / minSideWidth ) + 1;
    
    xVec(i) = curX;;
    yVec(i) = curY;
    %     if (curX == 58) && (curY == 41)
    %         disp('stuff');
    %     end
    
    radius = round( (snp(i, 5) *1/sqrt(3) ) /minSideWidth);
% %     micGrid(curX-radius:curX+radius, curY-radius:curY+radius, 1) = snp(i, 7);
% %     micGrid(curX-radius:curX+radius, curY-radius:curY+radius, 2) = snp(i, 8);
% %     micGrid(curX-radius:curX+radius, curY-radius:curY+radius, 3) = snp(i, 9);
% %     micGrid(curX-radius:curX+radius, curY-radius:curY+radius, 4) z

    
    for rI = -radius:radius
        for rJ = -radius:radius
            if( (curX+rI >0) && (curY+rJ > 0) && (curX + rI < nX) && (curY+rJ < nY) )
                micGrid(curX+rI, curY+rJ, 3:10) = snp(i, 3:10);%%
                micGrid(curX+rI, curY+rJ, 1:2) = [minX + (curX+rI) * minSideWidth, minY + (curY+rJ) * minSideWidth];%%
                micGrid(curX+rI, curY+rJ, 6) = 1;
            end
        end
    end
    
end

% % 
% % % find repeat
% % repeats = zeros(1, 0);
% % 
% % coords = [xVec, yVec];
% % r = zeros(1, 0);
% % j = 1;
% % for i = 1:snpSize(1)
% %    
% %    dX =  int16(xVec) - int16(xVec(i)); 
% %    dY =  int16(yVec) - int16(yVec(i)); 
% %    findvec = find( (dX ==0)  & (dY==0));
% %    
% %    if i == 1417
% %        disp('stuff');
% %    end
% %   
% %   % r = min(d(2:end));
% %    findvecSize = size(findvec);
% %    if(findvecSize(1) > 1)
% %        repeats(j) = findvec(2);
% %        j = j + 1;
% %    end
% % end




disp('done');
