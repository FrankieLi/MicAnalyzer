%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  averageOrientation
%%
%%  Purpose:  Calculate the average orientation of the set of Euler angles
%%            given in radians.  Note that the Euler angles are given
%%            as a n x 3 matrix.  Symmetry used in this average orientation
%%            is Cubic.  For a more general version, see GetAverageOrientation
%%
%%  Input:    n x 3 matrix of Euler angles in radians
%%  Output:   1 x 3 matrix of Euler angles in radians.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = averageOrientation(Eu)

symQuat = CubSymmetries();
EuSize = size(Eu);
numOps = size(symQuat, 2 );
cloudAverage = zeros(4, numOps);

for i = 1:numOps
    Q_Cloud = QuatOfRMat( RMatOfBunge( Eu', 'radians') );
    Q_Cloud = QuatProd( Q_Cloud, repmat( symQuat(:, 1), 1, size( Q_Cloud, 2 ) ) );   % get symmetry equivilent
    cloudAverage(:, i) = (sum( Q_Cloud, 2 ) / norm(  sum(Q_Cloud, 2 ) ) );    % calculate cloud average
end


%% Average: each cloud after projecting everything back
cloudAverage = ToFundamentalRegionQ( cloudAverage, symQuat );

Q_sum = sum(cloudAverage, 2);
Q_norm = norm(sum(cloudAverage, 2));

output = Q_sum / Q_norm;
output = BungeOfRMat( RMatOfQuat( output ), 'radians' );
output = output';