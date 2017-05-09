function filename = getRawFilename(prefix, tif_index)

if(tif_index < 10)
    filename = sprintf('%s00%g.tif', prefix, tif_index);
elseif(tif_index < 100)
    filename  = sprintf('%s0%g.tif', prefix, tif_index);
else    
    filename = sprintf('%s%g.tif', prefix, tif_index);
end

