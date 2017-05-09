%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%
%%  XDMReduction
%%
%%
%%  Typical reduction used for HEDM data.
%%
%%   Return ReducedData, [ col, row, Intensity, Label ]
%%
%%  Note:  Rotation is applied *AFTER* all transformations (this is a
%%  recent change) (This significantly reduces confusion)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ReducedData= XDMReduction( Filename, Threshold, MinNumPixels, Baseline, BackgroundImage, ...
                                     MedianFilterSize, ImRotAngle, oBlackoutRegions )

                                 
  if ( nargin < 8 )
      bApplyBlackout = false;
  else
      bApplyBlackout = true;
                                   
  snp = imread( Filename );
 
  
  snp = imsubtract( snp, BackgroundImage );
  snp = imsubtract( snp, Baseline );
  snp = medfilt2( snp, MedianFilterSize );
  
  
  if ( bApplyBlackout )
     for i = 1:length( oBlackoutRegions )
        BlackOut1= [ oBlackoutRegions{i}( 1,1 ):oBlackoutRegions{i}( 1,2 ) ]; 
        BlackOut2= [ oBlackoutRegions{i}( 2,1 ):oBlackoutRegions{i}( 2,2 ) ];
        snp( BlackOut1, BlackOut2 )  = 0;
     end
  end
  
  snp = imrotate( snp, ImRotAngle );
  snpLit = snp > 0;
  PeakMask = bwareaopen( snpLit, MinNumPixels );   % calculate mask for components larger than MinNumPixels
  snp = snp .* uint16( PeakMask );
  [PeakLabels, NumPeaks] = bwlabel( snp, 4 );      % Get all 8 way connected pixels
  
  ImageSize = size( snp );
  ReducedData = [];
  for i =1:NumPeaks
 
    [row, col] = find( PeakLabels == i );
    if( size( row, 1 ) > 0 )
        Intensities = snp( sub2ind( ImageSize, row, col ) );
        PeakInfo = [row, col, Intensities, ones( length(row), 1) * i  ];
        MaxIntensity = max( Intensities );
        findvec = find( PeakInfo(:, 3) > Threshold * MaxIntensity );
        ReducedData = [ ReducedData; PeakInfo(findvec, :) ];
    end
  end
%  disp('done');
  
end
