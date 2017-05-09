%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DisplacementSingle maps boundaries that occur in only one map to the
% nearest spatial point in the other map.  Totally ignores boundaryNumber,
% so it's useful is questionable.  Serves as a way to handle a critical
% event
%
%   bnd# - N x 4 file of all points defining one boundary: x,y,z,boundaryNumber  
% 
%   map#full - NN x 4 file containing all boundary points: x,y,z,boundaryNumber
%
%   delta_r_3D - radius of 3D sphere that is used for nearest neighbor extraction 
%
%   NptsToAvg - # of nearest neighbor points that are averaged to find the
%               end of each displacement vector
%
%   mapCon - mapping convention (=1 for vol1 to vol2, =0 for vol2 to vol1)
%
%
% Output:
%   
%   singleVectors - M x 6 file that defines the displacement vectors
%                 (x1,y1,z1, x2, y2, z2).  x1 is from vol1 if mapCon =1, from vol2 if
%                  mapCon =0.  M will be the size of finite boundary.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function singleVectors = DisplacementSingle(bnd1,bnd2, map1full, map2full, delta_r_3D, NptsToAvg, mapCon)

aHas = 2;

if (mapCon == 1) %map vol1 to vol2
    mapA = bnd1;
    mapB = bnd2;
    mapAf = map1full;
    mapBf = map2full;
else %map vol2 to vol1
    mapA = bnd2;
    mapB = bnd1;
    mapAf = map2full;
    mapBf = map1full;
end

if(size(mapA,1) > 0) %if mapA has the boundary
    mapWith = mapA; 
    mapNone = mapBf;
    aHas = 1; %volume A has the boundary
else % if mapB has the boundary
    mapWith = mapB;
    mapNone = mapAf;
    aHas = 0; %volume B has the boundary
end

[cp_inNtoW, dist_inNtoW, rootNone] = kdtree(mapNone, []); %create kdtree for the boundary-less map and store it in rootNone
singleVectors = [];

for inWith=1:size(mapWith,1)
    tmp_inNone = [];
    pts_use = [];
    dist_sort = [];
    idx_sort = [];
    x = [];
    y = [];
    z = [];
    singleVectors_cur =[];
        
    [nearestPoints_inNone, dist_inNone] = kdrangequery( rootNone, mapWith(inWith,:), delta_r_3D ); %search kdtree for nearest points to mapWith
    if (size(nearestPoints_inNone,1) > NptsToAvg) %have too many nearest neighbors
        [dist_sort, idx_sort] = sort(dist_inNone);
        pts_use = nearestPoints_inNone(idx_sort(1:NptsToAvg),:);
        x = mean(pts_use(:,1)); %avg of NptsToAvg # of points in mapNone that are closest to bndLess(inLess,1:3)
        y = mean(pts_use(:,2)); %note we are avging in mapNone
        z = mean(pts_use(:,3));
        if (aHas == 1) %mapWith is volA
            singleVectors_cur = [mapWith(inWith,1), mapWith(inWith,2), mapWith(inWith,3),x,y,z]; %volA(x,y,z), volB(x,y,z)
        else %mapNone is volA
            singleVectors_cur = [x, y, z, mapWith(inWith,1), mapWith(inWith,2), mapWith(inWith,3)]; %volA(x,y,z), volB(x,y,z)
        end
    elseif (size(nearestPoints_inNone,1) > 0) %have AT MOST NptsToAvg # of nearest neighbors
        pts_use = nearestPoints_inNone;
        x = mean(pts_use(:,1));
        y = mean(pts_use(:,2));
        z = mean(pts_use(:,3));
        if (aHas == 1) %mapLess is volB
            singleVectors_cur = [mapWith(inWith,1), mapWith(inWith,2), mapWith(inWith,3),x,y,z]; %volA(x,y,z), volB(x,y,z)
        else %mapNone is volA
            singleVectors_cur = [x, y, z, mapWith(inWith,1), mapWith(inWith,2), mapWith(inWith,3)]; %volA(x,y,z), volB(x,y,z)
        end
    end
    
    singleVectors = [singleVectors; singleVectors_cur];
end

    kdtree([],[], rootNone);