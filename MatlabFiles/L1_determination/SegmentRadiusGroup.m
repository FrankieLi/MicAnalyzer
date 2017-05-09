%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SegmentRadiusGroup.m
%
% Purpose of this function is create a set of indices that are the edges of
% a radius group (i.e. set of points that have the same 2theta).
%
% Input - List of spots (Spot_List) an N x 12 matrix, where 12th row is:
%            Spot_List(i,11) - Spot_List(i-1,11), where the 11th column is spot's
%            radial distance from origin.
%         breakstep - radial threshold that indicates change in radius group.
%
% Output - breaks_start and breaks_end - list of indices indicating start
%               and stop of radius group.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [breaks_start, breaks_end] = SegmentRadiusGroup(Spots_List, breakstep)

%breaks contain indices where new radius groups begin.
    breaks = find(Spots_List(:,12) > breakstep);
  
    %first index should be the first radius group.
    breaks_start(1) = 1;
    Nb = length(breaks);
    
    %breaks_start(1) = 1, rest are the beginning of radius groups.
    breaks_start(2:Nb+1) = breaks;
    
    %last index in a radius group
    breaks_end = breaks_start - 1;
    
    %remove that first entry since it's zero (breaks_start(1) = 1)
    breaks_end = breaks_end(2:end);
    
    %Last radius index should be the last saved spot
    breaks_end(end+1) = size(Spots_List,1);

    