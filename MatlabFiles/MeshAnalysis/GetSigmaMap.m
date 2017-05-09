%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  GetSigmaMap
%%
%%
function [ bTwinMap, minAngle, qMis ] = GetSigmaMap( qOrientList, BndList )

q1i = [ -qOrientList(1, :); qOrientList(2:4, :) ];

qMis = zeros( 4, size( BndList, 1) );
nOrientListSize = size( BndList, 1 );

if( nOrientListSize  > 10000 )
  nStep = floor(  nOrientListSize / 10000 );
  subRegionInd = [1:10000: nStep * 10000 ];
  subRegionInd = [ subRegionInd, nOrientListSize + 1];
  for n = 2:length( subRegionInd )
    s1 = subRegionInd( n - 1 );
    s2 = subRegionInd( n  ) - 1 ;
    fSub = s1:s2;
    qMis(:, fSub) = QuatProd( q1i( :, BndList(fSub, 1) ), qOrientList( :, BndList(fSub, 2) ) );
  end
else
  qMis = QuatProd( q1i( :, BndList(:, 1) ), qOrientList( :, BndList(:, 2) ) );
end


[bTwinMap, minAngle] = ClassifySigmas( qMis );
end
