%%
%%
%%   EliminateDuplicateCSL
%%
%%
function CSLTableRet = EliminateDuplicateCSL( CSLTable )

qCSL = CSLTable(:, 6:end)';


nCSL = size( CSLTable, 1 );

CSLIndex = [1:nCSL]';

RepeatIndex = repmat( CSLIndex, nCSL, 1 );
RepeatIndex = sort( RepeatIndex );


MinAngles = Misorientation( qCSL( :, RepeatIndex), repmat( qCSL, 1, nCSL ), CubSymmetries() );
DiagIDs = sub2ind( [nCSL, nCSL], CSLIndex, CSLIndex );
MinAngles( DiagIDs ) = 100;

MinAngles = reshape( MinAngles, [nCSL, nCSL] );
[ MinVal, MinI] = min( MinAngles, [], 1 );


findvec =  ( ( ( MinI' - CSLIndex ) > 0 & abs( MinVal' < 0.001 ) ) |  abs( MinVal' > 0.001 ) );

CSLTableRet = CSLTable( findvec, :);

end