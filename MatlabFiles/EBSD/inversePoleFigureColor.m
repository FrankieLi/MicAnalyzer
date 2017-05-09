function colorOut = inversePoleFigureColor(Eu)

colorOut = Eu;
EuSize = size(Eu);
EuLength = EuSize(1);

% calculate misorientation from fixed color and vectors

%
%  (35, 45, 0)
%  (90, 35, 45)
%  (42, 37, 9)
%  (59, 37, 63)
%  (0, 45, 0)
%  (0, 0, 0)
%  (90, 25, 65)

colorList = cell(3, 2);
colorList{1, 1} = EulerToIPF([0, 0, 1]', [0, 0, 0]) ;
colorList{2, 1} = EulerToIPF([1, 0, 1]', [0, 0, 0]) ;
colorList{3, 1} = EulerToIPF([1, 1, 1]', [0, 0, 0]) ;


colorList{1, 2} = [0, 1, 0];  % yellow
colorList{2, 2} = [1, 0, 0];  % red
colorList{3, 2} = [0, 0, 1];  % blue

Length12 = norm( colorList{1, 1} - colorList{2, 1} ); 
Length13 = norm( colorList{1, 1} - colorList{3, 1} ); 
Length23 = norm( colorList{2, 1} - colorList{3, 1} ); 
    
TotalArea = triangleArea(Length12, Length13, Length23);

cubicSymOps = GetCubicSymOps();
test = zeros(EuLength, 2);

PointLoc = zeros(3,1);

for i = 1:EuLength

    ProjectedPoint = EulerToIPF([0, 0, 1]', Eu(i, :));
    
    Length1P = norm( colorList{1, 1} - ProjectedPoint ); 
	Length2P = norm( colorList{2, 1} - ProjectedPoint ); 
	Length3P = norm( colorList{3, 1} - ProjectedPoint ); 
    
    % calculate area for the barycentric coordinates
    
    Area1 = triangleArea( Length12, Length1P, Length2P );
    Area2 = triangleArea( Length23, Length2P, Length3P );
	Area3 = triangleArea( Length13, Length1P, Length3P );
    
    colorOut(i, :) = Area1/TotalArea * colorList{1, 2}...
                   + Area2/TotalArea * colorList{2, 2}...
                   + Area3/TotalArea * colorList{3, 2};
    
    
end
disp('end');


function area = triangleArea(s1, s2, s3)

semiP = (s1+s2+s3)/2;
area = sqrt(semiP* (semiP-s1) * (semiP -s2) * (semiP-s3) );

