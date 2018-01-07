function WriteUnstructuredVtk( filename, Tet, TPoints,...
                               PointData, PointDataTypes, PointDataNames,...
                               CellData, CellDataTypes, CellDataNames, OrientationField )




fd = fopen( filename, 'w');
fprintf(fd, '# vtk DataFile Version 2.0\n' );
fprintf(fd, 'Matlab converted vtk file from mesh\n' );
fprintf(fd, 'ASCII\n' );
fprintf(fd, 'DATASET UNSTRUCTURED_GRID\n' );
fprintf(fd, 'POINTS %i float \n', length( TPoints ) );
fprintf(fd, '%g %g %g\n', TPoints(:, 1:3)' );



fprintf(fd, 'CELLS %i %i\n', length(Tet), length(Tet) * 5 );
fprintf(fd, '4 %i %i %i %i\n', ( Tet(:, 1:4) -1 )' );


fprintf(fd, 'CELL_TYPES %i\n', length(Tet) );
CellType = ones( 1, length(Tet )) * 10;
fprintf(fd, '%i\n', CellType );

nPointData = length( PointData );

if( nPointData > 0 )
  fprintf(fd, 'POINT_DATA %i\n', length( PointData{1} ) );
  for i = 1:nPointData
    fprintf(fd, 'SCALARS %s %s 1\n', PointDataNames{i}, PointDataTypes{i} );
    fprintf(fd, 'LOOKUP_TABLE default\n');
    fprintf(fd, '%i\n',  PointData{i}' );
  end
end

nCellData = length( CellData );
if( nCellData > 0 )
  fprintf(fd, 'CELL_DATA %i\n', length( CellData{1} ) );
  for i = 1:nCellData
    fprintf(fd, 'SCALARS %s %s 1\n', CellDataNames{i}, CellDataTypes{i} );
    fprintf(fd, 'LOOKUP_TABLE default\n');
    if( isinteger( CellData{i}(1) ) )
      fprintf(fd, '%i\n', CellData{i}');
    elseif( isfloat( CellData{i}(1)))
      fprintf(fd, '%g\n', CellData{i}');
    end
  end
end

if( nargin > 9 )
  fprintf(fd, 'FIELD Grain_Orientations 1\n');
  fprintf(fd, 'RF 3 %i float\n', length( OrientationField )  );
  fprintf(fd, '%g %g %g\n', OrientationField' );
end


fclose(fd);
end
