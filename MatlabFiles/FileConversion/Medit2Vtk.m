function [Tets, Triangles, Points] = Medit2Vtk(  MeditFile, VtkFile, UnstructuredVtkFile, GrainID2CellIDFile, OrientationFile )


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

% Remove all cells with negative ID.
Tets = Tets( Tets(:, 5) > 1 , :);
test = unique(Tets(:, 5));
numUniqueGrains = length( test )
v = randperm( max( Tets(:, 5)));
Tets(:, 5) = v( Tets(:, 5) );

if (nargin == 3)

    WriteUnstructuredVtk( UnstructuredVtkFile, Tets, Points, {}, {}, {}, {Tets(:, 5)}, {'int'}, {'grain_id'} );
else
    OrientationMap = load(OrientationFile);
    GrainID2CellIDMap = load(GrainID2CellIDFile);

    % First row is the negative grain ID
    % Map Cell ID to GrainID, then map from Grain ID to orientation in row.
    %
    % We will remove all cells with negative grain ID.
    %
    % Note that Matlab index from 1, so we have to add GrainID by 1. Cell ID
    % remains the same, however.

    CellID2GrainIDMap(GrainID2CellIDMap(:, 2)) = GrainID2CellIDMap(:, 1);
    CellID2GrainIDMap(CellID2GrainIDMap == -1) = 0; % By construction, the -1 grain maps to 0.
    CellID2GrainIDMap = CellID2GrainIDMap + 1; % Shift by 1 because of Matlab indexing.
    OldGrainID = CellID2GrainIDMap(Tets(:, 5));
    CellOrient = OrientationMap(OldGrainID, :);

    WriteUnstructuredVtk( UnstructuredVtkFile, Tets, Points, {}, {}, {},...
                          {Tets(:, 5)}, {'int'}, {'grain_id'}, CellOrient);
end
%fscanf( FidIn, '%s %g')
fclose( FidIn );
end
