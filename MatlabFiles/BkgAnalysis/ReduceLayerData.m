%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  ReduceLayerData
%%
%%
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ReduceLayerData( Prefix, OutputPrefix, OutputExt, Start, Stop, BkgImage, ...
                          Threshold, MinNumPixels, Baseline, MedianFilterSize, ...
                          ImRotAngle, bWriteBin, sInputExt, oBlackoutRegions,...
                          bReIDOutFiles )

                      
OutputData = cell( Stop - Start + 1, 1 );
if( nargin < 12 )
    bWriteBin = false;
end
   
if( nargin < 13 )
    sInputExt = 'tif';
end

if( nargin < 14 )
    bApplyBlackout = false;
else
    bApplyBlackout = true;
end

if( nargin < 15 )
    bReIDOutFiles = false;
end
nNumFiles = Stop - Start + 1
parfor n = 1:nNumFiles

  i = Start + n -1;
  Filename = [ Prefix, padZero( i, 5 ), '.', sInputExt ];
  if( bApplyBlackout )
      ReducedData = XDMReduction( Filename, Threshold, MinNumPixels, Baseline,...
                                  BkgImage, MedianFilterSize, ImRotAngle, oBlackoutRegions );
  else
      ReducedData = XDMReduction( Filename, Threshold, MinNumPixels, Baseline,...
                                  BkgImage, MedianFilterSize, ImRotAngle );
  end
  
  if( bReIDOutFiles )
      OutFilename = [ OutputPrefix, padZero( n-1, 5 ), '.', OutputExt ];
  else
      OutFilename = [ OutputPrefix, padZero( i, 5 ), '.', OutputExt ];
  end
  if( bWriteBin )
    if( size( ReducedData, 1) > 0 )
        ReducedData(:, 1:2) = ReducedData(:, 1:2 ) - 1;
    end
    WritePeakBinaryFile( ReducedData, OutFilename );
  else
    fd = fopen( OutFilename, 'w' );
    fprintf( fd, '#%g %g\n', Baseline, Threshold );
    if ( size( ReducedData, 1 ) > 0 ) 
        fprintf( fd, '%g %g %g\n', ReducedData(:, 1:3)' ); 
    end
    fclose( fd );
  end
  
%   if( size( ReducedData, 1 ) > 0 )
%     OutputData{i} = ReducedData;
%   else
%     OutputData{i} = zeros( 0, 4);
%   end
end

% for i = Start:Stop
%   OutFilename = [ OutputPrefix, padZero( i, 5 ), '.', OutputExt ];
%   if( bWriteBin )
%     WritePeakBinaryFile( OutputData{i}, OutFilename)
%   else
%     fd = fopen( OutFilename, 'w' );
%     fprintf( fd, '#%g %g\n', Baseline, Threshold );
%     if ( size( OutputData{i}, 1 ) > 0 ) 
%         fprintf( fd, '%g %g %g\n', OutputData{i}(:, 1:3)' ); 
%     end
%     fclose( fd );
%   end
% end
% end
