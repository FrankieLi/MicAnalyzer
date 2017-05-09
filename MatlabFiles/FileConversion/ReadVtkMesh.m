%%
%%  ReadVtkMesh 
%%
%%  Purpose:    Read a vtk file into nodes and triangles
%%
%%
%%
function [triangles, nodes] = ReadVtkMesh( VtkFile )

FidIn= fopen( VtkFile, 'r' );

fgetl( FidIn);
fgetl( FidIn);
fgetl( FidIn);
fgetl( FidIn);

%fscanf( FidIn, '%s',[6, 1] )
str = fgetl(FidIn);
[tmp, str ] = strtok( str );
numPoints = str2num( strtok( str ) );
nodes = fscanf( FidIn, '%g %g %g', [ 3, numPoints ])';

str = fgetl( FidIn); % finish the line
str = fgetl( FidIn); 
[tmp, str] = strtok( str );
numTriangles = str2num( strtok( str ) );

triangles = fscanf( FidIn, '%d %d %d %d ', [4, numTriangles ])';
triangles = triangles(:, 2:end) + 1;
% numPoints = str2num( fgetl( FidIn) )
% 
% Points = [];
% 
% Points = fscanf( FidIn, '%g %g %g %d ', [ 4, numPoints ])';
% fgetl( FidIn ) % triangles
% numTriangles = str2num( fgetl( FidIn ) )
% 
% Triangles = [];
% 
% Triangles = fscanf( FidIn, '%g %g %g %d ', [4, numTriangles ])';
% v = randperm( max( Triangles(:, 4)));
% Triangles(:, 4) = v(Triangles(:, 4));
% WriteMeshVtk( VtkFile, Triangles, Points );
% 
% %fscanf( FidIn, '%s %g')
fclose( FidIn );

end