%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  GetAverageOrientation
%%
%%  Purpose:  Calculate average orientation given Euler angle inputs
%%
%%  Input:    n x 3 matrix of Euler angles in radians
%%            Symmetry:  'cub', 'hex', 'ort'
%%
%%  Output:   1 x 3 matrix of Euler angles in radians.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = GetAverageOrientation( Eu, symmetry )

if (nargin < 2)
  error('need second argument, symmetry:  ''hex'', ''cub'', or ''ort''')
end

if ( strcmp( symmetry, 'hex' ) )
    sym = HexSymmetries();
elseif ( strcmp( symmetry, 'ort' ) )
    sym = OrtSymmetries();
elseif ( strcmp( symmetry, 'cub' ) )
    sym = CubSymmetries();
else
  error( 'symmetry must be specified by ''hex'', ''cub'', or ''ort''' )
end

qInput = QuatOfRMat( RMatOfBunge( Eu', 'radians' ) );

qAve = AverageQuaternion( qInput, sym );

output = BungeOfRMat( RMatOfQuat( qAve ), 'radians' )';