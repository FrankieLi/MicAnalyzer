function [Triangles, Points, Orient1, Orient2] = Medit2VtkWithMisorient(  MeditFile, VtkFile, ID2BndFile, OrientationFile, DislocationFile )


%%
%%  ReID, Calculate misorientations
%%
ID2BndMap = load( ID2BndFile );
OrientationMap = load( OrientationFile );
ID2BndMap = unique( ID2BndMap, 'rows' );
ID2BndMap(:, 2:3) = ID2BndMap(:, 2:3) + 1;
ID2BndMap = sortrows( ID2BndMap, 1);
findvec = find( ID2BndMap(:, 2) > 1);  % there will be no -1 since I added 1

QOrientList = QuatOfRMat( RMatOfBunge( OrientationMap', 'degrees'));
Misorient = [];
if( size(findvec, 1) > 10000 )
  
  nStep = floor( size(findvec, 1) / 10000 );
  subRegionInd = [1:10000: nStep * 10000 ];
  subRegionInd = [ subRegionInd, size(findvec, 1) + 1];
  for n = 2:length( subRegionInd )
    s1 = subRegionInd( n - 1 );
    s2 = subRegionInd( n  )-1 ;
    
    fSub = findvec( s1:s2 );
    Misorient = [ Misorient, Misorientation( QOrientList( :, ID2BndMap( fSub, 2 ) ),...
      QOrientList( :, ID2BndMap( fSub, 3 ) ),...
      CubSymmetries() ) ];
  end
else
   Misorient = Misorientation( QOrientList( :, ID2BndMap( findvec, 2 ) ),...
      QOrientList( :, ID2BndMap( findvec, 3 ) ),...
      CubSymmetries() );
end
                         
ID2MisorientMap = zeros(max(ID2BndMap(:, 1)), 1);

ID2MisorientMap( ID2BndMap(findvec, 1) ) = Misorient' * 180 / pi;



TwinMap   = zeros(max(ID2BndMap(:, 1)), 1);
MinAngles = zeros(max(ID2BndMap(:, 1)), 1);
[ TwinMap( ID2BndMap(findvec, 1)), MinAngles( ID2BndMap(findvec, 1)), qMis ] = GetSigmaMap( QOrientList, ID2BndMap( findvec, 2:3) );

ID2LeftRightMap = zeros(max(ID2BndMap(:, 1)), 7);
ID2LeftRightMap( ID2BndMap(findvec, 1) , 1:3) = OrientationMap( ID2BndMap(findvec, 2), : );
ID2LeftRightMap( ID2BndMap(findvec, 1) , 4:6) = OrientationMap( ID2BndMap(findvec, 3), : );
ID2LeftRightMap( ID2BndMap(:, 1) , 7) = ID2BndMap(:, 2);

%ID2DislocationMap = BndDislocationMap( DislocationFile, ID2BndMap, findvec );

FidIn= fopen( MeditFile, 'r' );

fgetl( FidIn)
fgetl( FidIn)
fgetl( FidIn)
numPoints = str2num( fgetl( FidIn) )

Points = [];

Points = fscanf( FidIn, '%g %g %g %d ', [ 4, numPoints ])';
fgetl( FidIn ) % triangles
numTriangles = str2num( fgetl( FidIn ) )

Triangles = [];

Triangles = fscanf( FidIn, '%g %g %g %d ', [4, numTriangles ])';

nPreStartIndex = min(Triangles(:, 4)) -1;
IDs = Triangles(:, 4) - nPreStartIndex ;
Triangles(:, 4) = ID2MisorientMap( IDs  );

Triangles = [Triangles, TwinMap(IDs), MinAngles(IDs) * 180 / pi, ID2BndMap( IDs, 2), ID2BndMap(IDs, 3) ];

BndIDLeft = ID2BndMap(IDs, 2);
BndIDRight = ID2BndMap(IDs, 3);
InteriorIDs = BndIDLeft >= 2;
Orient1 = QOrientList(:,  BndIDLeft ( InteriorIDs ) );
Orient2 = QOrientList(:,  BndIDRight( InteriorIDs ) );

%Triangles = [ Triangles, ID2DislocationMap( IDs  ) ];
%WriteMeshVtk( VtkFile, Triangles, Points, 2, [2, 2], {'Misorientation', 'Dislocation'} );

WriteMeshVtk( VtkFile, Triangles, Points, 5, [2, 2, 2, 1, 1], {'Misorientation', 'Sigma', 'MinAngleFromSigma', 'ID1', 'ID2'} );

area = CalculateArea( Triangles(:, 1:3), Points );

findvec = find( ID2LeftRightMap( IDs, 7 ) > 1); %% not boundaries
[counts, center] = WeightedHistogram( Triangles(findvec, 4), area(findvec), [0, 63], 200 );

% GBCDSnp = zeros( length(findvec), 15);
% 
% GBCDSnp(:, 1:3) = Points( Triangles(findvec, 1), 1:3);
% GBCDSnp(:, 4:6) = Points( Triangles(findvec, 3), 1:3);
% GBCDSnp(:, 7:9) = Points( Triangles(findvec, 2), 1:3);
% GBCDSnp(:, 10:15) = ID2LeftRightMap( IDs(findvec), 1:6);
% dlmwrite('PureNiGBCDOut.csv', GBCDSnp, ' ');
fscanf( FidIn, '%s %g');
fclose( FidIn );
end


function [counts, centers] = WeightedHistogram( misorient, area, range, steps )


stepSize = ( range(2) - range(1) ) / steps;
edges = [range(1): stepSize: range(2)];
counts = zeros( length(edges) - 1, 1);
for i = 1:length(edges) - 1
  findvec = ( edges(i) <= misorient  & edges(i +1) > misorient );
  counts(i) = sum(area(findvec));
end

counts = counts ./ sum(counts);
centers = (edges(1:end-1 ) + edges(2:end) )/2;
end

%%

%%
%%
function ID2DisMap = BndDislocationMap( DislocationFile, Bnd2IDMap, ValidBnds )

Dis = load( DislocationFile );
Dis(:, 1) = Dis(:, 1) + 1;
Dis(:, 2) = Dis(:, 2) ./Dis(:, 3);
ID2DisMap = zeros( max(Dis(:, 1)),  2);
ID2DisMap( Dis(:, 1), : )  = Dis(:, 2:3);
DisMap = abs( ID2DisMap( Bnd2IDMap(ValidBnds, 2), 2 ) - ID2DisMap( Bnd2IDMap(ValidBnds, 3), 2) );

ID2DisMap = zeros( max(Bnd2IDMap(:, 1)), 1);
ID2DisMap( Bnd2IDMap(ValidBnds, 1) ) = DisMap;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  RotAxisList
%%   -- this is going to be in the crytal frame
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ RotAxisList, qMis] = GetRotationAxisMap( qOrientList, BndList )

q1i = [ -qOrientList(1, :); qOrientList(2:4, :) ];

qMis = QuatProd( q1i( :, BndList(:, 1) ), qOrientList( :, BndList(:, 2) ) );

[RotAxisList, angles ] = GetAxisAngle( qMis );

dlmwrite( 'PureNi.AxisAngle.csv', [RotAxisList, angles'], ' ' );
end


function [ r_hat, fAngle ] =  GetAxisAngle( q )

fAngle = 2 * acos( q(1, :) );
fDenom = sqrt( 1 - q(1, :) .* q(1, :) )';
findvec = find( abs( fAngle ) > 0.0001 );
r_hat = zeros( size(q, 2), 3);

r_hat( findvec, :) = q(2:4, findvec)' ;

r_hat( findvec, 1) = r_hat( findvec, 1) ./ fDenom( findvec );
r_hat( findvec, 2) = r_hat( findvec, 2) ./ fDenom( findvec );
r_hat( findvec, 3) = r_hat( findvec, 3) ./ fDenom( findvec );

end




%%  Checking sigma for one symmetry
%%  Angles in Degrees
%%
%%  Both unit vectors
function bTwinMap = IsSigma( Angle, Axis, TestAxis, TestAngle )

AngleSat = find( abs( TestAngle - Angle ) < 0.5 );

x = TestAxis( :, 1) * Axis(1);
y = TestAxis( :, 2) * Axis(2);
z = TestAxis( :, 3) * Axis(3);

AxisSat = find( acos( x + y + z ) * 180 / pi < 1 );
bTwinMap = zeros( size(TestAngle, 1), 1 );
bTwinMap( AngleSat & AxisSat ) = 1; 
end


function area = CalculateArea( Triangles, Points )

p1 = Points( Triangles(:,1 ), 1:3 );
p2 = Points( Triangles(:,2 ), 1:3 );
p3 = Points( Triangles(:,3 ), 1:3 );

v = p1 - p2;
u = p3 - p2;

A = cross( v, u, 2 );

area = dot( A, A, 2 );
area = sqrt(area);
end
