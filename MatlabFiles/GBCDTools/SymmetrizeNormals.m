%%
%%  SymmetrizeNormals
%%
%%  
%%
%%
%%
function pNormal = SymmetrizeNormals( Normals, SymOp )

nSym = size( SymOp, 2 );
SymMat = RMatOfQuat( SymOp );

pNormal = [];
for i = 1:nSym
   TNormal = TransformNormal( squeeze( SymMat(:, :, i) ), Normals, '');
%   pNormal = [pNormal; TransformNormal( squeeze( SymMat(:, :, i) ), Normals, '') ] ;
   pNormal = [pNormal; TNormal; -TNormal ] ;
end


end


