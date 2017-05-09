function CompareSimExp( SimPre, SimPost, ExpPre, ExpPost, SimStart, ExpStart, NumFiles,...
                        ImageSize, ExpRange, AxisSize )

                      
SimStop = SimStart + NumFiles;

n = ExpStart;

for i = SimStart:SimStop
  
  SimFileName = [SimPre, padZero( i, 5 ), SimPost ];
  ExpFileName = [ExpPre, padZero( n, 5), ExpPost ];
 
  Sim = load( SimFileName );
  Exp = ReadI9BinaryFiles( ExpFileName );
  
  f = find(Exp(:, 3) > ExpRange(1) );
  ExpIm  = fillImage( Exp, ImageSize(1), ImageSize(2), 1 );
  if( length( ExpRange ) > 1 )
    imagesc( ExpIm', ExpRange );
  else
    imagesc( ExpIm' );
  end
  hold on;  plot( Sim(:, 1), Sim(:, 2), 'k+', 'markersize', 3 );
  axis( AxisSize );
  n = n + 1;
  pause();
end
close all;
end