%%
%%
%%
%%  Input:  two grids of the same size, supposed to be covering the same
%%          area
%%  Output:  Grid of the same size as the input with their misorientations
%%
%%  The output angle will be written to the "confidence" part of the output
%%  so that the output can still be converted back to the standard format
function [meanMisorient, output] = PointToPointMisorientation(g1, g2, rowShift, colShift)


gridSize = size(g2);
output = zeros(gridSize(1), gridSize(2), gridSize(3));
output(:, :, 1:3) = g1(:, :, 1:3);



% %%%  bug
% newMinRow = max( [ rowShift + 1, 1 ] );  % can't be negative
% newMinCol = max( [ colShift + 1, 1 ] );
% 
% newMaxRow = gridSize(1) + rowShift;  
% newMaxCol = gridSize(2) + colShift;
% 
% % can't be greater than  the grid size
% newMaxRow = min( [newMaxRow, gridSize(1) ] );
% newMaxCol = min( [newMaxCol, gridSize(2) ] );


RowInd = [1:gridSize(1)];
ColInd = [1:gridSize(2)];

ShiftedRowInd = RowInd + rowShift;
ShiftedColInd = ColInd + colShift;

RowFlag = (ShiftedRowInd > 0) & (ShiftedRowInd <= gridSize(1));
ColFlag = (ShiftedColInd > 0) & (ShiftedColInd <= gridSize(2));


ShiftedRowInd = ShiftedRowInd .* RowFlag;
rowFindVec = find(ShiftedRowInd ~= 0);
ShiftedColInd = ShiftedColInd .* ColFlag;
colFindVec = find(ShiftedColInd ~= 0);

ShiftedRowInd = ShiftedRowInd(rowFindVec);
ShiftedColInd = ShiftedColInd(colFindVec);

RowInd = RowInd(rowFindVec);
ColInd = ColInd(colFindVec);


meanMisorient = 0;
numElements = 0;
row = 1;
symOps = GetCubicSymOps;
for i = RowInd
   
    for j = ColInd
        % g2 is the one being shifted here
       
        i_Shifted = i + rowShift;
        j_Shifted = j + colShift;
        
        output(i, j, 6) = g1(i, j, 6) * g2(i_Shifted, j_Shifted, 6); 
        output(i, j, 7:9) = output(i, j, 6);
        
        e1 = g1(i, j, 7:9);
        e2 = g2(i_Shifted, j_Shifted , 7:9);
%         if(any(e1) & any(e2) )
%            disp('blabl'); 
%         end
%         e1 = ReduceToFundamentalZone(e1, symOps, 24);
%         e2 = ReduceToFundamentalZone(e2, symOps, 24);
        output(i, j, 10) = misorient_deg( e1, e2, symOps);
        
        numElements = numElements + output(i, j, 6);
        meanMisorient = meanMisorient + output(i, j, 10)^2 * output(i, j, 6);
        
        
     
    end
    
end
    

meanMisorient = meanMisorient / numElements;
