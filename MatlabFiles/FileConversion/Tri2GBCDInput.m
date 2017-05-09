function Tri2GBCDInput( GBCDInputFile, input, OrientationFile )

snp = textread( input );

nVertices  = snp(1, 1);
nTriangles = snp(1, 2);


Vertices  = snp( 2:nVertices + 1, 1:3);
Triangles = snp( nVertices+2:end, 1:5);
Triangles(:,1:3) = Triangles(:, 1:3) + 1;


OrientationMap = load( OrientationFile );
QOrientList = QuatOfRMat( RMatOfBunge( OrientationMap', 'degrees'));

%%  for some reason, the IDs are off by *2* (hence no need to add 1)
GrainID1 = Triangles(:, 4) - 1;
GrainID2 = Triangles(:, 5) - 1;

findvec = find( GrainID1 <= 0 | GrainID2 <= 0 );    %%  get real grain as opposed to empty space grains

if( ~isempty(findvec) )
  disp('there are some non-grain patches, sometimes this is expected');
  size(findvec)
end

GoodIDs = find( GrainID1 > 0 & GrainID2 > 0 );    %%  get real grain as opposed to empty space grains
Grain1Orientation = ones( 4, size(GrainID1, 1)) * -1;
Grain2Orientation = ones( 4, size(GrainID2, 1)) * -1;

findvec = find( GrainID1 > 0 );
Grain1Orientation( :, findvec ) = QOrientList( :, GrainID1(findvec) );

findvec = find( GrainID2 > 0 );
Grain2Orientation( :, findvec ) = QOrientList( :, GrainID2(findvec) );

SpatialCoordVert = [ Vertices( Triangles(GoodIDs, 1), : ), Vertices( Triangles(GoodIDs, 2), : ), Vertices( Triangles(GoodIDs, 3), : ) ];
[Normals, Areas] = GetNormalAndArea( SpatialCoordVert );
Triangles = [Areas, Normals, Grain1Orientation(:, GoodIDs)', Grain2Orientation(:, GoodIDs)' ];

dlmwrite( GBCDInputFile, Triangles, ' ' );

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






