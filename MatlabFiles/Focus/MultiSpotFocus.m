%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  MultiSpotFocus
%%
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OptFocusLoc = MultiSpotFocus( start, stop, prefix, StepSize, Offset, ROIs, IntDim )

EstimateWidth = 10; 
PlotRegions( [prefix, '0001.tif'], ROIs, 1  );

figure;
nRegions = size( ROIs, 1 );
[ Widths, Centers, Errors ] = GetFocusInfo( start, stop, prefix,  ROIs, IntDim );
x = [start: stop] * StepSize + Offset;
Centers = Centers * StepSize + Offset;
OptFocusLoc = zeros( nRegions, 1 );
FWHM = ( 2 * sqrt( log(2) ) ) ./ abs( Widths );  % convert to FWHM
for i = 1:nRegions
    subplot( floor( sqrt(nRegions) ), ceil( nRegions / floor( sqrt(nRegions) ) ), i );
    [ OptFocusLoc(i), FittedX, FittedY ] = EstimateMin( x, FWHM(:, i ), floor( EstimateWidth/2 ) );
    plot( x, FWHM(:, i), '*', FittedX, FittedY, 'r' );
    legend('Exp', 'Fitted');
    [ MinDiff, MinIndex ] = min( abs( OptFocusLoc(i) - x ) );
    title( ['FWHM ', num2str( FWHM( MinIndex, i ) ), ' at ', num2str( OptFocusLoc(i) )]);
end 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Pretend that there's a parabolar here
%%
%%
%%  Assuming that y is positive only, and that it's FWHM
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ minPos, FittedX, FittedY ]= EstimateMin( x, y, EstWidth )

nElements = length(x);
[yMin, yMinIndex] = min( y );
y = y( max( yMinIndex - EstWidth, 1):min( yMinIndex + EstWidth, nElements ) );
x = x( max( yMinIndex - EstWidth, 1):min( yMinIndex + EstWidth, nElements ) );

model = @(p, x) p(1) * x.^2 + p(2) * x + p(3);
if( size(x, 1) ~= size(y, 1) )
    x = x';
end
params = polyfit( x, y, 2 );
minPos = -params(2) / (2 *params(1));
FittedY = model( params, x );
FittedX = x;
end

