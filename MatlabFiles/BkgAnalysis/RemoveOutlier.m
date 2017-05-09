%
%  RemoveOutlier function - This is used by StdPeakMask
%  
%
%
%

function output = RemoveOutlier(snp)

snp = sort( snp );
Top10Percent = floor( length(snp) * 0.9 );
output = snp( 1:Top10Percent );  % use something else in the future        