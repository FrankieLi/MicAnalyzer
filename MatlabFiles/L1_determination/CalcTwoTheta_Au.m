function Two_theta = CalcTwoTheta_Au( H, K, L, Energy)

%Calculates theoretical 2theta values for FCC at 50 keV given 3 miller
%indicies

% lambda = 0.154*10^(-9); CuKalpha1
% lambda = 0.071*10^(-9);  MoKalpha1
c = 3.0 * 10^(8);
h = 6.626 * 10^(-34);

%50 keV
E = Energy * 10^3 * 1.60 * 10^(-19); 

lambda = (h*c) / E;

%Lattice constants for Ruby
a = 4.08 * 10^(-10);



%inverse_d_sqrd = (4/3) * ((H^2 + H*K + K^2)/a^2) + L^2/c^2;
inverse_d_sqrd = (H*H + K*K + L*L)/ a^2;

one_over_d = sqrt(inverse_d_sqrd);

half_lambda_over_d = (lambda*one_over_d) / 2;

theta = asin(half_lambda_over_d) * (180 / pi);

Two_theta = 2*theta;


