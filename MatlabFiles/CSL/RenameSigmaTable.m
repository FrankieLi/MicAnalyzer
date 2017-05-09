%%
%%
%%  RenameSigmaTable
%%
%%
%%
function NewTable = RenameSigmaTable( Table )


UniqueSigmas = unique(Table(:, 1));

for i = 1:length(UniqueSigmas)

  findvec = find( Table(:, 1) == UniqueSigmas(i));
  if( length( findvec ) > 1 )
    
    dX = 1 / ( length(findvec) + 1 );
    
    for j = 2:length(findvec)
      Table( findvec(j), 1) = Table( findvec(j), 1)  + j * dX;
    end
  end
  
end
NewTable = Table;

end
