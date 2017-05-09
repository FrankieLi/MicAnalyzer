%%
%%  Author:   Frankie Li
%%  e-mail:   sfli@cmu.edu
%%  Date:     Oct 3, 2009.
%%
%%  GetFocusInfo
%%   IntDim is the dimension of integration (1 or 2)
%% 
%%  Usage:  GetFocusInfo ( StartFileNumber, StopFileNumber, FilePrefix, ROIs,
%%  IntegrationDirection, [ RunPlot ] )
%%
%%  Parameters:  Given a set of files, MyName_0001.tif to MyName_00nn.tif, 
%%               the prefix will be 'MyName_', StartFileNumber would be 1,
%%               and stop would be nn.
%%
%%               ROIs -- n x 2 x 2 matrix that represents the region of
%%               interest.  Note that given an image TestIm, the region of
%%               interest is selected to be:
%%               TestIm( ROIs( i, 1, 1): ROIs(i, 1, 2), ROIs(i, 2,
%%               1):ROIs(i, 2, 2) );
%%
%%               IntegrationDirection is a n x 1 matrix which contains the
%%               index where te sum (integration) will be performed.  i.e.:
%%               sum( snp, IntDim )
%%
%%
%%  Output:      Width is a 2 * n x (stop - start + 1) matrix, which is
%%               tiled as:
%%                  [ Sigma_1, Err(Sigma_1), Sigma_2, Err(Sigma_2) ... ]
%%
%%               Note that Sigma_1 here is the parameter identified in the
%%               error function for the first ROI.  To convert from Sigma
%%               to FWHM:  FWHM = ( 2 sqrt( log(2) ) ) / Sigma
%%
function [ WidthParams, Centers, Errors ] = GetFocusInfo( start, stop, prefix, ROIs, IntDims, RunPlot  )

bPlotFlag = false;
if( nargin == 6 )
  if( RunPlot == 1 )
      bPlotFlag = true;
  end
end


modelErf = @(c,x) c(1) + c(2) .* erf(c(3) .* (x  - c(4)) );
NPoints = stop - start +1;
Nx = floor(sqrt(NPoints));

if( bPlotFlag )
    figure;
end

nPlotNum = 1;
j = 1;
numROIs = size(ROIs, 1);
WidthParams = zeros( NPoints, 2*numROIs );
Centers     = zeros( NPoints, 2*numROIs );
Errors      = zeros( NPoints, 2*numROIs );
for i = start:stop
    sFilename = [ prefix, padZero( i, 4 ), '.tif'];    
    snp = imread( sFilename );
    for n = 1:numROIs
        ROI = squeeze( ROIs(n, :, : ) );
        snpROI = snp( ROI(1,1):ROI(1,2), ROI(2,1):ROI(2,2) );
        p = sum(snpROI, IntDims(n) );

        if( IntDims(n) == 2)
            x = [ROI(1,1):ROI(1,2)];
        elseif (IntDims(n) == 1)
            x = [ROI(2,1):ROI(2,2)];       
        end

        [params, resNorm, res, ExitFlag] = FitErf( x, p );
        WidthParams(j, n) = params(3);
        Centers(j, n)     = params(4);
        Errors (j, n)     = sqrt(resNorm/length(p)); 
        if( bPlotFlag )
            subplot( Nx, ceil(NPoints / Nx), nPlotNum )
            hold on;            
            plot(x, p,'k', x, modelErf( params, x ), 'r' );   
            hold off;
        end
        nPlotNum = nPlotNum + 1;
    end
    j = j +1;
end

end

