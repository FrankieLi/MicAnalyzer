function output = ListSymEq(Eu)


EuSize = size(Eu);

symOps = GetCubicSymOps();
numOps = 24;

Q = zeros( EuSize(1) * 24 , 4 ); 
Q_index = 1;
for eIndex = 1:EuSize(1)
    R = getEuler_rad_pos(Eu(eIndex, :));
    
    for i = 1:numOps
       NewR = R* symOps(:, :, i)  ;  
       Q(Q_index, :) = EulerToQuaternion(NewR);
       Q_index = Q_index + 1;
    end
end

output = Q;