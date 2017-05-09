function r_final = TestCentering()



r = ceil( 50 * rand(100, 2)) + 1;

all_r_disp = [zeros(100, 1) , ceil( 10 * rand(100, 1)) + 1];

pixel = zeros(4, 1);
r_final = r;

angle = ceil( 2 * pi *rand(1, 100) );

R90 = [0, -1; 1, 0];
for i = 1:100
   
    R = [ cos( angle(i) ), -sin( angle(i) ); sin( angle(i) ), cos( angle(i) ) ];
   
    r_disp = all_r_disp(i, :)';
    
    r_start = R* r(i, :)';
    
    R_origin = [512; 512];
    
    
    r_rot = r_start;

    for j = 1:4
       tmp = r_rot + r_disp + R_origin;
       pixel(j) = tmp(2);
       r_rot = R90 * r_rot
    end
    
 
    
  
    [toCenter, samp_center]= CenterRotationAxis( pixel(1), pixel(2), pixel(3), pixel(4) );
   
    r_final(i, :) = (  r_start + samp_center' )';
end