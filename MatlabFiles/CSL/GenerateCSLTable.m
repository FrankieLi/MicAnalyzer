%%
%%
function [ CSLTable, SigmaTable]  = GenerateCSLTable( mMax )


SigmaTable = CSLFamilyGenerator( mMax );

CSLTable = [];
for i = 1:size( SigmaTable, 1)
  [axis, angle] = GenerateCSLFromFamily( SigmaTable( i, 2 ),...
                                         SigmaTable( i, 3 ),...
                                         SigmaTable( i, 4 ),...
                                         SigmaTable( i, 5 ) );

  CSLTable = [ CSLTable; SigmaTable(i, 1), angle, axis ];
end

findvec =  CSLTable(:, 2) > 0 ;
CSLTable = CSLTable( findvec, :);
CSLTable = sortrows( CSLTable, 1);
end
