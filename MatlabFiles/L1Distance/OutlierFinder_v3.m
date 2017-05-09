function omits = OutlierFinder_v3(AllLines_LSF, Zfit_LSF, Spots, Opt_L1)

% This function is intersections at the minimum dispersion plane and
% eliminate them to get a more accurate L1

%Functions called:  PlaneLineIntersection_xy.m

num_Lines = size(AllLines_LSF,1);
POS =[];
Dist = [];

% Find the intersection location of line with Opt_L1 plane
   XY = PlaneLineIntersection_xy(AllLines_LSF, Spots, Zfit_LSF, Opt_L1);
   
size(XY)
% Calculate distance from mean for each intersection
for i=1:num_Lines
    Dist(i) = sqrt( ( XY(i,1) - mean(XY(:,1)))^2 + ( XY(i,2) - mean(XY(:,2)))^2);
end


sigma = std(Dist);
mu = mean(Dist);

sup_dist = mu + 3*sigma; %supremum
inf_dist = mu - 3*sigma; %infimum

cand= [];
cnt = 0;

for i=1:num_Lines
    if ( ( Dist(i) < inf_dist) || (Dist(i) > sup_dist))
        cnt = cnt + 1;
        cand(cnt) = i;
    end
end

omits = cand;