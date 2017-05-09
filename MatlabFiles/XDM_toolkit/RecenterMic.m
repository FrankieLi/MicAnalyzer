function snp = RecenterMic( snp )


xCOM = sum(snp(:, 1) / length( snp(:, 1) ));
yCOM = sum(snp(:, 2) / length( snp(:, 2) ));

snp(:, 1) = snp(:, 1) - xCOM;
snp(:, 2) = snp(:, 2) - yCOM;

end