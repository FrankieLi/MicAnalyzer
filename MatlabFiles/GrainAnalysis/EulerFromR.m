%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%
%  EulerFromR - adopted from Prof Suter's Eu_from_R
%  Action:  Get Euler angles given the euler rotational matrix.
%
%
function EulerAngles = EulerFromR(R,pm)


%pm = pm * -1;  % the row and col major-ness is switched from
               % fortran to matlab.

cos_thresh = 0.999999; 
Eu = zeros(1, 3);
if(pm == -1)

 % Find Eulers for active rotation (diffractometer-like angles)

 if( R(3,3) > cos_thresh )	%	! is chi approx 0.?
    Eu(1) = 0.d00;				%! set omega and chi to zero
    Eu(2) = 0.d00;
    Eu(3) = atan2(R(1,2),R(1,1));

 elseif ( R(3,3) < -cos_thresh );  % is chi approx pi?
    Eu(1) = 0.d00;
    Eu(2) = pi;
    Eu(3) = atan2(R(2,1),R(1,1));

 else							% chi is not zero or pi
    Eu(1) = atan2(R(3,1),-R(3,2));
%    Eu(1) = atan2(R(3,1),R(3,2));
    Eu(2) = atan2(sqrt(R(1,3)*R(1,3) + R(2,3)*R(2,3)),R(3,3));
%    Eu(2) = acos(R(3, 3));
    Eu(3) = atan2(R(1,3),R(2,3));
%    Eu(3) = -atan2(R(1,3),R(2,3));
 end

 for i = 1:3			  % atan2 returns in [-pi:pi], we want [0:2pi]
    if( Eu(i) < 0.d00)
        Eu(i) = Eu(i) + 2*pi;
    end
 end
 
else
 % Find Eulers from coordinate transformation matrix 

 if( R(3,3) > cos_thresh)		% is chi approx 0.?
    Eu(1) = 0.d00;					% set omega and chi to zero
    Eu(2) = 0.d00;
    Eu(3) = atan2(R(2,1),R(1,1));

 elseif(R(3,3) < -cos_thresh)	% is chi approx pi?
    Eu(1) = 0.d00;
    Eu(2) = pi;
    Eu(3) = atan2(R(1,2),R(1,1));
 else                               % ! chi is not zero or pi
    Eu(1) = atan2(R(1,3),-R(2,3));
%    Eu(1) = atan2(R(1,3),R(2,3));
    Eu(2) = atan2(sqrt(R(3,1)*R(3,1) + R(3,2)*R(3,2)),R(3,3));
%    Eu(2) = acos(R(3,3));
    Eu(3) = atan2(R(3,1),R(3,2));
%    Eu(3) = -atan2(R(3,1),R(3,2));
 end

 for i = 1:3			 % ! atan2 returns in [-pi:pi], want [0:2pi]
    if(Eu(i) < 0.d00)
        Eu(i) = Eu(i) + 2*pi;
    end
 end
end

% ! make sure these Eulers are in standard range
%EulerAngles = std_EulerRange(Eu);	
EulerAngles = Eu;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  adopted from Prof. Suter's std_Euler
%  Enforces standard euler angle range
%
%
%! Puts a set of Euler angles into standard range:
%!  0 < omega < 2*pi
%!  0 < chi   < pi
%!  0 < phi   < 2*pi
%! Assumes all are within -2*pi and + 2*pi
function Eu = std_EulerRange(Eu)

tolerance = 5.e-6; %   ! 5microradians = 0.0003deg


%! keep Eulers in their standard ranges:

if(Eu(2) > pi)
    Eu(2) = Eu(2) - 2*pi; %	 ! chi in interval +/- pi
end

if(Eu(2) < 0)
    Eu(1) =  Eu(1) + pi;
    Eu(2) = -Eu(2);
    Eu(3) =  Eu(3) + pi;
end

if(Eu(1) < -tolerance)
    Eu(1) = Eu(1) + 2*pi;
end
if(Eu(3) < -tolerance)
    Eu(3) = Eu(3) + 2*pi;
end

if(Eu(1) > 2*pi-tolerance)
    Eu(1) = Eu(1) - 2*pi;
end
if(Eu(3) >= 2*pi-tolerance)
    Eu(3) = Eu(3) - 2*pi;
end
%! break degeneracy of omega and phi near chi = 0 or pi (chi >= 0 at this point)
if(Eu(2) < tolerance)
   Eu(3) = Eu(3) + Eu(1);
   Eu(1) = 0.;
end
if(abs(Eu(2)-pi)< tolerance)
   Eu(3) = Eu(3) - Eu(1);
   Eu(1) = 0.;
end

if(Eu(3) < 0.)
    Eu(3) = Eu(3) + 2*pi;
end
