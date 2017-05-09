
%%
%%   CSLFamilyGenerator
%%   Implementation of "The Generating Function for Coincidence Site
%%   Lattices in a Cubic System", *Hans Grimmer*, Acta Cryst. ( 1984), A40,
%%   108-112
%%
%%   Authors:  Frankie Li, Chris Hefferan
%%   
%%
%%
%%
%%
function SigmaTable = CSLFamilyGenerator( mMax )
SigmaTable = [];
for m = 1:mMax
  for h = 0:m
    for k = 0:h
      for l = 0:k
        
        if( Coprime( m, h, k, l ) )
          Sigma = m^2 + h^2 +k^2 +l^2;
          if( ~iseven ( Sigma ) )
            SigmaTable = [SigmaTable;  [ Sigma, m, h, k, l ] ];
          end
        end
      end
    end
  end
end

end


function bCoprime = Coprime( w, h, k, l )

v = [w, h, k, l];
g_all = [];
for i = 1:4
  for j = i:4
    g_all = [g_all; gcd( v(i), v(j) )];
  end
end

bCoprime = ( min( g_all ) <= 1 );  % this is to cover gcd(0, 0)
end


function theta = GetAngle( m,  h, k, l )


theta = 2 * atan( sqrt( h^2 + k^2 + l^2 )/m );

end
