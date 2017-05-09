%%
%%  FitErf -- fit error function
%%
%%
function [params, resNorm, res, ExitFlag ] = FitErf( x, p, nMaxRestarts )

if( nargin == 2 )
    nMaxRestarts = 2;
end
modelErf = @(c,x) c(1) + c(2) .* erf(c(3) .* (x  - c(4)) );
[Upper, Lower, CenterEst] = EstimateFWHM( x, p );
startVals = [ min(p) + (max(p) - min(p))/2, (max(p) -min(p))/ 2, ...
    sign( p(end) - p(1) ) * 1/5, CenterEst ];
if( size( x, 2 ) ~= size( p, 2) )
    p = p';
end

params = startVals;
testOpt = optimset( 'Display', 'off', 'LevenbergMarquardt', 'off', 'LargeScale', 'off', 'MaxIter', 10 );
[params, resNorm, res, ExitFlag ] = lsqcurvefit(modelErf, params, x, p, [], [], testOpt );   
   
end