%%
%%
%%  Fit Points to plane
%%  x, y, z are 1 x n vectors
%%  (This algorithm uses the Hesse Normal Form
%%  taken from the Matlab forum)
%%
function [coeff, PerpErr, ZErr] = FitPointsToPlane( ROIs, z, PixelLength )

x = [];
y = [];
for i = 1:size(ROIs, 1)
    x = [ x, mean( ROIs(i, 2, 1:2) ) ];
    y = [ y, mean( ROIs(i, 1, 1:2) ) ];
end
disp('x')
x
disp('y')
y

x = x * PixelLength;
y = y * PixelLength;

A = [ x', y', z', ones( length(x), 1 ) ];
[U, S, V] = svd(A);
ss = diag(S);
i = find( ss == min(ss) );
coeff = V(:, min(i) );
coeff = coeff/norm(coeff(1:3), 2);

X = [min(x): ( max(x) - min(x) )/10 : max(x) ];
Y = [min(y): ( max(y) - min(y) )/10 : max(y) ];
Z = ( coeff(4) - coeff(1) * X + coeff(2) * Y) / coeff(3);
% Ax + By + Cz = D;


myPlaneFun = @(x,y) ( -coeff(4) - (coeff(1) * x + coeff(2) * y ) ) / coeff(3);

p0 = [0, 0, myPlaneFun( 0, 0 )];
p1 = [1, 1, myPlaneFun( 1, 1 )];
p2 = [-1, 1, myPlaneFun( -1, 1 ) ];

PlaneNorm = cross( p1 - p0, p2 - p0);
PlaneNorm = PlaneNorm / norm( PlaneNorm );

xAxis = acos( dot( PlaneNorm, [1, 0, 0] ) ) * 180/pi
yAxis = acos( dot( PlaneNorm, [0, 1, 0] ) ) * 180/pi
zAxis = acos( dot( PlaneNorm, [0, 0, 1] ) ) * 180/pi

PlaneNormXY = [ PlaneNorm(1), 0, PlaneNorm(3)];
TiltAngle = acos( dot( PlaneNormXY / norm( PlaneNormXY ), [0, 0, 1] ) )* 180/pi


nRegions = size( ROIs, 1);
PerpErr = [];
ZErr    = z - myPlaneFun( x, y );
for i = 1:nRegions
    pData = [ x(i), y(i), z(i) ];
    err = abs( dot( pData - [ x(i), y(i), myPlaneFun(x(i), y(i))], PlaneNorm ) );
    PerpErr = [PerpErr; err];
end
%%%
% calculate error
%%%
disp('\n PerpErr ' );
PerpErr
%%%
% Calculate angles across each of the directions
%%%

%
%  1 and 4   horizontal ( second image coordinate, x )
%  2 and 3   horizontal ( second image coordinate, x )
%
%  1 and 2   vertical   ( first image coordinate,  y, positive is down )
%  3 and 4   vertical

HorizontalAngleTop     = atan( ( z(4) - z(1) ) / (x(4) - x(1)) ) * 180 / pi
HorizontalAngleBottom  = atan( ( z(3) - z(2) ) / (x(3) - x(2)) ) * 180 / pi

VerticalAngleLeft = atan( ( z(2) - z(1) ) / (y(2) - y(1)) ) * 180 / pi
VerticalAngleRight   = atan( ( z(3) - z(4) ) / (y(3) - y(4))  ) * 180 / pi



%%
%%  Fit to parabola
%%
% %%
myPlaneFun = @(x,y) ( -coeff(4) - (coeff(1) * x + coeff(2) * y ) ) / coeff(3);
hold on;
%ezmesh( myPlaneFun);

plot3(x, y, z, 'k*');

%modelParabola = @( p, x ) p(1) * x(:, 1).^2 + p(2) * x(:, 2).^2 + p(3) * x(:,1) + p(4) * x(:, 2) + p(5);  
modelParabola = @( p, x ) p(3) * ( ( x(:, 1) - p(1) ).^2 + ( x(:, 2) - p(2) ).^2 ) + p(4);  

%newParam = lsqcurvefit( modelParabola, [2, 2, 1, 0., 0.], [x', y'], z' )
newParam = lsqcurvefit( modelParabola, [-0.01, 2, 2, 0.], [x', y'], z' )
%myParabolaFun= @(x,y) newParam(1) * x.^2 + newParam(2) * y.^2 + newParam(3) * x+ newParam(4) * y + newParam(5);
myParabolaFun= @(x,y)  newParam(3) * ( ( x- newParam(1) ).^2 + ( y - newParam(2) ).^2 ) +  newParam(4);

ezmesh( myParabolaFun, [0, 4, 0, 4] );
hold off;

end