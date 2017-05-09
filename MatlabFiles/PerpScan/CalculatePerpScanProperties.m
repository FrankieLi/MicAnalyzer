%
%
%  Given a set of fitted absorption profile from PeakLocationFitting
%  and its set of parameter errors, calculate the normalized integrated
%  intensity, fitted position as a function of time, and so forth.
%
%  Note that we need an initial estimate of the position as a function of
%  time.  ( Haven't implemented a robust fitter for sin curves yet.)
%
%
%  parm is listed as:
%  [ 
%    origin                       1
%    Background                   2
%    A_0                          3
%    B_0                          4
%    Absoprtion                   5
%    FWHM                         6
%
%    ]
%  Cov is the covariance matrix with the same order as parm
%
%
function [FittedPositions, Errors ] = CalculatePerpScanProperties( peakCenters, params,...
                                                  A0, omega, phi, Bkg)
                                  

              
% need to calculate error later


x = [1:length(peakCenters)];
%
%  A0    = parm(1)
%  omega = parm(2)
%  phi   = parm(3)
%
initParm = zeros(3, 1);
initParm(1) = A0;
initParm(2) = omega;
initParm(3) = phi;
initParm(4) = Bkg;


[ newParm,residual,F_J ] = nlinfit( x,peakCenters,@PositionTimeSeries,initParm );
        
[ FittedPositions, Errors ]    = nlpredci( @PositionTimeSeries, x, newParm, residual, F_J );
%
%
%
%  

