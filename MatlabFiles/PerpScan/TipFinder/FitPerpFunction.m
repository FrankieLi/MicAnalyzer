%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    FitPerpFunction
%
%    Given a profile of the form of perp function,
%    fits the data
%
%    Usage:
%    [InitialGuessParameters, FittedParameters, FittedModel, Goodness, Output] = FitPerpFunction(x,profile)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [InitialGuessParameters, FittedParameters, FittedModel, Goodness, Output] = FitPerpFunction(x,y)

    % f(x) = Ae^(-4ln2 ( (x-x0A)/(sigma))^2 ) + B0 + B1(x- x0B) + B2(x-x0B)^2
    % note A and B2 are negative
    % params = [A, B0, B1, B2, X0A, X0B, sigma];

    modelPerp = @(p,x) p(1).*exp(-4*log(2)*(((x - p(5)).^2)./(p(7)).^2)) + p(2) + p(3).*(x-p(6)) + p(4)*((x-p(6)).^2);

    InitialGuessParameters = DetermineInitialPerpParameters(x,y);

    GP = InitialGuessParameters;

    %Upper and Lower bounds for the fit
    %UpperBounds = [0.25*GP(1), 10*GP(2), 20, 0, 10*GP(5), x(length(x)), 2.0*GP(7)];
    %LowerBounds = [10.0*GP(1), 0, -20, GP(4)-5, 0, 0, 0.5*GP(7)];
    %do not trust these!
    if( abs(GP(3)) < 0.01 )
        if( sign(GP(3)) ~= 1)
           s = -1.0; 
        else
           s = 1.0; 
        end
        GP(3) = GP(3) + 0.1*s;
    end
    
    if( abs(GP(4)) < 0.01 )
        GP(3) = 0.01;
    end
    
    dX0A = 0.1*length(x);
    
    UpperBounds = [0.2*GP(1), 5*GP(2), 10*GP(3), 0, GP(5)+dX0A, x(length(x)), 2.0*GP(7)];
    LowerBounds = [5.0*GP(1), 0, 0.1*GP(3), 10*GP(4), GP(5)-dX0A, 0, 0.5*GP(7)];

    for i=1:7
       if( UpperBounds(i) < LowerBounds(i) )
          LBPV = LowerBounds(i);
          LowerBounds(i) = UpperBounds(i);
          UpperBounds(i) = LBPV;
          fprintf( 'Switching bounds' );
       end
        
    end
    
    %Type of function to fit the data to
    FitTypePerp = fittype('A.*exp(-4*log(2)*(((x - X0A).^2)./(sigma).^2)) + B0 + B1.*(x-X0B) + B2*((x-X0B).^2)', 'coeff', {'A','B0','B1','B2','X0A','X0B','sigma'});
    [FittedModel,Goodness,Output] = fit( transpose(x), transpose(y), FitTypePerp, 'MaxFunEvals', 10000, 'StartPoint', InitialGuessParameters, 'DiffMaxChange', 10, 'Lower', LowerBounds, 'Upper', UpperBounds);   
    %[FittedModel,Goodness,Output] = fit( transpose(x), transpose(y), FitTypePerp, 'MaxFunEvals', 100000, 'StartPoint', InitialGuessParameters, 'DiffMaxChange', 10);   
    FittedParameters = [FittedModel.A, FittedModel.B0, FittedModel.B1, FittedModel.B2, FittedModel.X0A, FittedModel.X0B, FittedModel.sigma];
    
%     figure
%     hold on
%     plot(x,y)
%     plot(x, modelPerp( GP, x) )
%     hold off
    
    %checking everything looks ok
    %figure
    %plot( x, y, '+b', x, modelPerp(InitialGuessParameters, x), 'go', x, modelPerp(FittedParameters, x), 'xr', 1:length(diff(diff(y))), 10*diff(diff(y)), '-c');
    %legend( 'orignal', 'guess', 'fit', 'f''''(x)');
    %legend('original', 'guess', 'fitted');
    %Output.exitflag
    %pause(20.0);
    %close
    
end