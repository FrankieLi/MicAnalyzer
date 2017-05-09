%%
%%
%%
%%
%%
function SnpIm = ReadPeakFileToImage( filename, ImageSize )



snp = load( filename );
SnpIm = fillImage( snp + 1, ImageSize(1), ImageSize(2) );


end