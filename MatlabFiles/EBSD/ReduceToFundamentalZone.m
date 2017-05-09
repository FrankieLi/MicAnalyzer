%%
%%  Reduce the euler angle given into the fundamental zone 
%%  - everything's done in Radians
%%
%%
function lowestOrderEu = ReduceToFundamentalZone(Eu, sym_ops, numOps);


% choose fundamental zone


R = getEuler_rad_neg(Eu);
lowestOrderEu = Eu;
maxTrace= trace(R);
minAngleSum = sum(Eu);
test = zeros(numOps, 4);
for i = 1:numOps
    
    NewR =  sym_ops(:, :, i)' * R ;  %   sym_ops *  R * v

    NewEu = EulerFromR(NewR, -1);

    NewRTrace = trace(NewR);
    test(i, 1) = NewRTrace;
    test(i, 2:4) = NewEu;
    if( abs( maxTrace - NewRTrace )  <  1e-6)
        if( minAngleSum > sum(NewEu) )
            minAngleSum = sum(NewEu);
%           maxTrace = NewRTrace;     
            lowestOrderEu = NewEu;
        end
    elseif(maxTrace < NewRTrace)
        minAngleSum = sum(NewEu);
        maxTrace = NewRTrace;
        lowestOrderEu = NewEu;
    end 
    
end


disp('done');
