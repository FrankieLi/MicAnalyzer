%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  ReduceToCenterOfIntensity
%%
%%  Author:  Frankie Li
%%  e-mail:  sfli@cmu.edu
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ReduceToCenterOfIntensity( Prefix, OutputPrefix, OutputExt, Start, Stop, BkgImage, ...
                                    Threshold, MinNumPixels, Baseline, MedianFilterSize )

                                  
OutputData = cell( Stop - Start + 1, 1 );                                  

for i = Start:Stop
  Filename = [ Prefix, padZero( i, 5 ), '.tif' ];
  ReducedData = XDMReduction( Filename, Threshold, MinNumPixels, Baseline, BkgImage, MedianFilterSize );
  IntensityInfo = GetCenterOfIntensity( ReducedData );
  OutputData{i} = IntensityInfo;
end


for i = Start:Stop
  OutFilename = [ OutputPrefix, padZero( i, 5 ), '.', OutputExt ];
  
  fd = fopen( OutFilename, 'w' );    
  fprintf( fd, '%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\n', OutputData{i}' ); 
  fclose( fd );
end
end