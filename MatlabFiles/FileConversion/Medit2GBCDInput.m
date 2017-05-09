function [Triangles] = Medit2GBCDInput(  MeditFile, GBCDInput, ID2BndFile, OrientationFile )


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

ID2LeftRightMap = zeros(max(ID2BndMap(:, 1)), 7);
ID2LeftRightMap( ID2BndMap(findvec, 1) , 1:3) = OrientationMap( ID2BndMap(findvec, 2), : );
ID2LeftRightMap( ID2BndMap(findvec, 1) , 4:6) = OrientationMap( ID2BndMap(findvec, 3), : );
ID2LeftRightMap( ID2BndMap(:, 1) , 7) = ID2BndMap(:, 2);

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

GoodIDs = find( ID2LeftRightMap( IDs, 7 ) > 1); %% not boundaries

Triangles = [Triangles, ID2BndMap( IDs, 2), ID2BndMap(IDs, 3) ];

GrainIDs = ID2BndMap( IDs, 2:3);
SpatialCoordVert = [ Points( Triangles(GoodIDs, 1), 1:3 ), Points( Triangles(GoodIDs, 2), 1:3 ), Points( Triangles(GoodIDs, 3), 1:3 ) ];

[Normals, Areas ] = GetNormalAndArea( SpatialCoordVert );


GBCDSnp = zeros( length(GoodIDs), 12);

Grain1Orientation = QuatOfRMat( RMatOfBunge( ID2LeftRightMap( IDs(GoodIDs), 1:3)', 'degrees'));
Grain2Orientation = QuatOfRMat( RMatOfBunge( ID2LeftRightMap( IDs(GoodIDs), 4:6)', 'degrees'));

Triangles = [Areas, Normals, Grain1Orientation', Grain2Orientation',  GrainIDs( GoodIDs, :) - 1 ];


dlmwrite( GBCDInput , Triangles, ' ');
fscanf( FidIn, '%s %g');
fclose( FidIn );
end

%%
%%  Function:  GetNormals
%%
%%
function [Normals, Area] = GetNormalAndArea( Vertices )

v1 = Vertices(:, 1:3);
v2 = Vertices(:, 4:6);
v3 = Vertices(:, 7:9);

Normals = cross( (v1 - v2), (v3 - v2 ), 2 ); 

d = sqrt( dot( Normals, Normals, 2 ) );

Area = d / 2;

Normals(:, 1) = Normals(:, 1) ./ d;
Normals(:, 2) = Normals(:, 2) ./ d;
Normals(:, 3) = Normals(:, 3) ./ d;


end



