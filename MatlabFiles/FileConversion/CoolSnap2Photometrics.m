%%
%%
%%  CoolSnap2Photometrics ( prefix, start, stop )
%%  
%%  Convert snapshot from CoolSnap convention ( downstream,
%%  unrotated image) to Photometric format ( 
%%

function CoolSnap2Photometrics( prefix, start, stop )



for i = start:stop
   
    numStr = padZero( i, 5 );
    
    % display filename
    [prefix, numStr, '.tif']   
    im = imread( [prefix, numStr, '.tif'] );
    imwrite( im', [ prefix, 'pm', numStr, '.tif'], 'tiff' );   
end


