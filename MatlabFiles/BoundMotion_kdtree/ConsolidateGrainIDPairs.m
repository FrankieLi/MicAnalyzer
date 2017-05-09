%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ConsolidateGrainIDPairs -
% Convert grain ID pairs in the two maps into single values
% Assumes Grain X in volume 1 is Grain X in volume 2.
% 
% Input:
%       map# is N x 5 - x,y,z,GID1, GID2
%
% Output: 
%       map#_single is N x 4 - x,y,z,BoundaryNumber
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ map1_single, map2_single] = ConsolidateGrainIDPairs(map1,map2)

%Keep only grain ID pairs to integers
gid_1 = map1(:,4:5);
gid_2 = map2(:,4:5);

%Find distinct grain pairs
[unq_gid_1, i_gid_1, i_uq_1] = unique(gid_1,'rows'); %unq_gid_1(i_uq_1,:) = gid_1;
[unq_gid_2, i_gid_2, i_uq_2] = unique(gid_2,'rows'); %unq_gid_2(i_uq_2,:) = gid_2;

%Find pairs that are common to both volumes.
[gid_both, i1, i2] = intersect(unq_gid_1, unq_gid_2, 'rows'); %unq_gid_1(i1) = gid_both

%i_gid#_to_idx maps element index in gid_# (col 1) to a single boundary ID number
%(col2) that is the same for both maps.  Iss N x 2.
i_gid1_to_idx = []; 
i_gid2_to_idx = [];

n = 0; %counter for boundary number

%First look at GID pairs common to both maps
for k=1:size(gid_both,1)
    n = n + 1;
    tmp1 = find(i1(k) == i_uq_1); %find indices in gid_1 that are assoc. with common ID pairs to both maps
    tmp2 = find(i2(k) == i_uq_2);
    cur1(:,1) = tmp1; %indices in gid_1
    cur1(:,2) = n; % single value for grain pair
    cur2(:,1) = tmp2; %indices in gid_2
    cur2(:,2) = n; % same single value for grain pair
    i_gid1_to_idx = [i_gid1_to_idx; cur1];
    i_gid2_to_idx = [i_gid2_to_idx; cur2];
    cur2 =[];
    tmp2=[];
    cur1 = [];
    tmp1 = [];
end

%Find ID pairs that occur only in one map (critical event -> new boundary type formed)
[gid_only1, ionly1] = setdiff(unq_gid_1,unq_gid_2, 'rows'); 
[gid_only2, ionly2] = setdiff(unq_gid_2,unq_gid_1,'rows');

%GIDs only in map1
for k=1:size(gid_only1,1)
    n = n + 1;
    tmp1 = find(ionly1(k) == i_uq_1); %indices for unique boundary in gid_1
    cur1(:,1) = tmp1;
    cur1(:,2) = n;
    i_gid1_to_idx = [i_gid1_to_idx; cur1];
    cur1 = [];
    tmp1 = [];
end

%GIDs only in map 2
for k=1:size(gid_only2,1)
    n = n + 1;
    tmp2 = find(ionly2(k) == i_uq_2);
    cur2(:,1) = tmp2;
    cur2(:,2) = n;
    i_gid2_to_idx = [i_gid2_to_idx; cur2];
    cur2 = [];
    tmp2 = [];
end

%i_gid#_to_idx now has a mapping for every grain pair to an unique boundary number 
%(idx in gid_# is column 1, boundary number is column 2)

%Sort map key by element number, so x,y,z can be appended.
i_gid1_to_idx = sortrows(i_gid1_to_idx,1);
i_gid2_to_idx = sortrows(i_gid2_to_idx,1);

%map#_single works as (x,y,z, Boundary#)
map1_single(:,1:3) = map1(:,1:3);
map1_single(:,4) = i_gid1_to_idx(:,2);
map2_single(:,1:3) = map2(:,1:3);
map2_single(:,4) = i_gid2_to_idx(:,2);
