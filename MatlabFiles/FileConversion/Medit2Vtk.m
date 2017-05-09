function [Tets, Triangles, Points] = Medit2Vtk(  MeditFile, VtkFile, UnstructuredVtkFile )


FidIn= fopen( MeditFile, 'r' );

fgetl( FidIn)
fgetl( FidIn)
fgetl( FidIn)
numPoints = str2num( fgetl( FidIn) )

Points = [];

Points = fscanf( FidIn, '%g %g %g %d ', [ 4, numPoints ])';
fgetl( FidIn ) % get 'Triangles'
numTriangles = str2num( fgetl( FidIn ) )

Triangles = [];

Triangles = fscanf( FidIn, '%g %g %g %d ', [4, numTriangles ])';

fgetl( FidIn ) % get 'Tetrahedra'
numTets   = str2num( fgetl( FidIn ) )
Tets = fscanf( FidIn, '%g %g %g %g %d ', [5, numTets])';


v = randperm( max( Triangles(:, 4)));
Triangles(:, 4) = v(Triangles(:, 4));
WriteMeshVtk( VtkFile, Triangles, Points );


Tets = Tets( Tets(:, 5) > 1 , :);
test = unique(Tets(:, 5));
numUniqueGrains = length( test )
v = randperm( max( Tets(:, 5)));
Tets(:, 5) = v( Tets(:, 5) ); 
WriteUnstructuredVtk( UnstructuredVtkFile, Tets, Points, {}, {}, {}, {Tets(:, 5)}, {'int'}, {'grain_id'} );
%fscanf( FidIn, '%s %g')
fclose( FidIn );
end
