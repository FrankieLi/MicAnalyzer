function [L1Info, L2Info, L3Info] = GetL1s_Au(Spots_L1_final, Spots_L2_final, Spots_L3_final, Energy, PixPitch_mm, det_size)

maxHKL = 7;
%Energy = 65.4;
%PixPitch_mm = 1.5;

%Get theoretical 2theta values for Sample
[indx_2theta, Only2Thetas] = Theory2Thetas_Au(maxHKL,Energy );

for i=1:size(Spots_L1_final)
    Spots_L1_final(i,14) = Only2Thetas(Spots_L1_final(i,13)); %Assign theory 2theta based on radius number.
end

for i=1:size(Spots_L2_final)
    Spots_L2_final(i,14) = Only2Thetas(Spots_L2_final(i,13));
end

for i=1:size(Spots_L3_final)
    Spots_L3_final(i,14) = Only2Thetas(Spots_L3_final(i,13));
end

%Find centers of rings
[Centers1, x_cent1, y_cent1, Spots_newRadii1] = FindCenters(Spots_L1_final);
[Centers2, x_cent2, y_cent2, Spots_newRadii2] = FindCenters(Spots_L2_final);
[Centers3, x_cent3, y_cent3, Spots_newRadii3] = FindCenters(Spots_L3_final);

figure(101)
plot(Spots_L1_final(:,1), Spots_L1_final(:,2), '.')
axis ij
axis equal
axis([ 0 det_size 0 det_size])
Centers1
L1RingToUse = input('Which L1 rings would you like to use?');

figure(102)
plot(Spots_L2_final(:,1), Spots_L2_final(:,2), '.')
axis ij
axis equal
axis([ 0 det_size 0 det_size])
Centers2
L2RingToUse = input('Which L2 rings would you like to use?');

figure(103)
plot(Spots_L3_final(:,1), Spots_L3_final(:,2), '.')
axis ij
axis equal
axis([ 0 det_size 0 det_size])
Centers3
L3RingToUse = input('Which L3 rings would you like to use?');


%Centers1_withOmit = [Centers1(1:5,:);Centers1(7:10,:)];
%Centers2_withOmit = [Centers2(1:5,:);Centers2(7:10,:)];
%Centers3_withOmit = [Centers3(1:5,:), Centers3(7:10,:)];
Centers1_withOmit = Centers1(L1RingToUse,:);
Centers2_withOmit = Centers2(L2RingToUse,:);
Centers3_withOmit = Centers3(L3RingToUse,:);

Centers1_withOmit
Centers2_withOmit
Centers3_withOmit

x1_cent_weight = sum(Centers1_withOmit(:,1) .* Centers1_withOmit(:,4))/sum(Centers1_withOmit(:,4));
x2_cent_weight = sum(Centers2_withOmit(:,1) .* Centers2_withOmit(:,4))/sum(Centers2_withOmit(:,4));
x3_cent_weight = sum(Centers3_withOmit(:,1) .* Centers3_withOmit(:,4))/sum(Centers3_withOmit(:,4));

y1_cent_weight = sum(Centers1_withOmit(:,2) .* Centers1_withOmit(:,4))/sum(Centers1_withOmit(:,4));
y2_cent_weight = sum(Centers2_withOmit(:,2) .* Centers2_withOmit(:,4))/sum(Centers2_withOmit(:,4));
y3_cent_weight = sum(Centers3_withOmit(:,2) .* Centers3_withOmit(:,4))/sum(Centers3_withOmit(:,4));


newRadius1 = [];
newRadius2 = [];
newRadius3 = [];
tan2th1 = [];
tan2th2 = [];
tan2th3 = [];

%idx1 = find(Spots_L1_final(:,13) < 11);
%idx1_2 = find(Spots_L1_final(:,13) < 6);
%idx1_3 = find(Spots_L1_final(:,13)>6);
%Spots_L1_final2 = [Spots_L1_final(idx1_2,:); Spots_L1_final(intersect(idx1,idx1_3),:)];

%idx2 = find(Spots_L2_final(:,13) <11);
%idx2_2 = find(Spots_L2_final(:,13) < 6);
%idx2_3 = find(Spots_L2_final(:,13)>6);
%Spots_L2_final2 = [Spots_L2_final(idx2_2,:); Spots_L2_final(intersect(idx2,idx2_3),:)];

%idx3 = find(Spots_L3_final(:,13) <11);
%idx3_2 = find(Spots_L3_final(:,13) < 6);
%idx3_3 = find(Spots_L3_final(:,13)>6);
%Spots_L3_final2 = [Spots_L3_final(idx3_2,:); Spots_L3_final(intersect(idx3,idx3_3),:)];

idx1_tmp = [];
idx2_tmp = [];
idx3_tmp = [];
idx1 = [];
idx2=[];
idx3 = [];

for i=1:length(L1RingToUse)
    idx1_tmp = find(Spots_L1_final(:,13) == L1RingToUse(i));
    idx1 = [idx1; idx1_tmp];
end

for i=1:length(L2RingToUse)
    idx2_tmp = find(Spots_L2_final(:,13) == L2RingToUse(i));
    idx2 = [idx2; idx2_tmp];
end
    
for i=1:length(L3RingToUse)
    idx3_tmp = find(Spots_L3_final(:,13) == L3RingToUse(i));
    idx3 = [idx3; idx3_tmp];
end
 

Spots_L1_final2 = Spots_L1_final(idx1,:);
Spots_L2_final2 = Spots_L2_final(idx2,:);
Spots_L3_final2 = Spots_L3_final(idx3,:);

for i=1:size(Spots_L1_final2,1)
    newRadius1(i) = PixPitch_mm*sqrt((Spots_L1_final2(i,1) - y1_cent_weight)^2 + (Spots_L1_final2(i,2) - x1_cent_weight)^2);
end

for i=1:size(Spots_L2_final2,1)
    newRadius2(i) = PixPitch_mm*sqrt((Spots_L2_final2(i,1) - y2_cent_weight)^2 + (Spots_L2_final2(i,2) - x2_cent_weight)^2);
end

for i=1:size(Spots_L3_final2,1)
    newRadius3(i) = PixPitch_mm*sqrt((Spots_L3_final2(i,1) - y3_cent_weight)^2 + (Spots_L3_final2(i,2) - x3_cent_weight)^2);
end

tan2th1 = tan(Spots_L1_final2(:,14)*(pi/180));
tan2th2 = tan(Spots_L2_final2(:,14)*(pi/180));
tan2th3 = tan(Spots_L3_final2(:,14)*(pi/180));


[L1Info, L1_conf] = LinearRegression(tan2th1',newRadius1, 90,90)
[L2Info, L2_conf] = LinearRegression(tan2th2',newRadius2, 90,90)
[L3Info, L3_conf] = LinearRegression(tan2th3',newRadius3, 90,90)

x1_cent_weight
x2_cent_weight
x3_cent_weight

y1_cent_weight
y2_cent_weight
y3_cent_weight


% xfit = 0.05:0.005:0.28;
% for i=1:length(xfit)
%     yfit1(i) = -0.006 + 4.7274*xfit(i);
%     yfit2(i) = -0.0022 + 8.6416*xfit(i);
% end
% 
% 
% figure(1)
% plot(tan2th1, newRadius1, '.r');
% hold on
% plot(tan2th2, newRadius2, '.b');
% hold on
% plot(xfit, yfit1, '-r');
% hold on
% plot(xfit, yfit2, '-b');
% 
% xlabel('tan(2\theta_{ring})')
% ylabel('Radius on Detector (mm)')
% legend('L1 spots', 'L2 spots', 'L1 fit', 'L2 fit')
% title('L1 & L2 determination for z1-z6 Gold (Nov 08)');
% text(0.07, 2.25, '(j_{01},k_{01}) = (646.523,1035.5)');
% text(0.07, 2, '(j_{02},k_{02}) = (652.342,1034.0)');
% text(0.07, 1.75, 'L_{1} = 4.727 \pm 0.003 mm');
% text(0.07, 1.5, 'L_{2} = 8.642 \pm 0.003 mm');