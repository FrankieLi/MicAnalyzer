%%  PlotMicGui
%%  Authors:    Tony Abartola, Frankie Li
%%
%%  Description:  Modification of Tony's original code to incorperate some
%%                new functions
%%
function PlotMicGui( varargin )


plot_mic( varargin{:} );

sw = varargin{2};
snp = varargin{1};
qList = QuatOfRMat( RMatOfBunge( snp(:, 7:9)', 'degrees') );
qList = qList';
notDone = true;
while( notDone )
  [curPointX, curPointY, button]  = ginput(1);
  if( ~isempty( button ) )
    switch( button )
      case{'q'}
        notDone = false;
      case{'z'}
        zoom(1.1);
      case{'Z'}
        zoom(0.9);
      case{'d'}
        MisorientHandle( qList, snp, sw );
      case{'c'}
        varargin{3} = 2;
        cla
        plot_mic( varargin{:});
      case{'R'}
        varargin{3} = 3;
        cla
        plot_mic( varargin{:} );    
        colorbar( 'off' );
    end
  end
end



end


function MisorientHandle( qList, snp, sw )

notDone = true;
  Ind1 = [];
  Ind2 = [];
while( notDone )

  [x, y, button]  = ginput(1);
 
  if( ~isempty( button ) )
    switch( button )
      case{1}
        Ind1 = SelectTriangles( snp, x, y, sw );
      case{3}
        Ind2 = SelectTriangles( snp, x, y, sw );
      case{2}
        qMis = Misorientation( qList( Ind1, :)', qList(Ind2, :)', CubSymmetries );
        disp( ['Misorientation ' , num2str( qMis * 180 / pi ) ] );
      case{'q'}
        notDone = false;
    end
  end
end

end


%%
%%   SelectionTriangles
%%   Return the indicies of triangles that point p(x, y) lies in
function Ind = SelectTriangles( snp, x, y, sw )

r = sqrt( (snp(:, 1) - x).^2 + ( snp(:, 2) - y ) .^2 );
[Y, Ind] = min( r ); 
if( r > 2 * sw / max( snp(:, 5 ) ) )
  Ind = []
end
end

