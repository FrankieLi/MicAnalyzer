function plot_Bruteforce(nI, nJ, nK, name_str)


for i = 1:nI
    resultName = sprintf('BF_AroundFixedAxis_%g.mat', i);
    Results = load(resultName);
    EBSD_cell = Results.output;
    for j = 1:nJ
        for k = 1:nK
            filename = sprintf('%s_%g_%g_%g.bmp', name_str, i, j, k);
            plot_EBSD(EBSD_cell{j, k}, 3.01, 5, 1, filename);
        end
    end
end