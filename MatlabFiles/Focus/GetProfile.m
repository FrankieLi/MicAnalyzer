%%
%%
%%  Valid ROI is assumed
%%
function [Profile, bEdge] = GetProfile( snp, ROI, IntDir )

snpSize = size(snp);
findvec = find( ROI(1, :) > snpSize(1) | ROI(1,:) < 1 );
findvec = [findvec, find( ROI(2, :) > snpSize(2) | ROI(2,:) < 1 ) ];
if( length(findvec) > 0 ) 
  bEdge = true;
  Profile = [];
else
  bEdge   = false;
  Profile = sum( snp( ROI(1, 1): ROI(1, 2), ROI(2, 1):ROI(2,2) ), IntDir );
end


end