function indexed = IndexExperiment(AllLines, Spots, L1, pitch_x, pitch_y, maxHKL, theta_thresh, direct_beam_x, direct_beam_y, Ldist, material)

% This function will index the experimental peaks that are found using the
% L1 program

%maxHKL is the maximum Miller Index that is used
%theta_thresh is the sidebars (in degrees) on 2theta since theory and experiment won't
%exactly match.  

%functions called:
   %   Theory2Thetas_v4.m  (as of 10/5/07)
   %   Experimental2Theta.m
   
%Oct. 5, 2007  - update to include material as a function input (=0 if
%gold, =1 if ruby, =2 if silicon)

theory_2theta = [];

if (material < 2)
    theory_2theta = Theory2Thetas_v4(maxHKL, material);  %First figure out the 2thetas that should occur for FCC
    %Output is in the form of [h, k, l, 2theta_theory]
end

if (material == 2)
    theory_2theta(:,4) = textread('Si_2thetas.txt');
end

    exper_2theta = Experimental2Theta(AllLines, Spots, L1, pitch_x, pitch_y, direct_beam_x, direct_beam_y, Ldist);
    %Output is in the form of [omega, 2theta_experiment, eta, Lspot_x, Lspot_y]
%    exper_2theta
    
    sz_exper_2theta = size(exper_2theta, 1);
    order = 1:sz_exper_2theta;
    exper_2theta(:,6) = order'; %put an index on each row so we can go back to the original order of things
    
    
    srt_exper = sortrows(exper_2theta, 2); %Sorts the experimental data via increasing 2theta values, this will make finding the 2theta differences easier
  
    
    sz_theory_2theta = size(theory_2theta,1);
    sz_srt_exper = size(srt_exper,1);
    
    for i = 1:sz_srt_exper
        
        for j = 1:sz_theory_2theta
            
            if ( (srt_exper(i,2) > theory_2theta(j,4) - theta_thresh) && (srt_exper(i,2) < theory_2theta(j,4) + theta_thresh) ) 
                srt_exper(i,7) = theory_2theta(j,1); %h
                srt_exper(i,8) = theory_2theta(j,2); %k
                srt_exper(i,9) = theory_2theta(j,3); %l
                srt_exper(i,10) = theory_2theta(j,4); %2theta_experiment
                
            end
        end
    end
    
    for i=1:sz_srt_exper
    
        srt_exper(i,11) = abs(srt_exper(i,10) - srt_exper(i,2)); %absolute difference between theory and experiment
        %srt_exper(i,11) = abs(srt_exper(i,9) - srt_exper(i,3));
    end
    
    %This is a second sort to put the data in it's original order before we
    %did the first row sort
    
    srt_exper_2 = sortrows(srt_exper, 6);
    
    indexed = [srt_exper_2(:,1), srt_exper_2(:,7), srt_exper_2(:,8), srt_exper_2(:,9), srt_exper_2(:,10), srt_exper_2(:,11), srt_exper_2(:,6)]; 
    