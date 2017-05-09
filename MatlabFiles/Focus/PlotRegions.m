%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%
%%
%%  PlotRegions  -- diagonistics function for ROI integration and focus
%%  test
%%
%%     
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PlogRegions( filename, ROIs, bShowRegions, SeedPoints )

nRegions = size( ROIs, 1 );
bFlag = false;
if( nargin >= 3)
    if( bShowRegions == 1)
        bFlag = true;
    end
end

bShowSeedPoints = false;
if( nargin == 4 )
    bShowSeedPoints = true;
end

figure;
snp = imread( filename );
PlotLabels = {'Top Left', 'Bottom Left', 'Bottom Right', 'Top Right', 'Center',...
    'Top Left Half', 'Bottom Left Half', 'Bottom Right Half', 'Top Right Half'};

for i = 1:nRegions
    subplot( floor( sqrt(nRegions) ), ceil( nRegions / floor( sqrt(nRegions) ) ), i);
    imagesc( snp( ROIs(i, 1, 1):ROIs(i, 1, 2), ROIs(i, 2, 1):ROIs(i, 2,2) ) );
   % title( PlotLabels{i});
end

if( bFlag  )

% hold on;
% h = imshow( snp , [1, median(median(snp))] );
% mask = ones( size(snp) );
% hold off;
snpMasked = snp;
maxVal = max(max( snp ) );
for i = 1:nRegions
  v = squeeze( ROIs( i, :, :));
  v = [v(:, 2), v(:, 1)];
  myBox = [ v(1, 1), v(2, 1);...
            v(1, 2), v(2, 1);...
            v(1, 2), v(2, 2);...
            v(1, 1), v(2, 2);...
            v(1, 1), v(2, 1)];
  snpMasked( ROIs(i, 1, 1):ROIs(i, 1, 2), ROIs(i, 2, 1):ROIs(i, 2,2) ) ...
      = snpMasked( ROIs(i, 1, 1):ROIs(i, 1, 2), ROIs(i, 2, 1):ROIs(i, 2,2) ) * 0;
  if( bShowSeedPoints )
      snpMasked( ( SeedPoints( i, 1 ) - 1 ) : (SeedPoints( i, 1 ) +1 )  , ( SeedPoints( i, 2 ) -1 ):( SeedPoints( i, 2 )  + 1) ) = maxVal;
  end
end
figure;
imagesc(snpMasked);
% hold on;
% set(h, 'AlphaData', mask);
% hold off;
end