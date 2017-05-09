%
%  This function plots a point on top of stereographic projection
%
%  Usage : PlotPoint( x, y, z, color_c, symbol_c )
%
%  Example : PlotPoint( 1, 1, 1, 'r', 'x' )
%
function [] = PlotPoint( x, y, z, col_c, sym_c )
    
    hold all
    color_c = 'k';
    symbol_c = 'x';
    if( nargin > 3 )
        color_c = col_c;
        if( nargin > 4 )
           symbol_c = sym_c;
        end
    end
    r = sqrt(2);% at least for mtex
    xn = (r*x)/sqrt(x*x + y*y + z*z);
    yn = (r*y)/sqrt(x*x + y*y + z*z);
    zn = (r*z)/sqrt(x*x + y*y + z*z);
    xp = (r*xn)./(r+zn);
    yp = (r*yn)./(r+zn);
    xp = (1/(1.2528+1))*(xn+1.2528*xp);
    yp = (1/(1.2528+1))*(yn+1.2528*yp);
    plot( xp, yp, [color_c, sym_c] )

end