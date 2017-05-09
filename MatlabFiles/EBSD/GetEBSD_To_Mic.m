function g = GetEBSD_To_Mic(EBSD_subgrain, mic_subgrain, pm)

EBSD_subgrain_reduced = ReduceEBSDToFZ(EBSD_subgrain);

EBSD_ave = averageOrientation(EBSD_subgrain_reduced(:, 1:3));

% note that Mic_subgrain is in degree
mic_ave = averageOrientation(mic_subgrain(:, 7:9) * pi/180);

mic_pos_R = getEuler_rad_pos(mic_ave);
EBSD_neg_R = getEuler_rad_neg(EBSD_ave);

EBSD_pos_R = getEuler_rad_pos(EBSD_ave);
mic_neg_R = getEuler_rad_neg(mic_ave);
if (pm == -1)
%  undo EBSD, do mic rotation
    g =  EBSD_pos_R * mic_neg_R ;
else
    g =  EBSD_neg_R * mic_pos_R ;
end