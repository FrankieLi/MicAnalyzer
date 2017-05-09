%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     CutProfile
%
%     Takes in a full profile of the beam, and cuts it down the edge
%
%     Usage:
%     cprofile = CutProfile( profile )
%
%     Might not work with L-shaped sample
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [CProfile, CutRightIndex, CutLeftIndex] = NiCutProfile( Profile )

    dFactor = 0.05;

    dProfile = diff( Profile );
    %assumes the drop off points are to the left and right of the midpoint
    dProfMidPoint = uint32( length(Profile)/2.0 );

    %look for the largest value of dProfile before and after dProfMidPoint
    [LeftMaxD, IndexLeftMax] = max(dProfile(1:dProfMidPoint));
    [RightMaxD, IndexRightMax] = min(dProfile(dProfMidPoint:length(dProfile)));
    IndexRightMax = IndexRightMax + dProfMidPoint;
  
    CutLeftIndex = IndexLeftMax + uint32( 0.10*(IndexRightMax - IndexLeftMax) );
    CutRightIndex = IndexRightMax - uint32( 0.10*(IndexRightMax - IndexLeftMax) );
    
    CProfile = Profile(CutLeftIndex:CutRightIndex);

end
