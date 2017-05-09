%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% GuessInitialCenter.m
%
% Function asks user to select >=3 points that lie on the same arc on the omega
% integrated detector image.  The program then uses these points to
% estimate a circle center for that detector distance.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [j_center, k_center] =  GuessInitialCenter(fig)

happy = 0;
figure(fig);

while (happy == 0)
    circPoints = [];
    cursor_obj = [];

    cursor_obj = datacursormode(fig);
    set(cursor_obj,'DisplayStyle','datatip', 'SnapToDataVertex','on','Enable','on')

    input('Please select a set of 3 (or more) points that are on one circle using the data cursor. \n First select data point with + on figure, then right click on data box and select "Create New Datatip". \n Press <Enter> when completed.');

    circPoints = getCursorInfo(cursor_obj);

    while(size(circPoints,2) < 3)
        input('You must have AT LEAST 3 datapoints selected.  Press <enter> when this is true!');
        circPoints = getCursorInfo(cursor_obj);
    end

    disp(strcat('You have selected ', int2str(size(circPoints,2)), ' points.\n'));
    for i=1:size(circPoints,2)
        disp(strcat('The points are x: ', num2str(circPoints(i).Position(1)), ', y:', num2str(circPoints(i).Position(2))));
    end
    happy = input(strcat('Do you wish to find the center using these',' ', int2str(size(circPoints,2)), ' points? 1 if yes, 0 if no'));
end

x =[];
y =[];

for i=1:size(circPoints,2)
    x(i) = circPoints(i).Position(1);
    y(i) = circPoints(i).Position(2);
end

u = [];
v = [];


N_pts = length(x);

X_bar = mean(x);
Y_bar = mean(y);

u = x - X_bar;
v = y - Y_bar;

Suu = sum(u.*u);
Suv = sum(u.*v);
Suuu = sum(u.*u.*u);
Suvv = sum(u.*v.*v);
Svv = sum(v.*v);
Svvv = sum(v.*v.*v);
Svuu = sum(v.*u.*u);

v_c = (0.5*(Svvv + Svuu - ((Suuu*Suv)/Suu) - ((Suvv*Suv)/Suu)))/(Svv - ((Suv*Suv)/Suu));

u_c = (0.5*(Suuu + Suvv) - v_c*Suv)/Suu;

R = sqrt(u_c^2 + v_c^2 + ((Suu + Svv)/N_pts));

x_c = u_c + X_bar;
y_c = v_c + Y_bar;

j_center = x_c;
k_center = y_c;

