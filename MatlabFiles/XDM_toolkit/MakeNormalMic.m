%%
%%
%%  MakeNormalMic
%%  Input:  inFilename - filename of input mic in double line format (PSC)
%%  Ouput:  outFilename - mic file is written to outFilename using normal
%%  format
%%
function MakeNormalMic(inFilename, outFilename)

mic_file = textread(inFilename);
origMicLength = size(mic_file,1);

sideWidth = mic_file(1, 1);  % set sidewidth of the mic file
newMic = zeros( round( (origMicLength -1 )/2 ), 10 );  % standard size of mic files

newMic(:, 1:5) = mic_file( [2 : 2 : origMicLength ], 1:5 );
newMic(:, 6:10) = mic_file( [ 3 : 2 : origMicLength ], 1:5 );
write_mic(newMic, sideWidth, outFilename);