%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  PlotPeakBoundingBox
%%
%%  Purpose:  Given a center of intensity calculation,
%%            plot all bounding box around peaks.
%%
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PlotPeakBoundingBox( ImSnp, IntensityInfo, ColorFlag, ImageScale )

if nargin < 2
  error('Usage:  PlotPeakBoundingBox( Image, IntensityInfo,[  ColorFlag, ImageScale ]) ');
elseif nargin == 2
  ColorFlag = 'r';
elseif nargin == 3
  ImageScale = [0, max( max(ImSnp) ) ];
end



hold on;

imagesc( ImSnp, ImageScale );
for i = 1:size( IntensityInfo, 1 ) 
  ErrorBox = IntensityInfo( i, 3:6 );
  Center   = IntensityInfo( i, 1:2 );
  Vertices = [ Center + ErrorBox( [1, 3] ); ...
               Center + ErrorBox( [1, 4] ); ...
               Center + ErrorBox( [2, 4] ); ...
               Center + ErrorBox( [2, 3] ); ...
               Center + ErrorBox( [1, 3] ) ];
  plot( Vertices(:, 2), Vertices(:, 1), ColorFlag );
end

hold off;


end