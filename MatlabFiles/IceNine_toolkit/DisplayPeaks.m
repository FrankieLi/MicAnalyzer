%%
%%
%%  DisplayPeaks
%%
%%  Purpose:  Show peaks in pannels for easy examination
%%
%%
function  DisplayPeaks( prefix, start, stop, Extensions, ColorScheme,...
                        ImageSize, bMakeImage )


                    
nNumFiles = stop - start + 1;

nWidth = floor( sqrt( nNumFiles ) );
nHeight = ceil( nNumFiles / nWidth );

nLDist = max( size(Extensions) );
if( max( size( ColorScheme ) ) ~= nLDist )
    error('number of L distances must match number of colors');
end

n = 1;
for i = start:stop
    subplot( nWidth, nHeight, n );
    hold on;
    for j = 1:nLDist
        filename = [ prefix, padZero( i, 5 ), Extensions{j} ];
        snp = load(filename);
        if( bMakeImage ~= 1 )
            plot( snp(:, 1), snp(:, 2), ColorScheme{j}, 'markersize', 5 );
            axis( [0, ImageSize(1), 0, ImageSize(2) ] );
        else
            snpIm = fillImage( snp, ImageSize(1), ImageSize(2) );
            imagesc(snpIm, [0, 1]); colormap('gray');
            axis( [0, ImageSize(1), 0, ImageSize(2) ] );
        end
    end
    hold off;
    n = n + 1;
end


end