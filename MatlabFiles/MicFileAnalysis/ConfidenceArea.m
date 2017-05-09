function [AreaMatrix, mic_ConfSort]= ConfidenceArea(filename, ConfRes)

%Confidence area is used to plot the area coverage in a mic file for
%different confidence levels.  At each confidence value (step size defined
%by ConfRes (see below)), the area is = to the area of all triangles
%with confidence GREATER THAN OR EQUAL TO the given confidence value.


%filename is the name of the .mic file that's being fed in
%ConfRes is the stepping resolution (i.e. if ConfRes = 0.01, then we will
%have 100 points in our plot (conf = 0.01,0.02...0.99,1.0)

if nargin ~= 2
    error('Proper Usage: ConfidenceArea(filename, ConfidenceResolution) ConfidenceResolution is a value in (0,1), defining the bin resolution of the area plot');
end


%Read in mic file and determine size of ungridded triangle
mic = textread(filename);
sw = mic(1,1);
N_lines = size(mic,1);

%Sort by triangle generation and determine where the first nonzero
%generation is
%mic_sortedTRIsize = sortrows(mic,5);
%start = min(find(mic_sortedTRIsize(:,5)>0));
%mic_Noblank = mic_sortedTRIsize(start:end,:);

%Try sorting by conf
mic_sortC = sortrows(mic,10);
start = min(find(mic_sortC(:,10)>0));
mic_Noblank = mic_sortC(start:end,:);

%11th column will be area of triangle
mic_Noblank(:,11) = 0;
N_lines_noblank = size(mic_Noblank,1);

for i=1:N_lines_noblank
    mic_Noblank(i,11) = (sqrt(3)/4)*(sw/(2^(mic_Noblank(i,5))))^2;
end

%Sort triangles by confidence
mic_ConfSort = sortrows(mic_Noblank,10);

%Determine extremes in confidences of triangles (min should be a value set
%by fitting criteria of xdmmpi)
min_conf = min(mic_ConfSort(:,10));
max_conf = max(mic_ConfSort(:,10));
min_conf

N_points = 1/ConfRes;

for i=1:N_points    
    conf = ConfRes*i;
    if (conf > min_conf) %min confidence floor so we don't look at the area of unfitted triangles
        if (conf <= max_conf) %if triangle falls in the interval (min_conf, max_conf]
            lastIdx = min(find(mic_ConfSort(:,10)>=conf)); %lowest index of mic file for triangle satisfying above conditions
            areaSum(i) = sum(mic_ConfSort(lastIdx:end,11)); %total area of triangles with confidence that is AT LEAST = conf
            ConfLevel(i) = mic_ConfSort(lastIdx,10); %max_conf 
        end
    end
    
    if (conf <= min_conf) 
        areaSum(i) = sum(mic_ConfSort(:,11)); %if the confidence bin is <= min_conf then all fitted triangles that are contributing to area
        ConfLevel(i) = conf; 
    end
    
    if (conf > max_conf) %if confidence bin is greater than the maximum confidence found, we obviously have an area of zero
        areaSum(i) = 0;
        ConfLevel(i) = conf;
    end
end

        
        
        
AreaMatrix = [ConfLevel', areaSum'];

%Create a mic file with only confidences exceeding 50%
% conf50Idx = min(find(mic_ConfSort(:,10))>0.5);
% 
% fid = fopen('Greater_conf_50.mic','w');
% fprintf(fid, '%f\n', sw);
% for m=conf50Idx:size(mic_ConfSort,1)    
%     fprintf(fid, '%7f\t  %7f\t %7f\t %2i\t %2i\t %2i\t %7.6f\t %07.6f\t  %07.6f\t %07.6f\n', mic_ConfSort(m,1),mic_ConfSort(m,2),mic_ConfSort(m,3), mic_ConfSort(m,4), mic_ConfSort(m,5), mic_ConfSort(m,6), mic_ConfSort(m,7),mic_ConfSort(m,8), mic_ConfSort(m,9), mic_ConfSort(m,10));
% end
% fclose(fid);

    
    
    