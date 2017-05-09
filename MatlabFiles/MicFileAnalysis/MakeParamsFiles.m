function MakeParamsFiles(filename, prefix)

if nargin ~= 2
    error('Proper Usage: MakeParamsFiles(filename, prefix)');
end

data = textread(filename);

iteration = data(:,1);

det_space = 2;

figure(1)
plot(iteration, data(:,2), '-rs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
xlabel('Iteration Number');
ylabel('Cost');
fileCost = strcat(prefix,'_parm_Cost.eps');
print('-depsc', fileCost);

figure(2)
%plot(iteration, data(:,3)/1.0135, '-rs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
plot(iteration, data(:,3), '-rs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
xlabel('Iteration Number');
ylabel('True X-ray Energy (keV)');
fileEnergy = strcat(prefix,'_parm_Energy.eps');
print('-depsc' ,fileEnergy);

figure(3)
plot(iteration, data(:,4)*1000, '-rs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
xlabel('Iteration Number');
ylabel('Pixel Pitch (microns)');
filePitch = strcat(prefix, '_parm_Pitch.eps');
print('-depsc',filePitch);

figure(4)
plot(iteration, data(:,10), '-rs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
hold on;
plot(iteration, data(:,11), '-gs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
hold on;
plot(iteration, data(:,12), '-bs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
legend('L1', 'L2', 'L3');
xlabel('Iteration Number');
ylabel('j0 (pixels)');
fileJ0 = strcat(prefix, '_parm_j0.eps');
print('-depsc', fileJ0);

figure(5)
plot(iteration, data(:,13), '-rs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
hold on;
plot(iteration, data(:,14), '-gs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
hold on;
plot(iteration, data(:,15), '-bs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
legend('L1', 'L2', 'L3');
xlabel('Iteration Number');
ylabel('k0 (pixels)');
fileK0 = strcat(prefix, '_parm_k0.eps');
print('-depsc' ,fileK0);

figure(6)
plot(iteration, data(:,16), '-rs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
hold on;
plot(iteration, data(:,17) - det_space, '-gs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
hold on;
plot(iteration, data(:,18) - 2*det_space, '-bs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
legend('L1', 'L2', 'L3');
xlabel('Iteration Number');
ylabel('L (mm)');
fileL = strcat(prefix, '_parm_L1.eps');
print('-depsc',fileL);


figure(7)
plot(iteration, data(:,19), '-rs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
hold on;
plot(iteration, data(:,20), '-gs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
hold on;
plot(iteration, data(:,21), '-bs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
legend('L1', 'L2', 'L3');
xlabel('Iteration Number');
ylabel('Det omega (deg)');
fileOmeg = strcat(prefix, '_parm_omega_det.eps');
print('-depsc', fileOmeg);

figure(8)
plot(iteration, data(:,22), '-rs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
hold on;
plot(iteration, data(:,23), '-gs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
hold on;
plot(iteration, data(:,24), '-bs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
legend('L1', 'L2', 'L3');
xlabel('Iteration Number');
ylabel('Det chi (deg)');
fileChi = strcat(prefix, '_parm_chi_det.eps');
print('-depsc', fileChi);

figure(9)
plot(iteration, data(:,25), '-rs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
hold on;
plot(iteration, data(:,26), '-gs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
hold on;
plot(iteration, data(:,27), '-bs', 'MarkerFaceColor', 'k', 'MarkerSize',2 );
legend('L1', 'L2', 'L3');
xlabel('Iteration Number');
ylabel('Det phi (deg)');
filePhi = strcat(prefix, '_parm_phi_det.eps');
print('-depsc', filePhi);
