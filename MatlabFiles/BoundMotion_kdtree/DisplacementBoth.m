%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DisplacementBoth looks at boundaries that occur in both maps and produces a set
% of displacement vectors.  The kdtree generation and direction of mapping
% is set by mapCon and densityCon
%
% Input:
%
%   bnd# - N x 4 file of all points defining one boundary: x,y,z,boundaryNumber  
% 
%   delta_r_3D - radius of 3D sphere that is used for nearest neighbor extraction 
%
%   NptsToAvg - # of nearest neighbor points that are averaged to find the
%               end of each displacement vector
%
%   mapCon - mapping convention (=1 for vol1 to vol2, =0 for vol2 to vol1)
%
%   densityCon - kdtree generation convention (=1 use larger point set to
%                generate kdtree, =0 use smaller point set to generate kdtree)
%
% Output:
%   
%   bothVectors - M x 6 file that defines the displacement vectors
%                 (x1,y1,z1, x2, y2, z2).  x1 is from vol1 if mapCon =1, from vol2 if
%                  mapCon =0.  M will either be size(bnd1,1) or size(bnd2,1) depending on
%                  densityCon setting.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bothVectors = DisplacementBoth(bnd1, bnd2, delta_r_3D, NptsToAvg, mapCon, densityCon);

aLarger = 2;

if (mapCon == 1) %map vol1 to vol2
    mapA = bnd1;
    mapB = bnd2;
else %map vol2 to vol1
    mapA = bnd2;
    mapB = bnd1;
end

%densityCon = 1 if we map boundary with fewer points to map with more boundary points. 
%           = 0 if we map larger # of boundaries to low # of boundaries points.  

if (size(mapA,1) > size(mapB,1)) %if volA is larger
    mapMore = mapA;
    mapLess = mapB;
    aLarger = 1; %mapMore goes with volA
else %if volB is larger
    mapMore = mapB;
    mapLess = mapA;
    aLarger = 0; %mapMore goes with volB
end

bothVectors = [];

if (densityCon == 1) %we use mapMore as the kdtree (will have fewer displacement vectors)
                                                  
        %create kdtree for bnd2
%        [cp_inMtoL, dist_inMtoL, rootMore] = kdtree(mapMore, mapLess); %create kdtree and store it in rootMore
        [tmp, tmp, rootMore] = kdtree(mapMore, []);    
        for inLess=1:size(mapLess,1)
            tmp_inMore = [];
            pts_use = [];
            dist_sort = [];
            idx_sort = [];
            cur_query = [];
            x = [];
            y = [];
            z = [];
            nearestPoints_inMore = [];
            dist_inMore = [];
            cur_query = [ mapLess(inLess,1) mapLess(inLess,2) mapLess(inLess, 3) mapLess(inLess,4)];
            [nearestPoints_inMore, dist_inMore] = kdrangequery( rootMore, cur_query, delta_r_3D );
            if (size(nearestPoints_inMore,1) > NptsToAvg) %have too many nearest neighbors
                [dist_sort, idx_sort] = sort(dist_inMore);
                pts_use = nearestPoints_inMore(idx_sort(1:NptsToAvg),:);
                x = mean(pts_use(:,1)); %avg of NptsToAvg # of points in mapMore that are closest to bndLess(inLess,1:3)
                y = mean(pts_use(:,2)); %note we are avging in mapMore
                z = mean(pts_use(:,3));
                if (aLarger == 1) %mapLess is volB
                    
                    tmp_inMore = [ x,y,z, mapLess(inLess,1), mapLess(inLess,2), mapLess(inLess,3)]; %volA(x,y,z), volB(x,y,z)
                else %mapLess is volA
                    
                    tmp_inMore = [mapLess(inLess,1), mapLess(inLess,2), mapLess(inLess,3), x, y, z]; %volA(x,y,z), volB(x,y,z)
                end
            elseif (size(nearestPoints_inMore,1) > 0)%have AT MOST NptsToAvg # of nearest neighbors
                pts_use = nearestPoints_inMore;
                    x = mean(pts_use(:,1));
                    y = mean(pts_use(:,2));
                    z = mean(pts_use(:,3));
                    if (aLarger == 1) %mapLess is volB
                        tmp_inMore = [ x,y,z, mapLess(inLess,1), mapLess(inLess,2), mapLess(inLess,3)]; %volA(x,y,z), volB(x,y,z)
                    else %mapLess is volA
                        tmp_inMore = [mapLess(inLess,1), mapLess(inLess,2), mapLess(inLess,3), x, y, z]; %volA(x,y,z), volB(x,y,z)
                    end
                
            end
            bothVectors_cur = tmp_inMore;
            bothVectors = [bothVectors; bothVectors_cur];
            bothVectors_cur = [];
        end
            kdtree([],[], rootMore);
end

if (densityCon == 0) %we use mapLess as the kdtree (will have more displacement vectors)

    %create kdtree mapLess
    [cp_inLtoM, dist_inLtoM, rootLess] = kdtree(mapLess, mapMore); 

    for inMore=1:size(mapMore,1)
        tmp_inLess = [];
        pts_use = [];
        dist_sort = [];
        idx_sort = [];
        x = [];
        y = [];
        z = [];
        cur_query = [ mapMore(inMore,1) mapMore(inMore,2) mapMore(inMore, 3) mapMore(inMore,4)];
        [nearestPoints_inLess, dist_inLess] = kdrangequery( rootLess, cur_query, delta_r_3D );
        
        if (size(nearestPoints_inLess,1) > NptsToAvg)
            [dist_sort, idx_sort] = sort(dist_inLess);
            pts_use = nearestPoints_inLess(idx_sort(1:NptsToAvg),:);
            x = mean(pts_use(:,1)); %we are averaging in mapLess
            y = mean(pts_use(:,2));
            z = mean(pts_use(:,3));
            if (aLarger == 1) %mapLess is volB
                tmp_inLess = [mapMore(inMore,1), mapMore(inMore,2), mapMore(inMore,3), x,y,z ];
            else %mapLess is volA
                tmp_inLess = [x,y,z, mapMore(inMore,1), mapMore(inMore,2), mapMore(inMore,3) ];
            end
        elseif (size(nearestPoints_inLess,1) > 0)
            pts_use = nearestPoints_inLess;
            x = mean(pts_use(:,1));
            y = mean(pts_use(:,2));
            z = mean(pts_use(:,3));
            if (aLarger == 1) %mapLess is volB
                tmp_inLess = [mapMore(inMore,1), mapMore(inMore,2), mapMore(inMore,3), x,y,z ];
            else %mapLess is volA
                tmp_inLess = [x,y,z, mapMore(inMore,1), mapMore(inMore,2), mapMore(inMore,3) ];
            end
        end
            bothVectors_cur = tmp_inLess;
            bothVectors = [bothVectors; bothVectors_cur];
            bothVectors_cur = [];
    end
    
        kdtree([],[], rootLess); %free kdtree from memory
end
