%just a test of the fit function

x_0 = 0:0.1:100;

nNotFit = 0;

for i=1:200;
%figure
%    modelErf = @(p,x) p(1) + p(2) .* erf(p(3) .* (x  - p(4)) );
    modelPerp = @(p,x) p(1).*exp(-4*log(2)*(((x - p(5)).^2)./(p(7)).^2)) + p(2) + p(3).*(x-p(6)) + p(4)*((x-p(6)).^2);
    random_params = [(-500*rand -500), 10000*rand, 2.0*rand, (-0.005*rand - 0.005), (40.0*rand + 20), 50.0*rand, 10]
    y_0 = modelPerp(random_params, x_0);

    %[parms, init_params] = FitErrorFunction(x_0,y_0);
    %[fittedfunction,goodness,output,fit_params, lsq_params] = FitPerpFunction(x_0,y_0);
    [InitialGuessParameters, FittedParameters, FittedModel, Goodness, Output] = FitPerpFunction(x_0,y_0);

%     for i=1:length(random_params)
%         params_pdiff(i) = (random_params(i) - params_i(i))/random_params(i);
%     end
%     
%     
%     params_pdiff
    
%     figure
%     plot( x_0, y_0, 'rx', x_0, modelPerp(c,x_0), 'g+');
%     pause( 2.5 )
%     close
% % % %     if( output.exitflag > -1 ) %successful fit
% % % % 
% % % %         %       figure
% % % %         %       plot(x_0,y_0, 'r', x_0, modelErf(fit_params, x_0), 'g', x_0, modelErf(lsq_params, x_0), 'b');
% % % %         %       legend( 'original', 'fit', 'lsqcurve');
% % % % 
% % % %     else %not successful
% % % % 
% % % %         nNotFit = nNotFit + 1
% % % % 
% % % %     end


end

nNotFit;