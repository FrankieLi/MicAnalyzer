function PlotPerpFunction(x,y,parameters)
%plots original data with fitted data

    figure
    modelPerp = @(p,x) p(1).*exp(-4*log(2)*(((x - p(5)).^2)./(p(7)).^2)) + p(2) + p(3).*(x-p(6)) + p(4)*((x-p(6)).^2);
    plot(x,y,'*',x,modelPerp(parameters,x));

end