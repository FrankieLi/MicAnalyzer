
function [Upper, Lower, Center] = EstimateFWHM(x, y)

% dy = diff(y);
% 

% 
% NumDy = length(dy);
% dyFirstHalf = mean( dy( 1:floor( NumDy/4 ) ) );
% dySecondHalf = mean( dy( floor( 3*NumDy/4 ):end ) );
% 
% v =  abs( dy - mean([ dyFirstHalf, dySecondHalf ]) );
% Peak = max(v);
% Center = find( v == Peak );
% 
% 
% meanDy = (dyFirstHalf + dySecondHalf)/2;
% dyInd = find( dy > meanDy & dy < Peak );
% 
% Upper = x( dyInd(end) );
% Lower = x( dyInd(1) );

CenterVal = mean( [ y(1), y(end) ] );

[ minDiff, minPos] = min( abs( y- CenterVal ) );

Upper = x( end );
Lower = x( 1 );
Center = x( minPos );


end
