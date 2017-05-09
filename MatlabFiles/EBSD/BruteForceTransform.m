function output = BruteForceTransform(mEBSD);



Eu_Start = [0, 0, 0];
%Eu_Start = [4.6436    0.1221    1.0402];
%Eu_Start = [2.6638    0.1850    4.0777];
Eu_Physical = [151/180*pi, 0, 0];

% 
% nI = 1;
% nJ = 2;
% nK = 2;


nI = 72;
nJ = 1;
nK = 0;

output = cell(2*nJ + 1,  2* nK +1);

dPhi = 5*pi/180;
dTheta = 5*pi/180;
dPsi = 5*pi/180;

prefix = 'BF_AroundFixedAxis';


% i_count = 1;
% for i = -nI:nI
%     j_count = 1;
%     i
%     matFilename = sprintf('%s_%g.mat', prefix, i_count);
%     for j = -nJ:nJ
%         k_count = 1;
%         for k = -nK:nK
%             CurrentEu = Eu_Start + [i * dPhi, j * dTheta, k * dPsi];
%             tmp = TransformEBSD(mEBSD, Eu_Physical, CurrentEu);
%             tmp = ReduceEBSDToFZ(tmp);
% 
%             output{j_count, k_count} = tmp;
%             k_count = k_count + 1;
%         end   
%         j_count = j_count +1;
%     end
%     i_count = i_count + 1;
%     save(matFilename, 'output');
% 
% end
% 
% save 'BruteForceAroundAveTOrig.mat' output;

i_count = 1;
for i = 1:nI
    j_count = 1;
    i
    for j = -nJ:nJ
        CurrentEu = Eu_Start + [i * dPhi, j * dTheta, 0];
        tmp = TransformEBSD(mEBSD, Eu_Physical, CurrentEu);
        tmp = ReduceEBSDToFZ(tmp);

        output{i_count, j_count} = tmp;
        j_count = j_count +1;
    end
    i_count = i_count + 1;

end

save 'BF_aroundZ.mat' output;