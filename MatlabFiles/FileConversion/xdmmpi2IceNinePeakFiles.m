function xdmmpi2IceNinePeakFiles( inPrefix, outPrefix, start, stop, postfix, newPostfix, shift )

if ( nargin == 6 )
    shift = -1;
end

for i = start:stop

  inFilename  = [ inPrefix, padZero( i, 5 ), postfix ];
  outFilename = [ outPrefix, padZero( i, 5 ), newPostfix ];

  
  snp = load_PeakFiles( inFilename, 3);
if ( size(snp, 1) > 0 )
  snp(:, 1) = snp(:, 1) + shift;
  snp(:, 2) = snp(:, 2) + shift;
end
  dlmwrite( outFilename, snp, ' ' );
end


end
