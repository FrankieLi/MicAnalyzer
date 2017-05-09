%%
%%  WritePeakBinaryFile
%%
%%
%%
%%  Note:  PeakSnp is a n x 4 array. 
%% [ x, y, Intensity, PeakID]
%%
%%  TODO:  Write a UFF format for matlab, make this call the UFF format.
%%
%%  Binary format:  The file format used here is part of the UFF format.
%%  Specifically:
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
%%
function WritePeakBinaryFile( PeakSnp, sFilename )

% Set headers
sBlockName = ['PeakFile', 0];

headerMain = struct( 'BlockType', 1, 'DataFormat', 1, 'NumChildren', 4, ...
                 'NameSize', length( sBlockName ), 'BlockName', sBlockName, ...
                 'DataSize', 0, 'ChunkNumber', 0, 'TotalChunks', 0 );

sBlockName = ['PixelCoord0', 0];
headerX = struct( 'BlockType', 1, 'DataFormat', 1, 'NumChildren', 0, ...
                 'NameSize', length( sBlockName ), 'BlockName', sBlockName, ...
                 'DataSize', 0, ...
                'ChunkNumber', 0, 'TotalChunks', 0 );             


sBlockName = ['PixelCoord1', 0];
headerY = struct( 'BlockType', 1, 'DataFormat', 1, 'NumChildren', 0, ...
                 'NameSize', length( sBlockName ), 'BlockName', sBlockName, ...
                 'DataSize', 0, ...
                 'ChunkNumber', 0, 'TotalChunks', 0 );


sBlockName = ['Intensity', 0];
headerIntensity = struct( 'BlockType', 1, 'DataFormat', 1, 'NumChildren', 0, ...
                 'NameSize', length( sBlockName ), 'BlockName', sBlockName, ...
                 'DataSize', 0, ...
                 'ChunkNumber', 0, 'TotalChunks', 0 );

sBlockName = ['PeakID', 0];
headerPeakID = struct( 'BlockType', 1, 'DataFormat', 1, 'NumChildren', 0, ...
                 'NameSize', length( sBlockName ), 'BlockName', sBlockName, ...
                 'DataSize', 0, ...
                 'ChunkNumber', 0, 'TotalChunks', 0 );


%% set sizes of the header
n = size( PeakSnp, 1 );
headerPeakID.DataSize = GetDataSize( n, 2 ) + headerPeakID.NameSize;
headerIntensity.DataSize = GetDataSize( n, 4 ) + headerIntensity.NameSize;
headerY.DataSize = GetDataSize( n, 2 ) + headerY.NameSize;
headerX.DataSize = GetDataSize( n, 2 ) + headerX.NameSize;

ChildrenPtrSize = 4 * 4;  % 4 bytes of location, 4 children

ChildXLocation = 4;
ChildYLocation = ChildXLocation + headerX.DataSize + GetHeaderSizeInBytes( );
ChildIntLocation = ChildYLocation + headerY.DataSize + GetHeaderSizeInBytes(  );
ChildPeakLocation = ChildIntLocation + headerIntensity.DataSize + GetHeaderSizeInBytes( );
headerMain.DataSize = ChildPeakLocation + headerPeakID.DataSize +  GetHeaderSizeInBytes(  ) + ChildrenPtrSize + 4;

fid = fopen( sFilename, 'wb');
fwrite( fid, 1, 'float32' );                  % version number
WriteUFFHeader( fid, headerMain );            % Write Header

% Write children data location
fwrite( fid, ChildXLocation,    'uint32' );
fwrite( fid, ChildYLocation,    'uint32' );
fwrite( fid, ChildIntLocation,  'uint32' );
fwrite( fid, ChildPeakLocation, 'uint32' );


if( n > 0 )
    nNumPeaks = length( unique( PeakSnp(:, 4) ) );
else
    nNumPeaks = 0;
end
fwrite( fid, uint32( nNumPeaks ), 'uint32' );

% write X
WriteUFFHeader( fid, headerX );            % Write Header
if( n > 0 )
    fwrite( fid, uint16( PeakSnp(:, 1) ), 'uint16' );
end
% write Y
WriteUFFHeader( fid, headerY );            % Write Header
if( n > 0 )
    fwrite( fid, uint16( PeakSnp(:, 2) ), 'uint16' );
end
% write intensity
WriteUFFHeader( fid, headerIntensity );            % Write Header
if( n > 0 )
    fwrite( fid, single( PeakSnp(:, 3) ), 'float32' );
end
% write PeakID
WriteUFFHeader( fid, headerPeakID );            % Write Header
if( n > 0 )
    fwrite( fid, uint16( PeakSnp(:, 4) ), 'uint16' );
end
fclose( fid );

end


%%  NOTE:  Each block is proceeded with:
%%  		U32 nDummy = 0xFEEDBEEF;
%%
%% 			// Block type and format of the binary data (if applicable) stored in first 32 bits
%% 			U32 m_nBlockType	: 16;
%% 			U32 m_nDataFormat	: 16;
%% 			U32					: 0;
%% 
%% 			// Num children and block name size stored in second 32 bits
%% 			U32 m_nNumChildren	: 24;
%% 			U32 m_nNameSize		: 8;
%% 			U32					: 0;
%% 
%% 			// The number of bytes that follow this header.  All children data is included as part of this block.
%% 			// Thus, m_nDataSize is the sum total of the data for this block and all its children.
%% 			U32 m_nDataSize;
%% 
%% 			// Data can be composed of multiple blocks if it is too big.
%% 			// Each chunk can contain only a set amount of bytes.  This is so that loading can be done in chunks.
%% 			U32 m_nChunkNum		: 16;
%% 			U32 m_nTotalChunks	: 16;
%% 			U32					: 0;
function WriteUFFHeader( fid, header )
    uBlockHeader = hex2dec( 'FEEDBEEF' );
    fwrite( fid, uBlockHeader, 'uint32' ); 

 
    fwrite( fid, header.BlockType,  'uint16' );
    fwrite( fid, header.DataFormat, 'uint16' );

    fwrite( fid, header.NumChildren, 'uint16' );
    fwrite( fid, header.NameSize,    'uint16' );
    fwrite( fid, header.DataSize,    'uint32');
    
    fwrite( fid, header.ChunkNumber, 'uint16' );
    fwrite( fid, header.TotalChunks, 'uint16' );
    fwrite( fid, header.BlockName,  'char'   );
end

%% 			
%%   Return header size, given header struct
%%
function NumBytes = GetHeaderSizeInBytes( header )


NumBytes = 16 + 4;  % 16 bytes core, 4 dummy             
end

%%
%%  Return the total size of the data in bytes
%%  
function NumBytes = GetDataSize( DataLength, NumBytesPerData )

NumBytes = DataLength * NumBytesPerData; 
end
