function CostVector = OverlapExpAnalysis( SimPre, SimPost, ExpPre, ExpPost, SimStart, ExpStart, NumFiles,...
                             ImageSize, ExpRange )

                      
SimStop = SimStart + NumFiles - 1;

n = ExpStart;
CostVector = [];
for i = SimStart:SimStop
  i
  SimFileName = [SimPre, padZero( i, 5 ), SimPost ];
  ExpFileName = [ExpPre, padZero( n, 5), ExpPost ];
 
  Sim = load( SimFileName );
  Exp = ReadI9BinaryFiles( ExpFileName );
  
  f = find(Exp(:, 3) > ExpRange(1) );
  
  
  ExpImPeaks      = fillImage( Exp(f, [1, 2, 4] ), ImageSize(1), ImageSize(2), 1 );
  ExpIntensity    = fillImage( Exp(f, [1, 2, 3] ), ImageSize(1), ImageSize(2), 1 );
  SimXY = unique( Sim(:, 1:2), 'rows');
  SimIm           = fillImage( [SimXY, [1:length(SimXY)]'], ImageSize(1), ImageSize(2), 1 );
  
  Overlaps = SimIm(:) > 0 & ExpIntensity(:) > 0;
  
  uniqueOverlapPeaks = unique( ExpImPeaks( Overlaps ) );
  u = unique( Exp(f, 4 ) );    %% unique peak IDs
  
  ExpLength = size( f, 1 );
  PeakSize = accumarray( Exp(f, 4), ones( ExpLength, 1) );
  
  Cost  = sum( PeakSize( uniqueOverlapPeaks ) );
  Total = sum( PeakSize );
  CostVector = [CostVector; Cost / Total];
  n = n + 1;
end

end