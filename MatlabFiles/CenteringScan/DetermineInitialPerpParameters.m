%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     DetermineInitialPerpParameters
%
%     Given a profile to be fit to a Perp function, 
%     guesses and returns starting parameters
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [PerpParameters] = DetermineInitialPerpParameters( x, y )

    % f(x) = Ae^(-4ln2 ( (x-x0A)/(sigma))^2 ) + B0 + B1(x- x0B) + B2(x-x0B)^2
    % note A and B2 are assumed to be negative
    % params = [A, B0, B1, B2, X0A, X0B, sigma]
    
    %second derivative of the profile, f''(x)
    d2 = diff( diff( y ) );
    
    %index of maxima, and two minima to the left and right of the maxima
    [maxd2, index_max] = max( d2 );
    [mind2l, index_min1] = min( d2(1:index_max) );
    [mind22, index_min2] = min( d2(index_max:length(d2)) );

    %step size in x
    dx = x(2) - x(1);
    
    
% % %     %parameter determination based on f''(x)
% % %     
% % %     %to determine sigma
% % %     %length between the two minima is about 6 stds
% % %     sigma = (x(index_min1) + x(index_max + index_min2))/6.0;
% % %     
% % %     
% % %     %to determine A
% % %     %evaluting f''(x) at its maxima to get A
% % %     %f''(index_max) =
% % %     %[-4ln(2)]*[1.0/sigma^2]e^([-4ln(2)]*[1.0/sigma^2]*(x-X0A)^2) + 2*B2
% % %     A = (1/25.0)*2.0*(d2(index_max) - 2*B2)*(-1.0)*sigma*sigma*(1.0/(4*log(2)))*(1.0/dx);
% % %     
% % %     %to determine X0A
% % %     %center of the gaussian at the maxima of 2nd derivative
% % %     X0A = x(index_max + 2);

    %to determine B2
    %integral of the gaussian terms from the second derivative = 0, so the
    %offset of the second derivative of this model is f''(x) = 2*B2
    B2 = 0.5*mean( d2 )*(1.0/dx)*(1.0/dx);

    %first derivative of the profile, f'(x)
    d1 = diff(y);

    [maxd1, index_max_d1] = max(d1);
    [mind1, index_min_d1] = min(d1);
    
    %to determine sigma,
    %length between the maxima and minima is about 6 stds
    sigma = x(index_max_d1+1) - x(index_min_d1+1);
    sigma = abs( sigma );
    
    %to determine X0A
    %the mid point between the maxima and the minima
    X0A = 0.5*(x(index_max_d1+1) + x(index_min_d1+1));
    
    %to determine A
    %should be on the order of max - min
    A = min(y) - max(y);
    
    %to determine B0
    %B0 should be somewhere between the maximum of y and minimum of y
    %upper and lower bounds should take care of this
    B0 = max( y );
        
    %to determine X0B
    %f'(0) = Gaussian_bit(=0) + B1*x + 2*B2*(x-X0B)
    %f'(0) = -2*B2*X0B
    X0B = (-1.0/dx)*(d1(1)/(2.0*B2));
    
    %to determine B1
    %f'(x_end) = Gaussian_bit(=0) + B1*x_end + 2*B2*(x_end-X0B)
    B1 = (d1(length(d1))/dx + 2.0*B2*X0B - 2.0*B2*x(length(x)))/x(length(x));
    
    if( B2 > 0)
       B2 = -1.0*B2; 
    end
    
    
    PerpParameters = [A,B0,B1,B2,X0A,X0B,sigma];

end