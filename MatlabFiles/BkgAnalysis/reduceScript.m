%%  reduceScript:
%%  Create background images based on the detector images
%% 
%%  Parameters:     inNameBase - prefix, or basename of the input file
%%                  outNameBase - prefix of output files
%%                  zStart  - number for starting layer
%%                  zStop - number for ending layer
%%                  numFileInL - number of files per layer
%%                  imageSize [ n1, n2 ]  -  The image will be n1 x n2 size
%%                  skip - number of files taken between layers
%%                  (consistency check)
%%                  
%%
function reduceScript(inNameBase, outNameBase, zStart, zStop, numFileInL, imageSize, skip)

startI = 1 + (numFileInL + skip) * 3  * (zStart-1);
stopI = numFileInL + (numFileInL + skip) * 3 * (zStart-1);

fileDifference = numFileInL + skip;

for i = zStart:zStop

    
  
  for j = 1:3
    buf = sprintf('File Range: [%g, %g]', startI, stopI);
    disp(buf);
  
    outName = sprintf('%s_z%i_bkg%i.tif',outNameBase, i, j);
    createBackground(inNameBase, startI, stopI, outName, imageSize);
    
    startI = stopI + 1 + skip;
    stopI = stopI + fileDifference;
  end
end



