%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     CutProfile
%
%     Takes in a full profile of the beam, and cuts it down the edge
%
%     Usage:
%     cprofile = CutProfile( profile )
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [CProfile, CutLeftIndex] = CutProfile( Profile )

    dFactor = 0.05;

    dProfile = diff( Profile );
    %assumes the drop off points are to the left and right of the midpoint
    dProfMidPoint = uint32( length(Profile)/2.0 );

    %look for the largest value of dProfile before and after dProfMidPoint
    [LeftMaxD, IndexLeftMax] = max(dProfile(1:dProfMidPoint));
    [RightMaxD, IndexRightMax] = min(dProfile(dProfMidPoint:length(dProfile)));
    IndexRightMax = IndexRightMax + dProfMidPoint;
    
    %search for when the derivative is low, and 
    %index is near the derivative max point
    for i=dProfMidPoint:-1:IndexLeftMax
       if( dProfile(i) < dFactor*LeftMaxD )
           CutLeftIndex = i;
       end
    end
    
    %search for when the derivative is low, and 
    %index is near the derivative min point
    CutRightIndex = dProfMidPoint;
    for i=dProfMidPoint:IndexRightMax
        if( abs(dProfile(i)) < dFactor*abs(RightMaxD) )
            CutRightIndex = i;
        end
    end
    
    CProfile = Profile(CutLeftIndex:CutRightIndex);

end