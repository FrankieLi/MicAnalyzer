%
%  This function plots a stereographic projection given
%  a list of normals with associated weights (areas)
%
%  Usage : PlotNormals( vNormals, vAreas, nBins )
%
%  Example : PlotNormals( [1,1,1], 10, 45 )
%
%  size( vNormals ) = [N,3]
%  size( vAreas ) = N
%  nBins sets the angle between bins (90/nBins)
%
function [pf] = PlotNormals( vNormals, vAreas, nBins, bAutoSize )

    if( nargin < 4 )
       bAutoSize = 1;
    end

    fRes = ceil( 90.0/nBins );
    nBins = round( 90.0/fRes );
    
    %notes on bin edges and centers
    %BinCenterPhi(i) = fRes*(i-1)
    %BinPhiEdge1(i) = fRes*(i-2);%edges shown in figure
    %BinPhiEdge2(i) = fRes*(i); %edges shown in figure
    %RealPhiEdge1(i) = fRes*(i-1.5)
    %RealPhiEdge2(i) = fRes*(i-0.5)
    
    %test if nBins is even, looks weird
    if( bAutoSize == 1 )
        if( (nBins ~= 18) || (nBins ~= 6)  )
            nBins = 18;
            fRes = 5;
            fprintf( '\n Warning : Resizing bins to 6 degrees \n \n' );
        end
    end
    
    PF = zeros( nBins, 4*nBins );
    
    for i=1:length(vAreas)

        n_i = vNormals(i,:);
        %normalize
        n_i = n_i/sqrt(n_i*n_i');
        phi = atan2( n_i(2), n_i(1) )*(180/pi);
        theta = acos( n_i(3) )*(180/pi);
        

        phi = phi - 90.0 + 1.5*fRes;
        if( phi > 360.0 + 1.0*fRes )
            phi = phi - 360.0;
        end

        if( phi <= 0 )
             phi = phi + 360;
         end

         theta = theta + 1.5*fRes;
         if( theta > 90.0 + 1.0*fRes )
            theta = (nBins+0.5)*fRes; 
         end

         n1 = floor( theta/fRes);
         n2 = floor( phi/fRes);

         PF(n1,n2) = PF(n1,n2) + vAreas(i);
        
    end

    %construct pole figure object
    PF_vector = reshape( transpose(PF), [size(PF,1)*size(PF,2), 1] );
    pf = SetPoleFigureData( PF_vector, 1, 0, 0, 'PF' );
    plot( pf, 'equal', 'eangle', 'smooth' )

    % old way of doing this, writing to file then reading it back in
    %     %write PF to file
    %     PF_file = fopen( 'test.pf', 'w' );
    %     fprintf( PF_file, '*Dump of file: ptmp_072.@DA (27-Oct-2010 14:37) \n *Sample: gt2 \n *Corrected, rescaled data * Phi range 0.00 - 360.0 Step %g \n *Pole figure: 100 \n', 90/nBins );
    %     for i=1:size( PF, 1 )
    %         fprintf( PF_file, '*Khi = %g \n', (i-1.0)*fRes );
    %         for j=1:size( PF, 2 )
    %             fprintf( PF_file, '%g ', PF(i,j) );
    %             if( mod(j,nBins) == 0 )
    %                 fprintf( PF_file, '\n' );
    %             end
    %         end
    %         fprintf( PF_file, '\n' );
    %     end
    %plot PF
    %pf = PlotPTXPF('test.pf','cubic','triclinic', {'tight', 'eangle', 'smooth', 'antipodal'} );
    

end
