function SigmaTable = LoadSigmaTable( mMax )

% 
% SigmaTable = [     3.0000   60.0000    1.0000    1.0000    1.0000;...
%     5.0000   36.8600    1.0000         0         0;...
%     7.0000   38.2100    1.0000    1.0000    1.0000;...
%     9.0000   38.9400    1.0000    1.0000         0;...
%    11.0000   50.4700    1.0000    1.0000         0;...
%    13.0000   22.6200    1.0000         0         0;...
%    13.5000   27.7900    1.0000    1.0000    1.0000;...
%    15.0000   48.1900    2.0000    1.0000         0;...
%    17.0000   28.0700    1.0000         0         0;...
%    17.5000   61.9000    2.0000    2.0000    1.0000;...
%    19.0000   26.5300    1.0000    1.0000         0;...
%    19.5000   46.8000    1.0000    1.0000    1.0000;...
%    21.0000   21.7800    1.0000    1.0000    1.0000;...
%    21.5000   44.4100    2.0000    1.0000    1.0000;...
%    23.0000   40.4500    3.0000    1.0000    1.0000;...
%    25.0000   16.2600    1.0000         0         0;...
%    25.5000   51.6800    3.0000    3.0000    1.0000;...
%    27.0000   31.5900    1.0000    1.0000         0;...
%    27.5000   35.4300    2.0000    1.0000         0;...
%    29.0000   43.6000    1.0000         0         0;...
%    29.5000   46.4000    2.0000    2.0000    1.0000;...
%    31.0000   17.9000    1.0000    1.0000    1.0000;...
%    31.5000   52.2000    2.0000    1.0000    1.0000;...
%    33.0000   20.1000    1.0000    1.0000         0;...
%    33.3000   33.6000    3.0000    1.0000    1.0000;...
%    33.7000   59.0000    1.0000    1.0000         0;...
%    35.0000   34.0000    2.0000    1.0000    1.0000;...
%    35.5000   43.2000    3.0000    3.0000    1.0000   ];
%  
 
if( nargin < 1 )
  mMax = 7;
else
  disp([ 'nMax ', num2str( mMax ) ] );
end

SigmaTable = GenerateCSLTable(mMax);
SigmaTable = RenameSigmaTable( SigmaTable );
qSigma = QuatOfAngleAxis( SigmaTable(:, 2)' * pi / 180, SigmaTable(:, 3:5)');
 
SigmaTable = [SigmaTable, qSigma'];
end