function WriteMeshVtk( filename, Tsurf, TPoints, nDataSections, DataTypes, DataNames )

if( nargin <4 )
  nDataSections = 1;
  DataTypes = 1;
  DataNames = {'SurfaceID'};
end


TSurfProp  = Tsurf(:, 4);
%% TPointProp = TPoints(:, 4);

fd = fopen( filename, 'w');
fprintf(fd, '# vtk DataFile Version 2.0\n' );
fprintf(fd, 'Matlab converted vtk file from mesh\n' );
fprintf(fd, 'ASCII\n' );
fprintf(fd, 'DATASET POLYDATA\n' );
fprintf(fd, 'POINTS %i float \n', length( TPoints ) );
fprintf(fd, '%g %g %g\n', TPoints(:, 1:3)' );
fprintf(fd, 'POLYGONS %i %i\n', length(Tsurf), length(Tsurf) * 4 );
fprintf(fd, '3 %i %i %i\n', (Tsurf(:, 1:3) -1 )' );
fprintf(fd, 'CELL_DATA %i\n', length(Tsurf) );

for i = 1:nDataSections
  if( DataTypes(i) == 1 )
    fprintf(fd, 'SCALARS %s int 1\n', DataNames{i} );
  elseif( DataTypes(i) == 2 )
    fprintf(fd, 'SCALARS %s float 1\n', DataNames{i} );
  else
    error('unknown data type');
  end
  fprintf(fd, 'LOOKUP_TABLE default\n');
  fprintf(fd, '%i\n', Tsurf(:, 4 + i -1)' );
  
end
fclose(fd);
end
