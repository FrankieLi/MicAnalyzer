%%
%%  function Tri2VtkFile
%%  purpose:  Convert tirangle files from Jessica Zhang's triangulation
%%
%%
%%
function [ GrainID1, GrainID2, QOrientList ] = Tri2VTKFile( input, output, OrientationFile )


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

findvec = find( GrainID1 > 0 & GrainID2 > 0 );    %%  get real grain as opposed to empty space grains
Misorient = [];

%%%%%%%%%%%%

if( size(findvec, 1) > 10000 )
  
  nStep = floor( size(findvec, 1) / 10000 );
  subRegionInd = [1:10000: nStep * 10000 ];
  subRegionInd = [ subRegionInd, size(findvec, 1) + 1];
  for n = 2:length( subRegionInd )
    s1 = subRegionInd( n - 1 );
    s2 = subRegionInd( n  )-1 ;
    
    fSub = findvec( s1:s2 );
    Misorient = [ Misorient, Misorientation( QOrientList( :, GrainID1(fSub) ),...
      QOrientList( :, GrainID2(fSub) ),...
      CubSymmetries() ) ];
  end
else
   Misorient = Misorientation( QOrientList( :, GrainID1( findvec ) ),...
      QOrientList( :, GrainID2( findvec) ),...
      CubSymmetries() );
end



TwinMap   = zeros( length( GrainID1 ), 1);
MinAngles = zeros( length( GrainID1 ), 1);
[ TwinMap( findvec, :), MinAngles( findvec, :), qMis ] = GetSigmaMap( QOrientList, [ GrainID1(findvec), GrainID2(findvec) ] );

AllMisorientation = zeros( length( GrainID1 ), 1 );
AllMisorientation( findvec ) = Misorient * 180 / pi;

Triangles = [Triangles, TwinMap, AllMisorientation, MinAngles * 180 / pi ];


WriteMeshVtk( output, Triangles, Vertices, 5, [1, 1, 2, 2, 2], {'GrainID1', 'GrainID2', 'Sigma', 'Misorientation', 'MinAngleFromSigma' });

end