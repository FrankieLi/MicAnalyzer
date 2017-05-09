%
%  Adds lines in stereographic projection of intersection of plane
%    with sphere
%
%  Usage : AddCircles( h, k, l, color_c )
%
%  Example : AddLines( 1, 1, 0, 'b' )
%
function [] = AddCircles( h, k, l, col_c )
    
    color_c = 'k';
    if( nargin > 3 )
        color_c = col_c;
    end
 
    hkl = [h,k,l];
    r=sqrt(2);%at least for mtex
    nZeros = find( hkl == 0 );
    nNons = find( hkl ~= 0 );    
    hold all
    if( length(nZeros) == 2 )
        %{100}
        x=[-r,r];
        y=[0,0];
        plot( x, y, color_c )
        plot( y, x, color_c )
    elseif( length( nZeros ) == 1 )
        h = abs(hkl( nNons(1) ));
        k = abs(hkl( nNons(2) ));
        if( h < k )
           t_val = h;
           h = k;
           k = t_val;
        end
        %z-independent, straight lines on plot
        x_max = (h*r)/sqrt(h*h + k*k);
        x=[-x_max,x_max];
        y=(k/h)*x;
        plot( x, y, color_c )
        plot( x, -y, color_c )
        plot( y, x, color_c )
        plot( -y, x, color_c )
        %z-varies
        dx = (2*r)/1000;
        x=[-r:dx:r];
        
        d=(1+(h*h)/(k*k));
        y=sqrt(1/d)*sqrt(r*r-x.*x);        
        z=(h/k)*y;
        xp = (r*x)./(r+z);
        yp = (r*y)./(r+z);
        xp = (1/(1.2528+1))*(x+1.2528*xp);
        yp = (1/(1.2528+1))*(y+1.2528*yp);
        plot( xp, yp, color_c )
        plot( xp, -yp, color_c )
        plot( yp, xp, color_c )
        plot( -yp, xp, color_c )
        
        d=(1+(k*k)/(h*h));
        y=sqrt(1/d)*sqrt(r*r-x.*x);
        z=(k/h)*y;
        xp = (r*x)./(r+z);
        yp = (r*y)./(r+z);
        xp = (1/(1.2528+1))*(x+1.2528*xp);
        yp = (1/(1.2528+1))*(y+1.2528*yp);
        plot( xp, yp, color_c )
        plot( xp, -yp, color_c )
        plot( yp, xp, color_c )
        plot( -yp, xp, color_c )
        
    elseif( length( nZeros ) == 0 )
        
        for e=1:3
            h = hkl(e);
            for f=1:3
                if( f ~= e )
                    k = hkl(f);
                    for g=1:3
                        if( g ~= f && g~= e )
                            l = hkl(g);
                            PlotSinglePlane( h, k, l, color_c );
                        end
                    end
                end
            end
        end

    else
        %something went wrong, all indices are zero
    end
        
end