function PlotTheory2Theta(x_cent, y_cent, TwoThetaList_deg, pitch_mm, L)


TwoThetaList_rad = TwoThetaList_deg*(pi/180);
for i=1:length(TwoThetaList_rad)
    Radii_pix(i) =(L*(1/pitch_mm))*tan(TwoThetaList_rad(i));
    X_left(i) = x_cent - Radii_pix(i) ;
    X_right(i) = x_cent + Radii_pix(i);
    Spacer(i) = (X_right(i) - X_left(i))/2000;
end



for i = 1:length(TwoThetaList_rad)
    x_points(:,i) = X_left(i):Spacer(i):X_right(i);
    for j=1:size(x_points,1)
        y_points(j,i) = y_cent - sqrt(Radii_pix(i)^2 - (x_points(j,i) - x_cent)^2);
    end

end

for i=1:length(TwoThetaList_rad)
    hold on
    if (mod(i,2) == 0)
        text(x_points(1,i), y_points(1,i)+5, int2str(i), 'Color', 'g');
         plot(real(x_points(:,i)), real(y_points(:,i)), 'g');
    else
        text(x_points(end,i), y_points(end,i)+5, int2str(i), 'Color', 'r');
         plot(real(x_points(:,i)), real(y_points(:,i)), 'r');
    end
end
axis ij
axis equal