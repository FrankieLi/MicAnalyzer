%
%
%
%  Function CenterRotationAxis
%
%  Input:  center location at 0, 90, 180, 270
%  Output: Number of pixels to move the rotation axis to the center the
%  rotation axis (r_center) and the vector [x, y] to move the sample so
%  that it's located at the rotational axis
%  ( Center being pixel 512 )
%
%
%  move sample by samp_center *AFTER* moving the rotation stage by
%  r_rot_to_center along the y direction (direction parallel to the
%  detector plane
%
function [r_rot_to_center, samp_center] = CenterRotationAxis( center0, center90, center180, center270 )




x = ( center90 + center270 ) / 2;  % these two should be exactly the same
y = ( center0 + center180 ) / 2;

r_rot_to_center = - ( y - 512 );


x = center90 + r_rot_to_center;
y = center0 + r_rot_to_center;

samp_center = GetVectorToCenter( x, y );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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