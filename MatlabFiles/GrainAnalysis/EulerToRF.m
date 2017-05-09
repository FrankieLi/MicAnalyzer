function RFVectors = EulerToRF(Eu)

RFVectors = Eu;

EuLength = size(Eu);
EuLength = EuLength(1);
for i = 1:EuLength
    tmpR = getEuler_rad_pos(Eu(i, :));
    RFVectors(i, :)= MatrixToRFVector(tmpR);
end