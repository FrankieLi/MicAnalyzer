function [pf] = SetPoleFigureData( fValues, h, k, l, sTitle )

    ht = 1;
    kt = 0;
    lt = 0;
    st = 'PF';
    if( nargin >= 2 )
       ht = h;
       kt = k;
       lt = l;
       if( nargin > 4 )
            st = sTitle;
       end   
    end

    pf = PoleFigure;
    cs = symmetry('m-3m');
    ss = symmetry('-1');
    h = Miller(ht,kt,lt,cs);
    pf = set( pf, 'h', h );
    pf = set( pf, 'comment', st );
    pf = set( pf, 'SS', ss );
    pf = set( pf, 'CS', cs );
    s2g = S2Grid( 'equispaced', 'regular',  'points', length( fValues ), 'north' );
    pf = set( pf, 'r', s2g );
    pf = set( pf, 'data', fValues );
    
end