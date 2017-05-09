%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  GetCenterOfIntensity
%%  Purpose:   Given ReducedData in the format
%%             [ row, col, intensity, peakID ]
%%  Return a set of center of intensity with error given
%%  as the bounding box of the center of intensity.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function IntensityInfo = GetCenterOfIntensity( ReducedData )


IntensityInfo = [];


PeakIDs = unique( ReducedData(:, 4) );


for i = 1:length( PeakIDs )

    findvec = find( ReducedData(:, 4) == PeakIDs(i) );
    ThisPeak = ReducedData( findvec, : );
    x = double( ThisPeak(:, 1) );
    y = double( ThisPeak(:, 2) );
    Intensity = double( ThisPeak(:, 3) );
    Center = sum( [ x .* Intensity, y .* Intensity ], 1 ) ./ sum( Intensity );
    ErrorBBox = [ min( x - Center(1) ), max( x - Center(1) ), min( y - Center(2) ), max( y - Center(2) ) ];
    IntensityInfo = [ IntensityInfo; [ Center,  ErrorBBox ], sum(Intensity), length(Intensity) ];
end

end