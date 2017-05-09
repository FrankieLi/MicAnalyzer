%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Noise Reduce Data
%
%     Takes in a profile, and averages over points to smooth the profile
%
%     Usage:
%     SmoothedProfile = NoiseReduceProfile( Profile, nAveragingPoints)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [SmoothedProfile] = NoiseReduceProfile( Profile, n)

    j=1;%number of smoothing elements
    k=1;%k-th element in smoothing element
    for i=1:length(Profile)
        TemporaryChain(k) = Profile(i);
        if( mod(i,n) == 0 || i==length(Profile) )
            SmoothedProfile(j) = mean(TemporaryChain);
            j = j + 1;
            k=0;
            clear TemporaryChain;
        end
        k=k+1;    
    end

end