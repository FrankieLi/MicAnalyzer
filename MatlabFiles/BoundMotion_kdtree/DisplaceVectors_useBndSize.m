%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
%       map# - N x 5 and contains x,y,z,GID1, GID2
%
%       delta_r_3D - the sphere for which nearest neighbors are
%                    interpreted.  3 dimensions are spatial coords
%
%       NptsToAvg - the number of nearest neighbors that are averaged for 
%                   a given point to determine displacement.  
%                   Note: NptsToAvg = 1 -> simple nearest neighbor search.
%
%       mapCon = 1 if displacement maps volume1 to volume2 
%               =0 if displacement maps volume2 to volume1
%
%       densityCon = 1 if we map boundary with low # of bnd points to map 
%                      with high # of bnd points. (kdtree on high # map)
%                  = 0 if we map high # of bnd points to low # of bnd points  
%                      (kdtree on low # map)
%
%       isoCon = 1 if boundaries in only one map are mapped to nearest
%                  spatial neighbor in other map (disregards boundary #).
%              = 0 if not mapped.  
%       
%       displacementFilePrefix - string for the output .bdp file.  File
%                                is M x 6, of the form x1,y1,z1, x2,y2,z2
%                                defining the displacement vectors.  If
%                                mapCon =1, x1,y1,z1 is points in map1.  If
%                                mapCon =0, x1,y1,z1 is points in map2.
%                                                           
%       Typically, use isoCon =0 and densityCon =1.
%
% Output: 
%       displaceMap - M x 6 file that is x,y,z endpoints of displacement vectors.
%                    - if mapCon = 1, cols 1-3 are from volume 1
%                    - if mapCon = 0, cols 1-3 are from volume 2
%                    This is outputted in a file:
%                    displacementFilePrefix.bdp
%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function displaceMap = DisplaceVectors_useBndSize(map1, map2, delta_r_3D, NptsToAvg, mapCon, densityCon, isoCon, displacementFilePrefix)


% Convert Grain ID pairs for two maps into single integers
[map1_single, map2_single] = ConsolidateGrainIDPairs(map1,map2);
    %map#_single is N x 4: 
    %x,y,z,Boundary Number

%Find the total number of distinct boundaries in 2 map system.
N_boundaries = max([max(map1_single(:,4)), max(map2_single(:,4))]);
displaceMap = []; % N x 6 map of displacement vectors

%Cycle through all boundaries
for bN=1:N_boundaries
    bN
    idx1 = [];
    idx2 = [];
    bnd1 = [];
    bnd2 = [];
    curVectors = [];
    
    %create files that only contain points for that one boundary type.
    idx1 = find(map1_single(:,4) == bN);
    idx2 = find(map2_single(:,4) == bN);
    bnd1 = map1_single(idx1,:);
    bnd2 = map2_single(idx2,:);
    inBoth = size(idx1,1) * size(idx2,1); % will ~= 0 if both maps contain this boundary

    %If both maps have the boundary
    if (inBoth > 0)
        curVectors = DisplacementBoth(bnd1, bnd2, delta_r_3D, NptsToAvg, mapCon, densityCon);
    else %If only one map has a specific boundary
        if(isoCon == 1) %we map boundaries to spatial nearest neighbors in other map, otherwise we ignore these boundaries
            curVectors = DisplacementSingle(idx1, idx2, bnd1,bnd2, map1_single, map2_single, delta_r_3D, NptsToAvg, mapCon );
        end
    end
    displaceMap = [displaceMap; curVectors];
end

% Write displacement vectors file.
n_displacement_vectors = size(displaceMap,1);
fid = fopen(strcat(displacementFilePrefix, '.bdp'), 'w');
for k=1:n_displacement_vectors
    fprintf(fid, '%f\t %f\t %f\t %f\t %f\t %f\n', displaceMap(k,1:6));
end
fclose(fid);