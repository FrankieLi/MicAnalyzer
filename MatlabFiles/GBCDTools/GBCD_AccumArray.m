%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  GBCD calculation in matlab
%
%  Author : J. Lind, Frankie Li
%
%  GBCD function takes in a file of the form
%   area normal(3) orientation1(4) orientation2(4)
%   - so 12 columns
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%calculates GBCD
function gbcd = GBCD_AccumArray( Areas, Norms, gA, gB )

nBinSize = 9;
%gbcd = zeros( nBinSize, nBinSize, nBinSize, nBinSize, 4*nBinSize );
GBCD_SIZE = [ nBinSize, nBinSize, nBinSize, nBinSize, 4 * nBinSize ];

gbcd = zeros( prod( GBCD_SIZE), 1 );
csym = CubSymmetries();%could be generalized in the future
%loop over patches
for j=1:size( csym, 2 )
  n = Norms';  
  gA_sym = QuatProd( gA', repmat( csym(:,j), 1, size(gA, 1 ) ) );
         
  %loop over gB symmetry operators
  for k=1:size( csym, 2 )
    gB_sym = QuatProd( gB', repmat( csym(:,k),1, size(gB, 1) ) );
    gMisAB = QuatProd( QuatInverse( gB_sym ), gA_sym );
    gMisBA = QuatProd( QuatInverse( gA_sym ), gB_sym );
    EulersAB = EulersOfBunge( BungeOfRMat( RMatOfQuat( gMisAB ), 'degrees' ) );
    EulersBA = EulersOfBunge( BungeOfRMat( RMatOfQuat( gMisBA ), 'degrees' ) );
    nA = ToCrystalFrame( n', RMatOfQuat( gA_sym ) )';
    nB = ToCrystalFrame( n', RMatOfQuat( gB_sym ) )';

    for l=1:2        
        nA = -1.0*nA;
        nB = -1.0*nB;

        fSouth = find( nA(3, :) < 0 );
        nA(:, fSouth ) = nA(:, fSouth ) * -1;

        fSouth = find( nB(3, :) < 0 );
        nB(:, fSouth ) = nB(:, fSouth ) * -1;

        %test mis(A,B)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5       
        findvec = find( (EulersAB(1, :) < 90.0) & (EulersAB(2, :) < 90.0) & (EulersAB(3, :) < 90.0) );
        if( ~isempty(findvec)  )
          
          Phi = (180.0/pi)*atan2( nA(2, findvec), nA(1, findvec) );
          Theta = (180.0/pi)*acos( nA(3, findvec) );
          Phi = Phi + 90.0;%another fudge to make it work, must be something in the atan definition
          
          findvec2 = find( Phi < 0 );
          Phi( findvec2 ) = Phi( findvec2 ) + 360;
          Indicies = RealSpaceToIndex( EulersAB(:, findvec), Phi, Theta, nBinSize );
          c1 = Indicies(:, 1);
          c2 = Indicies(:, 2);
          c3 = Indicies(:, 3);
          c4 = Indicies(:, 4);
          c5 = Indicies(:, 5);

          gbcd = gbcd + Accumulate( c1, c2, c3, c4, c5, Areas(findvec), GBCD_SIZE);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        %test mis(B,A)
        
        findvec = find( (EulersBA(1, :) < 90.0) & (EulersBA(2, :) < 90.0) & (EulersBA(3, :) < 90.0) );
        if( ~isempty( findvec) )
          Phi = (180.0/pi)*atan2( nB(2, findvec), nB(1, findvec) );
          Theta = (180.0/pi)*acos( nB(3, findvec) );
          Phi = Phi + 90.0;%another fudge
          findvec2 = find( Phi < 0 );
          Phi( findvec2 ) = Phi( findvec2 ) + 360;

          Indicies = RealSpaceToIndex( EulersBA(:, findvec), Phi, Theta, nBinSize );
          c1 = Indicies(:, 1);
          c2 = Indicies(:, 2);
          c3 = Indicies(:, 3);
          c4 = Indicies(:, 4);
          c5 = Indicies(:, 5);
          
          gbcd = gbcd + Accumulate( c1, c2, c3, c4, c5, Areas(findvec), GBCD_SIZE);
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        end
   %   end
    end
  end
 
end
gbcd = reshape( gbcd, GBCD_SIZE);
%Write GBCD to file (testing)
%    WriteGBCD( gbcd )

end

%writes to Rollett GBCD format
function WriteGBCD( gbcd )
f_out = fopen( 'GBCD.matlab.out', 'w' );
for i=1:size( gbcd, 1 )
  for j=1:size( gbcd, 2 )
    for k=1:size( gbcd, 3 )
      for l=1:size( gbcd, 4 )
        for m=1:size( gbcd, 5 )
          fprintf( f_out, '%f \n', gbcd(i,j,k,l,m) );
        end
      end
    end
  end
end
end

function q_i = QuatInverse( q )
q(1, :) = -q(1, :);
q_i = q;
end

%taken from Rollett's ppt notes
function e = EulersOfBunge( b )

e = b;

e(1, :) = b(1, :) - 90.0;
e(2, :) = b(2, :);
e(3, :) = 90.0 - b(3, :);

%total fudge, but this is needed to verify with original code
e(3, :) = 360.0 - e(3, :);

%test if e is within [0,0,0]->[360,180,360]
findvec = find( e(1, :) > 360 );
e(1, findvec ) = e(1, findvec) - 360;
findvec = find( e(1, :) < 0 );
e(1, findvec)  = e(1, findvec) + 360;

findvec = find( e(2, :) > 180 );
e(2, findvec ) = e(2, findvec) - 180;
findvec = find( e(2, :) < 0 );
e(2, findvec)  = e(2, findvec) + 180;

findvec = find( e(3, :) > 360 );
e(3, findvec ) = e(3, findvec) - 360;
findvec = find( e(3, :) < 0 );
e(3, findvec)  = e(3, findvec) + 360;

end



function Indicies = RealSpaceToIndex( Eulers, Phi, Theta, nBinSize )

c1 = floor( (Eulers(1, :) / 90.0 ) *nBinSize ) + 1;
c2 = floor( cos( (pi/180.0) *Eulers(2, :) )*nBinSize ) + 1;
c3 = floor( (Eulers(3, :)/ 90.0 ) * nBinSize ) + 1;
c4 = floor( cos( (pi/180.0)*Theta )*nBinSize ) + 1;
c5 = floor( ( Phi / 360.0 ) * nBinSize * 4 ) + 1;
% 
% findvec = find( c1 <= 0| c2 <= 0| c3 <=0| c4 <= 0 | c5 <=0 );
% 
% if( ~isempty(findvec ) )
%   disp('error');
% end

findvec = find( c1 > nBinSize | c2 > nBinSize | c3 > nBinSize | c4 > nBinSize | c5 > nBinSize * 4 );
Indicies = [c1', c2', c3', c4', c5'];

if( ~isempty( findvec ) )
  %something went wrong
  fprintf( '%f %f %f %f %f \n', Indicies( findvec, :)' );
end


end

%%  ToCrystalFrame
%%  Tony's function to move normals to the crystal frame
%%
%%
function processedNormals = ToCrystalFrame(wNormals, crystalRMats)
% wNormals is n x 3
% crystalRMats is 3 x 3 x n
% processedNormals is n x 3
    processedNormals = zeros( size(wNormals,1), 3 );
    Xlab = wNormals(:,1);
    Ylab = wNormals(:,2);
    Zlab = wNormals(:,3);
    Xcrys = squeeze(crystalRMats(1,1,:)).*Xlab + ...
        squeeze(crystalRMats(2,1,:)).*Ylab + ...
        squeeze(crystalRMats(3,1,:)).*Zlab;
    Ycrys = squeeze(crystalRMats(1,2,:)).*Xlab + ...
        squeeze(crystalRMats(2,2,:)).*Ylab + ...
        squeeze(crystalRMats(3,2,:)).*Zlab;
    Zcrys = squeeze(crystalRMats(1,3,:)).*Xlab + ...
        squeeze(crystalRMats(2,3,:)).*Ylab + ...
        squeeze(crystalRMats(3,3,:)).*Zlab;
    processedNormals(:,:) = [Xcrys, Ycrys, Zcrys];
end


function gbcd = Accumulate( c1, c2, c3, c4, c5, Areas, GBCD_SIZE )

gbcd_tmp     = [1:prod(GBCD_SIZE) ]';
gbcd_weights = zeros( prod(GBCD_SIZE), 1 );
gbcd_ind = sub2ind( GBCD_SIZE, c1, c2, c3, c4, c5 );
gbcd_weights( gbcd_ind ) = Areas;
gbcd =  accumarray( gbcd_tmp, gbcd_weights );
end
