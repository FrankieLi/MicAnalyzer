function TestAverageOrientation(Eu)

grainAveOrient = averageOrientation(Eu);
AveRFVector = EulerToRF(grainAveOrient);

EuSize = size(Eu);

Q_index = 1;
symOps = GetCubicSymOps();
numOps = 24;
grainQuaternion = zeros(numOps * EuSize(1), 4);
NormalLocation = zeros(EuSize(1), 3);



for eIndex = 1:EuSize(1)
    R = getEuler_rad_pos(Eu(eIndex, :));
    NormalLocation(eIndex, :) = (R * [0;0;1])';    
end


R = getEuler_rad_pos(grainAveOrient);
aveNorm = (R * [0;0;1])';



disp('end');


plot3(NormalLocation(:, 1), NormalLocation(:,2), NormalLocation(:,3 ), 'k.', ...
         aveNorm(1), aveNorm(2), aveNorm(3), 'r+', 'markersize', 5); 
     
     axis([-1, 1, -1, 1, -1, 1]);