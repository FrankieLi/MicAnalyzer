function [SampleInfo, Conf_band] = LinearRegression(X,Y, ConfLevel, ConfBand)

X_bar = mean(X);
Y_bar = mean(Y);

Xi_minus_Xbar = X - X_bar;
Yi_minus_Ybar = Y - Y_bar;

sum(Xi_minus_Xbar .* Xi_minus_Xbar)

beta_1 = sum(Xi_minus_Xbar .* Yi_minus_Ybar)/sum((Xi_minus_Xbar .* Xi_minus_Xbar));
beta_0 = Y_bar - beta_1* X_bar;

yfit = beta_0 + beta_1 * X;
residual = Y - yfit;
N = length(Y);

MSE = sum(residual .* residual) / (N - 2); %also known as s^2

sigma2_beta1 = MSE / (sum ( Xi_minus_Xbar .* Xi_minus_Xbar)); %error on beta1
alpha_cinterval = ((100 - ConfLevel)/100);
c_width_beta1 = tinv(1-(alpha_cinterval/2), N-2)*sqrt(sigma2_beta1); 
conf_interval_b1 = [beta_1 - c_width_beta1, beta_1 + c_width_beta1];

sigma2_beta0 = MSE * ((1/N) + (X_bar^2 / (sum((Xi_minus_Xbar).*(Xi_minus_Xbar)))));
c_width_beta0 = tinv(1-(alpha_cinterval/2), N-2)*sqrt(sigma2_beta0);

conf_interval_b0 = [beta_0 - c_width_beta0, beta_0 + c_width_beta0];

Conf_band.X = X;
Conf_band.Y_fit = beta_0 + beta_1 * X;

alpha_cBand = ((100 - ConfBand)/100);
W = sqrt(2*finv(1-alpha_cBand,2,N-2));

conf_band_width = W*sqrt(MSE)*sqrt(((1/N) + (((X - X_bar) .* (X - X_bar))/sum((Xi_minus_Xbar) .* (Xi_minus_Xbar)))));

Conf_band.Y_top = Conf_band.Y_fit + conf_band_width;
Conf_band.Y_bot = Conf_band.Y_fit - conf_band_width;

SampleInfo.b0 = beta_0;
SampleInfo.b1 = beta_1;
SampleInfo.sigma0 = sqrt(sigma2_beta0);
SampleInfo.sigma1 = sqrt(sigma2_beta1);
SampleInfo.confInt_0 = conf_interval_b0;
SampleInfo.confInt_1 = conf_interval_b1;


