function outMic = ReduceMicToFZ(mic, symmetry)

% ReduceMicToFZ - reduce the angles in a mic file to the fundamental zone
%
%   USAGE:
%
%   outMic = ReduceMicToFZ(mic, symmetry)
%
%   INPUT:
%
%   mic - standard mic file
%
%   symmetry is a string,
%         either 'hex', 'cub', or 'ort'
%       
%   OUTPUT:
% 
%   outmic - original mic file with angles in the fundamental zone
%   
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


micAngles = mic( :, 7:9 );
micAngles = micAngles';

micMat =  RMatOfBunge( micAngles, 'degrees' );
micQuat = QuatOfRMat( micMat );

micQuat = ToFundamentalRegionQ( micQuat, sym );
micMat = RMatOfQuat( micQuat );
micAngles = BungeOfRMat( micMat, 'degrees' );
mic( :, 7:9 ) = micAngles';
outMic = mic;
