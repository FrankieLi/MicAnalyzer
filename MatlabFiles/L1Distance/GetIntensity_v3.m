function WithIntensity = GetIntensity_v3(X_valid, Y_valid_unrev, intensity_image_name)

%v3 setup September 27,2007
%Have adjusted what the pixels of the read in intensity image are (shifted
%by 1).

intens_img = load(intensity_image_name);
size_Xvalid = size(X_valid,2);
size_intens_img = size(intens_img, 1);
Intensity = [];

for i = 1:size_Xvalid
    x = X_valid(i);
    y = Y_valid_unrev(i);
    for j = 1:size_intens_img
        if ( (intens_img(j,1) == x-1) && (intens_img(j,2) == y-1)) %Inclusion of -1 to j due to X_valid, Y_valid_unrev, being the shifted in Spot_Finder_v3
             Intensity(i) = intens_img(j,3);
        end
    end     
end        

WithIntensity = Intensity;
