function v = MatrixToRFVector(R)



v = zeros(1, 3);

R_trace = trace(R);
v(1) =  ( R(2, 3) - R(3, 2) ) / (1 + R_trace);
v(2) =  ( R(3, 1) - R(1, 3) ) / (1 + R_trace);
v(3) =  ( R(1, 2) - R(2, 1) ) / (1 + R_trace);