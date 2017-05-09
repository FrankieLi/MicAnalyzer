%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  SelectRandomROI
%%
%%  Purpose:  Automatically attempt to select nROIs based on the set of
%%  images from the experiment.  These ROIs are used for knife-edge test.
%%
%%  
%%
%%  Parameters
%%      nROIs -- number of ROIs to be selected
%%      start -- first file index
%%      stop  -- last file index
%%      nProfileWidth -- one side width of the profile (perpendicular to the integration
%%                       direction)
%%      nProfileLength -- one side length of profile along the direction of integration
%%
%%  Output:
%%      ROIs -- a n x 2 x 2 matrix containing all ROIs found
%%      IntDirs -- Direction of integration for each of the ROI
%%
%%  NOTE:  Currently a prewitt fiter is used.  Other filters may be used
%%         depending on image property.
%%     
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ ROIs, IntDirs, SeedPoints ] = SelectRandomROI( start, stop, prefix, nROIs, nProfileLength, nProfileWidth )

sTestFile = [ prefix, padZero( floor( (start + stop)/2 ), 4), '.tif' ]
TestIm = imread( sTestFile );

% [ EdgeComponents, nComponents] = bwlabel( EdgePoints, 4 );

EdgePointsV = edge( TestIm, 'sobel', [] , 'vertical');
EdgePointsH = edge( TestIm, 'sobel', [], 'horizontal');

[VIndX, VIndY] = find( EdgePointsV == 1 );
[HIndX, HIndY] = find( EdgePointsH == 1 );
EdgePoints = xor( EdgePointsV, EdgePointsH );

imagesc( EdgePoints );
disp('Done initial image processing');

nPointSelected = 0;
ROIs       = zeros( nROIs, 2, 2 );
IntDirs    = zeros( nROIs, 1 );
SeedPoints = zeros( nROIs, 2 );
nMaxTrial = 1000;
nTrial = 0;

while( nPointSelected < nROIs && nMaxTrial > nTrial )
  nTrial = nTrial + 1;
  
%   % find random starting point from LabelX and LabelY
%   LabelInd = floor( 1 +  length(LabelX) -1.*rand(1,1)  );

  bVert = ( rand(1,1) > 0.5 );
  if( bVert )
      IntDir = 1;
      SeedInd = floor( 1 + length( VIndX ).*rand(1,1) );
      SeedX = VIndX( SeedInd );
      SeedY = VIndY( SeedInd );
      if ( EdgePointsH( SeedX, SeedY ) == 1 )
          bGoodStartingPoint = false;
      else
          bGoodStartingPoint = true;
      end
  else
      IntDir = 2;
      SeedInd = floor( 1 + length( HIndX ).*rand(1,1) );
      SeedX = HIndX( SeedInd );
      SeedY = HIndY( SeedInd );
      if ( EdgePointsV( SeedX, SeedY ) == 1 )
          bGoodStartingPoint = false;
      else
          bGoodStartingPoint = true;
      end
  end

   if( bGoodStartingPoint )
       [ TestRoi, bGrown ] = GrowROI ( TestIm, [ SeedX, SeedY ] , nProfileLength, nProfileWidth, IntDir );
       if ( bGrown )
          nPointSelected = nPointSelected + 1;
          ROIs( nPointSelected, :, : ) = TestRoi; 
          IntDirs( nPointSelected )    = IntDir;
          SeedPoints( nPointSelected, : ) = [ SeedX, SeedY ];
       end
  end
end


end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  GrowROI
%%
%%
%%
%% try fitting with the successful direction -- grow region as much as
%% possible
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ ROI, bSuccess ] = GrowROI ( snp, SeedPoint, nMaxProfileSize, nWidth, IntDir )

MedianCost = 1;
ROI = [];
bSuccess = false;
for i =  min(5, nWidth):nMaxProfileSize
  
    nShift = i;
  if( IntDir == 2 )
    TestROI = [ (SeedPoint(1) - nShift), (SeedPoint(1) + nShift);...
                (SeedPoint(2) - nWidth), (SeedPoint(2) + nWidth )];
  else
    TestROI = [ (SeedPoint(1) - nWidth), (SeedPoint(1) + nWidth);...
                (SeedPoint(2) - nShift), (SeedPoint(2) + nShift) ];
  end
  [ Profile, bEdge ]    = GetProfile( snp, TestROI, IntDir);
  if( bEdge )
      ROI = [];
      bSuccess = false;
      return;
  end
  x = [1:length(Profile)];
  if( size( x, 1) ~= size(Profile, 1) )
      x = x';
  end
  [params, resNorm, res, ExitFlag ] = FitErf( x, Profile, 1 );
  ROI = TestROI;
  bSuccess = true;
end


% ExitFlag <= 0 || 
MeanError = mean( abs( res )./ abs( Profile - mean( Profile ) ) );
if ( MeanError > 0.05 )
    ROI = [];
    bSuccess = false;
else
    disp( ['Mean Error: ' num2str( MeanError ), ' Dir ', num2str( IntDir )] );
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Given a seed point, try to find an ROI by selecting a profile
%%  in the two directions
%%  DEPRECATED
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ ROI, IntDir, bSuccess ]= MakeROI( snp, SeedPoint )
% 
% %  Check each directon -- if there's no drop off, then there's no edge
% 
% nMaxShift = 10;
% 
% bVotes = [];
% UpSlopes   = [];
% LeftSlopes = [];
% bQuit = false;
% for nShift = 2:nMaxShift
%   TestROI = [ (SeedPoint(1) - nShift), (SeedPoint(1) + nShift);...
%               (SeedPoint(2) - nShift), (SeedPoint(2) + nShift) ];
%   [ ProfileUp, bUpEdge ]    = GetProfile( snp, TestROI, 1);
%   [ ProfileLeft, bLeftEdge] = GetProfile( snp, TestROI, 2);
%  
%   if( bUpEdge || bLeftEdge )  % not using edge points
%     bSuccess = false;
%     ROI = [];
%     IntDir = 0;
%     return;
%   end
%   xUp   = [1:length(ProfileUp)   ];
%   xLeft = [1:length(ProfileLeft) ];
%   pUp   = polyfit( xUp, ProfileUp, 1); 
%   pLeft = polyfit( xLeft, ProfileLeft', 1); 
%   %%  Slope should be comparitively small.
%   %%
%   if( abs(pUp(1)) > abs(pLeft(1)) )
%     bVotes = [ bVotes; 1 ];
%   else
%     bVotes = [ bVotes; 2 ];
%   end
%   UpSlopes = [ UpSlopes; pUp(1) ];
%   LeftSlopes = [ LeftSlopes; pLeft(1) ];
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% check mean slope to see if it makes any sense
% %%
% %%  one of them should be close to zero, the other should be greater than
% %%  0.5
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MeanUpSlope = mean( abs( UpSlopes ) );
% MeanLeftSlope = mean( abs( LeftSlopes) );
% UpVotes   = find( bVotes == 1 );
% LeftVotes = find( bVotes == 2 );
% if( size( UpVotes, 1 ) > size( LeftVotes, 1 ) )
%   if( MeanUpSlope * 50 <= MeanLeftSlope )
%     bSuccess = false;
%     IntDir = 0;
%     ROI = [];
%     return;
%   end
%   IntDir = 1;
% else
%   if( MeanUpSlope >= MeanLeftSlope * 50  )
%     bSuccess = false;
%     IntDir = 0;
%     ROI = [];
%     return;
%   end  
%   IntDir = 2;
% end
% bSuccess = true;
% ROI = TestROI;
% 
end