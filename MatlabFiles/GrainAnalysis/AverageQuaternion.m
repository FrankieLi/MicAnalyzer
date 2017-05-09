%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  AverageOrientation
%%
%%  Purpose:  Calculate the average of a set of quaternions specified
%%            by the input.  The average is fundamental zone dependent.
%%            
%%  Input:    4 x n matrix of quaternions, 4 x NOps matrix of quaternion
%%            symmetry operators
%%  Output:   4 x 1 matrix of the average
%%
%%  Note:     This averaging scheme is an approximation due to Cho,
%%            Rollett, and Oh.
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = AverageOrientation( QuatList, SymOps )

if( nargin ~= 2 )
    error('Usage: AverageOrientation( QuatList, SymOps)');
end
if( size( QuatList, 1) ~= 4 | size(SymOps, 1) ~= 4)
    error('ERROR: Input size differs from expected\n');
end

cloudAverage = zeros(4, size(SymOps, 2 ) );
for i = 1:size(SymOps, 2 )   % for each of the operators
    Q_Cloud = QuatProd( QuatList, repmat( SymOps(:, 1), 1, size( QuatList, 2 ) ) );   % get symmetry equivilent
    cloudAverage(:, i) = (sum( Q_Cloud, 2 ) / norm(  sum(Q_Cloud, 2 ) ) );    % calculate cloud average
end


%% Average: each cloud after projecting everything back
cloudAverage = ToFundamentalRegionQ( cloudAverage, SymOps );

Q_sum = sum(cloudAverage, 2);
Q_norm = norm(sum(cloudAverage, 2));
output = Q_sum / Q_norm;