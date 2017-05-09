%
%
%
%  Function GetVectorToCenter
%
%  Input:  Some center at (x, y)
%  Output: Number of pixels to move in the x and y coordinates to the 
%  ( Center being pixel 512 )
%
function r_center = GetVectorToCenter( x, y )



r_center = -[x, y];
r_center = r_center+ [512, 512];