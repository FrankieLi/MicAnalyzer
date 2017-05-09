%%
%%    ReadI9BinaryFiles
%%
%%
%%           [float(32) version header]
%%           [SBlockHeader]
%%           [SubHeader for first coordinate]
%%           [ n uint(16) pixel first coordinate ]
%%           [SubHeader for second coordinate]
%%           [ n uint(16) pixel second coordinate ]
%%           [SubHeader for intensity ]
%%           [ n float(32) pixel intensity ]
%%           [SubHeader for peakID ]
%%           [ n uint(32) for peakID ]
function snp = ReadI9BinaryFiles( sFilename )

fid = fopen( sFilename, 'rb');

headerTmpl = struct( 'BlockType', 0, 'DataFormat', 0, 'NumChildren', 0, ...
                     'NameSize', 0, 'BlockName', 0, ...
                     'DataSize', 0, 'ChunkNumber', 0, 'TotalChunks', 0 );

%%---------------------------------------------------------------------
fread( fid, 1, 'float32' );                     % version number
headerMain = ReadUFFHeader( fid, headerTmpl );  % read Header

% read children data location
ChildXLocation    = fread( fid, 1, 'uint32' );
ChildYLocation    = fread( fid, 1, 'uint32' );
ChildIntLocation  = fread( fid, 1, 'uint32' );
ChildPeakLocation = fread( fid, 1, 'uint32' );

NumPeaks  = fread( fid, 1, 'uint32' );

Header1   = ReadUFFHeader( fid, headerTmpl );
nElements = (Header1.DataSize - Header1.NameSize)/2; % exploiting the file format
x = fread( fid, nElements, 'uint16');

Header1   = ReadUFFHeader( fid, headerTmpl );
nCheck = (Header1.DataSize - Header1.NameSize)/2; % exploiting the file format
assert( nCheck == nElements, 'Number of elements mismatch');
y = fread( fid, nElements, 'uint16');

Header1   = ReadUFFHeader( fid, headerTmpl );
nCheck = (Header1.DataSize - Header1.NameSize)/4; % exploiting the file format
assert( nCheck == nElements, 'Number of elements mismatch');
intensity = fread( fid, nElements, 'float32');

Header1   = ReadUFFHeader( fid, headerTmpl );
nCheck = (Header1.DataSize - Header1.NameSize)/2; % exploiting the file format
assert( nCheck == nElements, 'Number of elements mismatch');
PeakID = fread( fid, nElements, 'uint16');

fclose( fid );

snp = [x, y, intensity, PeakID];
end


%%
%%
%%  ReadUFFHeader
%%
function newHeader = ReadUFFHeader( fid, header )
    
    uBlockHeader = fread( fid, 1, 'uint32' ); 
    
    if( uBlockHeader ~= hex2dec( 'FEEDBEEF' ) )
        error('file seems to be corrupted\n');
    end
    
    header.BlockType  = fread( fid, 1, 'uint16' );
    header.DataFormat = fread( fid, 1, 'uint16' );

    header.NumChildren = fread( fid, 1, 'uint16' );
    header.NameSize    = fread( fid, 1, 'uint16' );
    header.DataSize    = fread( fid, 1, 'uint32' );
    
    header.ChunkNumber = fread( fid, 1, 'uint16' );
    header.TotalChunks = fread( fid, 1, 'uint16' );
    header.BlockName   = char( fread( fid, header.NameSize,  'char'   ) );
    newHeader = header;
end