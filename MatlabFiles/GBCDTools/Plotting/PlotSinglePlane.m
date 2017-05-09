%
%  this function to be used by AddCircles.m
%
function [] = PlotSinglePlane( h, k, l, col_c )

    color_c = 'k';
    if( nargin > 3 )
       color_c = col_c; 
    end

    r = sqrt(2); %at least for mtex
    x_t=[-r:0.0005:r];
    j=1;
    x(1) = 0;
    y1(1) = 0;
    y2(1) = 0;
    %find intersection of plane with sphere
    for i=1:length(x_t)
        c_i = [ (1 + (k*k)/(l*l)), (2*h*k*x_t(i))/(l*l), ( (1 + (h*h)/(l*l))*x_t(i)*x_t(i) - r*r ) ];
        y = roots( c_i );
        if( isreal( y(1) ) )
            x(j) = x_t(i);
            if( y(1) > y(2) )
                y1(j)=y(1);
                y2(j)=y(2);
            else
                y1(j)=y(2);
                y2(j)=y(1);
            end
            j = j + 1;
        end
    end
    
    %project onto plane
    z=abs( (1/l)*(h*x+k*y1) );
    xp = (r*x)./(r+z);
    y1p = (r*y1)./(r+z);
    y2p = (r*y2)./(r+z);
    xp = (1/(1.2528+1))*(x+1.2528*xp);
    y1p = (1/(1.2528+1))*(y1+1.2528*y1p);
    y2p = (1/(1.2528+1))*(y2+1.2528*y2p);

    %plot
    % (x,y)
    plot( xp, y1p, color_c )
    plot( -xp, -y1p, color_c )
    %connectors
    plot( [xp(1), -xp(length(xp))], [y1p(1), -y1p(length(y1p))], color_c )
    plot( [xp(length(xp)), -xp(1)], [y1p(length(y1p)), -y1p(1)], color_c )
    
    % (x,-y)
    plot( xp, -y1p, color_c )
    plot( -xp, y1p, color_c )
    %connectors
    plot( [xp(1), -xp(length(xp))], [-y1p(1), y1p(length(y1p))], color_c )
    plot( [xp(length(xp)), -xp(1)], [-y1p(length(y1p)), y1p(1)], color_c )

end

