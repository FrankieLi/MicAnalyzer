function g_symm = GetCubicSymOps()


g_symm = zeros(3, 3, 24);

g_symm(1,1,1) = 0;
g_symm(1,2,1) = 1;
g_symm(1,3,1) = 0;

g_symm(2,1,1) = -1;
g_symm(2,2,1) = 0;
g_symm(2,3,1) = 0;

g_symm(3,1,1) = 0;
g_symm(3,2,1) = 0;
g_symm(3,3,1) = 1;

% L_{001}^2
g_symm(1,1,2) = -1;
g_symm(1,2,2) = 0;
g_symm(1,3,2) = 0;

g_symm(2,1,2) = 0;
g_symm(2,2,2) = -1;
g_symm(2,3,2) = 0;

g_symm(3,1,2) = 0;
g_symm(3,2,2) = 0;
g_symm(3,3,2) = 1;

% L_{00-1}^4
g_symm(1,1,3) = 0;
g_symm(1,2,3) = -1;
g_symm(1,3,3) = 0;

g_symm(2,1,3) = 1;
g_symm(2,2,3) = 0;
g_symm(2,3,3) = 0;

g_symm(3,1,3) = 0;
g_symm(3,2,3) = 0;
g_symm(3,3,3) = 1;

% L_{010}^4
g_symm(1,1,4) = 0;
g_symm(1,2,4) = 0;
g_symm(1,3,4) = -1;

g_symm(2,1,4) = 0;
g_symm(2,2,4) = 1;
g_symm(2,3,4) = 0;

g_symm(3,1,4) = 1;
g_symm(3,2,4) = 0;
g_symm(3,3,4) = 0;

% L_{010}^2
g_symm(1,1,5) = -1;
g_symm(1,2,5) = 0;
g_symm(1,3,5) = 0;

g_symm(2,1,5) = 0;
g_symm(2,2,5) = 1;
g_symm(2,3,5) = 0;

g_symm(3,1,5) = 0;
g_symm(3,2,5) = 0;
g_symm(3,3,5) = -1;

% L_{0-10}^4
g_symm(1,1,6) = 0;
g_symm(1,2,6) = 0;
g_symm(1,3,6) = 1;

g_symm(2,1,6) = 0;
g_symm(2,2,6) = 1;
g_symm(2,3,6) = 0;

g_symm(3,1,6) = -1;
g_symm(3,2,6) = 0;
g_symm(3,3,6) = 0;

% L_{100}^4
g_symm(1,1,7) = 1;
g_symm(1,2,7) = 0;
g_symm(1,3,7) = 0;

g_symm(2,1,7) = 0;
g_symm(2,2,7) = 0;
g_symm(2,3,7) = 1;

g_symm(3,1,7) = 0;
g_symm(3,2,7) = -1;
g_symm(3,3,7) = 0;

% L_{100}^2
g_symm(1,1,8) = 1;
g_symm(1,2,8) = 0;
g_symm(1,3,8) = 0;

g_symm(2,1,8) = 0;
g_symm(2,2,8) = -1;
g_symm(2,3,8) = 0;

g_symm(3,1,8) = 0;
g_symm(3,2,8) = 0;
g_symm(3,3,8) = -1;

% L_{-100}^4
g_symm(1,1,9) = 1;
g_symm(1,2,9) = 0;
g_symm(1,3,9) = 0;

g_symm(2,1,9) = 0;
g_symm(2,2,9) = 0;
g_symm(2,3,9) = -1;

g_symm(3,1,9) = 0;
g_symm(3,2,9) = 1;
g_symm(3,3,9) = 0;


% 120 degrees about {111}'s: 8 operations

% L_{111}^3
g_symm(1,1,10) = 0;
g_symm(1,2,10) = 1;
g_symm(1,3,10) = 0;

g_symm(2,1,10) = 0;
g_symm(2,2,10) = 0;
g_symm(2,3,10) = 1;

g_symm(3,1,10) = 1;
g_symm(3,2,10) = 0;
g_symm(3,3,10) = 0;

% L_{-1-1-1}^3
g_symm(1,1,11) = 0;
g_symm(1,2,11) = 0;
g_symm(1,3,11) = 1;

g_symm(2,1,11) = 1;
g_symm(2,2,11) = 0;
g_symm(2,3,11) = 0;

g_symm(3,1,11) = 0;
g_symm(3,2,11) = 1;
g_symm(3,3,11) = 0;

% L_{11-1}^3
g_symm(1,1,12) = 0;
g_symm(1,2,12) = 0;
g_symm(1,3,12) = -1;

g_symm(2,1,12) = 1;
g_symm(2,2,12) = 0;
g_symm(2,3,12) = 0;

g_symm(3,1,12) = 0;
g_symm(3,2,12) = -1;
g_symm(3,3,12) = 0;

% 	L_{-1-11}^3;
g_symm(1,1,13) = 0;
g_symm(1,2,13) = 1;
g_symm(1,3,13) = 0;

g_symm(2,1,13) = 0;
g_symm(2,2,13) = 0;
g_symm(2,3,13) = -1;

g_symm(3,1,13) = -1;
g_symm(3,2,13) = 0;
g_symm(3,3,13) = 0;

% L_{1-11}^3
g_symm(1,1,14) = 0;
g_symm(1,2,14) = 0;
g_symm(1,3,14) = 1;

g_symm(2,1,14) = -1;
g_symm(2,2,14) = 0;
g_symm(2,3,14) = 0;

g_symm(3,1,14) = 0;
g_symm(3,2,14) = -1;
g_symm(3,3,14) = 0;

% L_{-11-1}^3
g_symm(1,1,15) = 0;
g_symm(1,2,15) = -1;
g_symm(1,3,15) = 0;

g_symm(2,1,15) = 0;
g_symm(2,2,15) = 0;
g_symm(2,3,15) = -1;

g_symm(3,1,15) = 1;
g_symm(3,2,15) = 0;
g_symm(3,3,15) = 0;

% L_{-111}^3
g_symm(1,1,16) = 0;
g_symm(1,2,16) = 0;
g_symm(1,3,16) = -1;

g_symm(2,1,16) = -1;
g_symm(2,2,16) = 0;
g_symm(2,3,16) = 0;

g_symm(3,1,16) = 0;
g_symm(3,2,16) = 1;
g_symm(3,3,16) = 0;

% L_{1-1-1}^3
g_symm(1,1,17) = 0;
g_symm(1,2,17) = -1;
g_symm(1,3,17) = 0;

g_symm(2,1,17) = 0;
g_symm(2,2,17) = 0;
g_symm(2,3,17) = 1;

g_symm(3,1,17) = -1;
g_symm(3,2,17) = 0;
g_symm(3,3,17) = 0;


% 180 degrees about {110}'s: 6 operations

% L_{011}^2
g_symm(1,1,18) = -1;
g_symm(1,2,18) = 0;
g_symm(1,3,18) = 0;

g_symm(2,1,18) = 0;
g_symm(2,2,18) = 0;
g_symm(2,3,18) = 1;

g_symm(3,1,18) = 0;
g_symm(3,2,18) = 1;
g_symm(3,3,18) = 0;

% L_{101}^2	
g_symm(1,1,19) = 0;
g_symm(1,2,19) = 0;
g_symm(1,3,19) = 1;

g_symm(2,1,19) = 0;
g_symm(2,2,19) = -1;
g_symm(2,3,19) = 0;

g_symm(3,1,19) = 1;
g_symm(3,2,19) = 0;
g_symm(3,3,19) = 0;

% L_{110}^2	
g_symm(1,1,20) = 0;
g_symm(1,2,20) = 1;
g_symm(1,3,20) = 0;

g_symm(2,1,20) = 1;
g_symm(2,2,20) = 0;
g_symm(2,3,20) = 0;

g_symm(3,1,20) = 0;
g_symm(3,2,20) = 0;
g_symm(3,3,20) = -1;


% L_{01-1}^2	
g_symm(1,1,21) = -1;
g_symm(1,2,21) = 0;
g_symm(1,3,21) = 0;

g_symm(2,1,21) = 0;
g_symm(2,2,21) = 0;
g_symm(2,3,21) = -1;

g_symm(3,1,21) = 0;
g_symm(3,2,21) = -1;
g_symm(3,3,21) = 0;


% L_{10-1}^2	
g_symm(1,1,22) = 0;
g_symm(1,2,22) = 0;
g_symm(1,3,22) = -1;

g_symm(2,1,22) = 0;
g_symm(2,2,22) = -1;
g_symm(2,3,22) = 0;

g_symm(3,1,22) = -1;
g_symm(3,2,22) = 0;
g_symm(3,3,22) = 0;

% L_{-110}^2	
g_symm(1,1,23) = 0;
g_symm(1,2,23) = -1;
g_symm(1,3,23) = 0;

g_symm(2,1,23) = -1;
g_symm(2,2,23) = 0;
g_symm(2,3,23) = 0;

g_symm(3,1,23) = 0;
g_symm(3,2,23) = 0;
g_symm(3,3,23) = -1;

% I: identity

g_symm(1,1,24) = 1;
g_symm(1,2,24) = 0;
g_symm(1,3,24) = 0;

g_symm(2,1,24) = 0;
g_symm(2,2,24) = 1;
g_symm(2,3,24) = 0;

g_symm(3,1,24) = 0;
g_symm(3,2,24) = 0;
g_symm(3,3,24) = 1;
