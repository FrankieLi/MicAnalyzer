%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% FilterBySpotSize.m - function takes in the new center of intensity matrix
%                      along with relevant omega information (layer #,
%                      omega interval, detector distance # (1, 2 or 3).
%                      Returns spots that are the proper size to be deemed
%                      sample scattering.
%
% Input - cofi_matrix = N x 7 matrix of the form:
%                       col1 = j(center) (horizontal)
%                       col2 = k(center) (vertical)
%                       col3 = # of pixels
%                       col4-5 = j edge pixels
%                       col6-7 = k edge pixels
%
%         N_pix_lowThresh = min # pixels in peak
%         N_pix_upperThresh = max # pixels in peak
%         nLayer = z layer number (integer)
%         nOmega = omega interval (integer)
%         nL = detector distance (1, 2, or 3)
%         SpotList is a running total of all valid spots that is appended
%                   after each call 
%         SpotList_L is a running total of all valid spots at this L
%         distance
%
% Output - validSpots = modified cofi_matrix so that only spots of sizes
%                       between [N_pix_lowThresh, N_pix_upperThresh] are retained.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [validSpots, SpotList, SpotList_L] = FilterBySpotSize(cofi_matrix, N_pix_lowThresh, N_pix_upperThresh, zLayer, nOmega, nL, SpotList, SpotList_L )

validSpots = [];
greater_idx = [];
less_idx = [];
idx_use = [];

greater_idx = find(cofi_matrix(:,3) >= N_pix_lowThresh); %Spots that are large enough to be sample scattering
less_idx = find(cofi_matrix(:,3) <= N_pix_upperThresh); %Spots that are too large to be coming from sample
idx_use = intersect(greater_idx, less_idx);

if (size(idx_use,1) > 0)
    validSpots = cofi_matrix(idx_use,:);
    validSpots(:,8) = zLayer; % z layer number
    validSpots(:,9) = nOmega; % omega interval
    validSpots(:,10) = nL; % L value
    
    SpotList = [SpotList; validSpots];
    SpotList_L = [SpotList_L; validSpots];
end


