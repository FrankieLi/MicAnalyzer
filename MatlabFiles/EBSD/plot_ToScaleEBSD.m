function plot_ToScaleEBSD(snpOri)



%PosEu = [0, 0, 0] * pi/180;
%gEu = [0, 0, 0] * pi/180;


for i = 1:5
    
    PosEu = [0, 0, 0] * pi/180;
    gEu = [(i*10+60), 0, 0] * pi/180;

    snp = snpOri;
%     snp(:, 4:5) = snp(:, 4:5) /1000;
%     snp(:, 4) =  snp(:, 4) - 0.3;
%     snp(:, 5) = snp(:, 5) - 0.3;

    snpTest = TransformEBSD(snp, PosEu, gEu);


    sidewidth = 3.01/1000;

    axisRange = [-0.6, 0.6, -0.6, 0.6];
  
    plot_EBSD(snpTest, sidewidth, 1);
    axis(axisRange);

end
