%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GetBoundaryDisplace_wkdtree generates a displacement map to map
% boundaries from one volume/layer to another.
%
%INPUT:
%
% filename is file with N x 7 matrix of grain boundary information and is
% organized as follows:
%
% Column 1:3 - (x1,y1,z1)  
% Column 4:6 - (x2,y2,z2)  ---- these pairs define the end points of a boundary segment
% Column 7 - boundary misorientation (degrees)
% Column 8 - Grain ID 1
% Column 9 - Grain ID 2
%
% mis_thresh_deg = lowest misorientation boundary that is used
% delta_r_3D = radius of sphere in spatial dimensions for nearest neighbor
%              searches
% NptsToAvg = most number of nearest neighbors for displacement vector
%             averaging
% mapCon = mapping convention of output.  If = 1 we map vol1 to vol2, if =
%                                         0, we map vol2 to vol1.  (vol1 is
%                                         assoc. with filename1)
% densityCon = convention for kdtree generation/nearest neighbor search
%            =1 --> use boundary with greater # of points as map for kdtree
%            generation.  Then search for nearest neighbors of the smaller
%            # of points boundary in this tree. (
%            =0 --> use boundary with fewer # of points as map for kdtree
%            generation.  Search for nearest neighbors of the larger # of
%            points in this tree made by the smaller dataset.
%
%      Rule of thumb is densityCon = 0 --> get most displacement vectors,
%                      =1 --> greater likelihood of unique 1-to-1 mapping 
%
% isoCon = convention for mapping boundaries that show up in only one map
%        = 1 --> map these boundaries to nearest spatial point in other map
%        = 0 --> no mapping is done
%
% displaceFilePrefix is the prefix of the outfile that will contain an N x
% 6 matrix, where first three columns are the x,y,z coords of displacement
% vector from original volume, last three columns are x,y,z of final
% volume.  File will be called displaceFilePrefix.bdp
%
% OUTPUT:
%  ptMap# is N x 5 matrix in the form x,y,z,GID1, GID2.  x,y,z are center
%  points of boundary lines
%  
%  displaceMap is M x 6 of the form x_i,y_i,z_i,x_f,y_f,z_f that define
%  displacement vectors under the manner defined by mapCon
%
% Function needs:
% ConsolidateGrainIDPairs.m
% DisplacementBoth.m
% DisplacementSingle.m
% DisplaceVectors_useBndSize.m
% NaiveKdtree.m
%
% Work under the assumption that grain A in volume 1 is assigned the same name
% grain ID number as grain A in volume 2, or else can be given by some
% 1-to-1 mapping
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ptMap1, ptMap2, displaceMap] = GetBoundaryDisplace_wkdtree(filename1, filename2, mis_thresh_deg, delta_r_3D, NptsToAvg, mapCon, densityCon, isoCon, displaceFilePrefix)

bnd_data1 = textread(filename1);
bnd_data2 = textread(filename2);

%Force GrainID_1 < GrainID_2
gid1 = bnd_data1(:,8:9);
gid2 = bnd_data2(:,8:9);
gid1_s = sort(gid1,2);
gid2_s = sort(gid2,2);
bnd_data1(:,8:9) = gid1_s;
bnd_data2(:,8:9) = gid2_s;

%Threshold boundaries above mis_thresh_deg
idx1_pMis = find(bnd_data1(:,7) >= mis_thresh_deg);
idx2_pMis = find(bnd_data2(:,7) >= mis_thresh_deg);
bnd1_mThresh = bnd_data1(idx1_pMis,:);
bnd2_mThresh = bnd_data2(idx2_pMis,:);


%Convert end points of boundary line to a mid point position
xMap1 = (bnd1_mThresh(:,1) + bnd1_mThresh(:,4)) ./ 2;
yMap1 = (bnd1_mThresh(:,2) + bnd1_mThresh(:,5)) ./ 2;
zMap1 = (bnd1_mThresh(:,3) + bnd1_mThresh(:,6)) ./ 2;
xMap2 = (bnd2_mThresh(:,1) + bnd2_mThresh(:,4)) ./ 2;
yMap2 = (bnd2_mThresh(:,2) + bnd2_mThresh(:,5)) ./ 2;
zMap2 = (bnd2_mThresh(:,3) + bnd2_mThresh(:,6)) ./ 2;

%Turn map into misorientation thresholded x,y,z  GrainID1, GrainID2
ptMap1 = [xMap1, yMap1, zMap1, bnd1_mThresh(:,8:9)];
ptMap2 = [xMap2, yMap2, zMap2, bnd2_mThresh(:,8:9)];

% %In the event that we only want the center region of the mic file
% R1 = sqrt(ptMap1(:,1) .* ptMap1(:,1) + ptMap1(:,2) .* ptMap1(:,2));
% R2 = sqrt(ptMap2(:,1) .* ptMap2(:,1) + ptMap2(:,2) .* ptMap2(:,2));
% idx_inner1 = find(R1 < mic_radius);
% idx_inner2 = find(R2 < mic_radius);
% circleMap1 = ptMap1(idx_inner1,1:4);
% circleMap2 = ptMap2(idx_inner2,1:4);

NaiveKdtree(map1,map2); %produces a naive kdtree tree where only nearest neighbors are used and
                                                        %minimal attention paid to boundary assignments
                                                        
%Produce displacement vectors by analyzing each boundary individually with
%a kdtree
displaceMap = DisplaceVectors_useBndSize(ptMap1, ptMap2, delta_r_3D, NptsToAvg, mapCon, densityCon, isoCon, displaceFilePrefix);
                                
%plot original volume with displacement vectors
figure(10)
plot(ptMap1(:,1), ptMap1(:,2), '.r')
hold on
for i=1:size(displaceMap,1)
    line([displaceMap(i,1), displaceMap(i,4)], [displaceMap(i,2), displaceMap(i,5)], 'Color','r');
    hold on
end
axis equal

%plot both volume points with displacement vectors
figure(11)
plot(ptMap1(:,1), ptMap1(:,2), '.r')
hold on
plot(ptMap2(:,1), ptMap2(:,2), '.k')
hold on
for i=1:size(displaceMap,1)
    line([displaceMap(i,1), displaceMap(i,4)], [displaceMap(i,2), displaceMap(i,5)], 'Color','r');
    hold on
end
axis equal

















% %Produce kdtree for the two maps - 4D space (x,y,GID1, GID2)
% tree1 = kdtree(circleMap1);
% tree2 = kdtree(circleMap2);
% 
% %Find closest point in 5 dimensional space between the two sets
% [idx_in2, val_in2] = kdtree_closestpoint(tree1, circleMap2); %idx_in2 is the index in circleMap2 that corresponds to the closest point in circleMap1
% [idx_in1, val_in1] = kdtree_closestpoint(tree2, circleMap1);
% size(circleMap1)
% size(circleMap2)
% 
% for i=1:size(circleMap1,1)
%     x_low = circleMap1(i,1) - delta_r;
%     x_high = circleMap1(i,1) + delta_r;
%     y_low = circleMap1(i,2) - delta_r;
%     y_high = circleMap1(i,2) + delta_r;
%     
%     gid1_low = circleMap1(i,3) - 0.5;
%     gid1_high = circleMap1(i,3) + 0.5;
%     
%     gid2_low = circleMap1(i,4) - 0.5;
%     gid2_high = circleMap1(i,4) + 0.5;
%     
%     rng = [ [x_low x_high]; [y_low y_high]; [gid1_low gid1_high]; [gid2_low gid2_high]; ];
%     pntidx = kdtree_range(tree2, rng);
% end