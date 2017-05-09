function GetMeditPoints( MeditFile, PointFilename )


FidIn= fopen( MeditFile, 'r' );

fgetl( FidIn)
fgetl( FidIn)
fgetl( FidIn)
numPoints = str2num( fgetl( FidIn) )

Points = [];


Points = fscanf( FidIn, '%g %g %g %d ', [ 4, numPoints ])';

dlmwrite( PointFilename, Points(:, 1:3), ' ');
end