%%
%%
%%  AsciiPeakToBinary
%%
%%  Purpose:    Convert from Ascii to binary file format of peak files.
%%
%%  Parameters: inFilename, outFilename, ImSize (1 x 2 size matrix )
%%              AsciiFormat == 1 if it is xdmmpi peak files
%%              AsciiFormat == 2 if it is IceNine peak files
%%              shift       -- pixel shift between input and ouput
%%              bRenumber   -- 1 if we want to renumber the output, 
%%                             0 otherwise.
function AsciiPeakToBinary( inPrefix, outPrefix, inExt, outExt,...
                            start, stop, ImSize, AsciiFormat, ...
                            shift, bRenumber )

    if( nargin < 9 )
      shift = 0;
    end

    if( nargin < 10 )
      bRenumber = false;
    end
    
    for i = start:stop
      %  disp(num2str(i));
        inFilename  = [ inPrefix, padZero( i, 5 ), inExt ];
        if( bRenumber )
            nNewNum = i - start;
            outFilename = [ outPrefix, padZero( nNewNum, 5 ), outExt ];
        else
            outFilename = [ outPrefix, padZero( i, 5 ), outExt ];
        end
        if( AsciiFormat == 1 )
            snpPeak = load_PeakFiles( inFilename, 3 );
        elseif (AsciiFormat == 2 )
            snpPeak = load( inFilename );
        else
            error('Unknown input ascii file format');
        end
        
		if( size(snpPeak, 1) > 0 )
    		snpPeak = AddPeakID( snpPeak, ImSize );
            snpPeak(:, 1:2) = snpPeak(:, 1:2) + shift;
        end
		WritePeakBinaryFile( snpPeak, outFilename );
    end

end

%%%%%%%%
%%
%%  Augment the peak input to include peak ID.
%%
%%%%%%%%
function ReducedData = AddPeakID( snpPeak, ImSize )

    if( min( min( snpPeak(:, 1:2 ) ) )  > 0 )
        shift = 0;
    else
        shift = 1;
    end
    
    snp = fillImage( snpPeak, ImSize(1), ImSize(2), shift );
    
    [PeakLabels, NumPeaks] = bwlabel( snp, 8 );      % Get all 8 way connected pixels
  
    ImageSize = size( snp );
    ReducedData = [];
    for i =1:NumPeaks
        [row, col] = find( PeakLabels == i );
        if( size( row, 1 ) > 0 )
            Intensities = snp( sub2ind( ImageSize, row, col ) );
            PeakInfo = [row, col, Intensities, ones( length(row), 1) * i  ];
            ReducedData = [ ReducedData; PeakInfo ];
        end
    end
    ReducedData(:, 1) = ReducedData(:, 1) - shift;
    ReducedData(:, 2) = ReducedData(:, 2) - shift;
   
end
