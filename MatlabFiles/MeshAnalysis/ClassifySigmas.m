%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  From Tony's note
%%
%%  Sigma        Misorientation (degrees)    axis
%%   3            60                         1 1 1
%%   5           36.86                       1 0 0
%%   7           38.21                       1 1 1 
%%   9           38.94                       1 1 0
%%   11          50.47                       1 1 0
%%   13a (13)    22.62                       1 1 1
%%   13b (13.5)  27.79                       1 1 1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [bTwinMap, minAngle] = ClassifySigmas( qMis )

SigmaTable = LoadSigmaTable();


nSigmaTest = length(SigmaTable );

DistanceTable = zeros( size(qMis, 2), nSigmaTest );
nOrientListSize = size( qMis, 2 );

for i = 1:nSigmaTest 

  if( nOrientListSize > 10000 )    
    nStep = floor(  nOrientListSize / 10000 );
    subRegionInd = [1:10000: nStep * 10000 ];
    subRegionInd = [ subRegionInd, nOrientListSize + 1];
    for n = 2:length( subRegionInd )
      s1 = subRegionInd( n - 1 );
      s2 = subRegionInd( n  ) - 1 ;
      fSub = s1:s2;
      dist = Misorientation( SigmaTable( i, 6:end)', qMis(:, fSub), CubSymmetries() );
      DistanceTable(fSub, i) = abs( dist' );
    end
  else  
      dist = Misorientation( SigmaTable( i, 6:end)', qMis, CubSymmetries() );
      DistanceTable(:, i) = abs( dist' );    
  end
  
end
[minAngle, Index ] = min( DistanceTable, [], 2 );

bTwinMap = SigmaTable(Index, 1);

end
