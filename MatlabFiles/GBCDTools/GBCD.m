%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  GBCD calculation in matlab
%
%  Author : J. Lind
%
%  GBCD function takes in a file of the form
%   area normal(3) orientation1(4) orientation2(4)
%   - so 12 columns
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% loads in file
% function gbcd = GBCD( sFileName )
% 
%     %takes data from original format and separates into areas, normals,
%     %orientations pairs
%     gbcd = load( sFileName );
%     size( gbcd )
%     Areas = gbcd(:,1);
%     Norms = gbcd(:,2:4);
%     gA = gbcd(:,5:8);
%     gB = gbcd(:,9:12);
%    
%     %sends this to actual gbcd calculation
%     CalcGBCD( Areas, Norms, gA, gB )
%     
% end


function gbcd = GBCD( Areas, Normals, gA, gB )
    gbcd = CalcGBCD( Areas, Normals, gA, gB );
end
%calculates GBCD
function gbcd = CalcGBCD( Areas, Norms, gA, gB )

    nBinSize = 9;
    gbcd = zeros( nBinSize, nBinSize, nBinSize, nBinSize, 4*nBinSize );
    csym = CubSymmetries();%could be generalized in the future
    %loop over patches
    for i=1:length( Areas )
        %loop over gA symmetry operators
        n = Norms(i,:);
        for j=1:size( csym, 2 )
            gA_sym = QuatProd( gA(i,:)', csym(:,j) );
            %loop over gB symmetry operators
            for k=1:size( csym, 2 )
                gB_sym = QuatProd( gB(i,:)', csym(:,k) );
                gMisAB = QuatProd( QuatInverse( gB_sym ), gA_sym );
                gMisBA = QuatProd( QuatInverse( gA_sym ), gB_sym );
                EulersAB = EulersOfBunge( BungeOfRMat( RMatOfQuat( gMisAB ), 'degrees' ) );
                EulersBA = EulersOfBunge( BungeOfRMat( RMatOfQuat( gMisBA ), 'degrees' ) );
                for l=1:2
                    n = -1.0*n;
                    nA = ((RMatOfQuat( gA_sym ))') * (n');
                    nB = ((RMatOfQuat( gB_sym ))') * (n');
                    if( nA(3) < 0 )
                        nA = -1.0*nA;
                    end
                    if( nB(3) < 0 )
                        nB = -1.0*nB;
                    end
                    %test mis(A,B)
                    if( (EulersAB(1) < 90.0) && (EulersAB(2) < 90.0) && (EulersAB(3) < 90.0) )
                        Phi = (180.0/pi)*atan2( nA(2), nA(1) );
                        Theta = (180.0/pi)*acos( nA(3) );
                        Phi = Phi + 90.0;%another fudge to make it work, must be something in the atan definition
                        if( Phi < 0.0 )
                            Phi = Phi + 360.0;
                        end
                        c1 = floor((EulersAB(1)/90.0)*nBinSize) + 1;
                        c2 = floor( cos( (pi/180.0)*EulersAB(2) )*nBinSize ) + 1;
                        c3 = floor((EulersAB(3)/90.0)*nBinSize) + 1;
                        c4 = floor(cos( (pi/180.0)*Theta )*nBinSize ) + 1;
                        c5 = floor((Phi/360.0)*nBinSize*4) + 1;
                        if( (c1 > nBinSize) || (c2 > nBinSize) || (c3 > nBinSize) || (c4 > nBinSize) || (c5 > nBinSize*4) )
                            %something went wrong
                            fprintf( '%f %f %f %f %f \n', c1, c2, c3, c4, c5 );
                        else
                            gbcd( c1, c2, c3, c4, c5 ) = gbcd( c1, c2, c3, c4, c5 ) + Areas(i);
                        end
                    end
                    %test mis(B,A)
                    if( (EulersBA(1) < 90.0) && (EulersBA(2) < 90.0) && (EulersBA(3) < 90.0) )
                        Phi = (180.0/pi)*atan2( nB(2), nB(1) );
                        Theta = (180.0/pi)*acos( nB(3) );
                        Phi = Phi + 90.0;%another fudge
                        if( Phi < 0.0 )
                            Phi = Phi + 360.0;
                        end
                        c1 = floor((EulersBA(1)/90.0)*nBinSize) + 1;
                        c2 = floor( cos( (pi/180.0)*EulersBA(2) )*nBinSize ) + 1;
                        c3 = floor((EulersBA(3)/90.0)*nBinSize) + 1;
                        c4 = floor(cos( (pi/180.0)*Theta )*nBinSize ) + 1;
                        c5 = floor((Phi/360.0)*nBinSize*4) + 1;
                        if( (c1 > nBinSize) || (c2 > nBinSize) || (c3 > nBinSize) || (c4 > nBinSize) || (c5 > nBinSize*4) )
                            %something went wrong
                            fprintf( '%f %f %f %f %f \n', c1, c2, c3, c4, c5 );
                        else
                            gbcd( c1, c2, c3, c4, c5 ) = gbcd( c1, c2, c3, c4, c5 ) + Areas(i);
                        end
                    end
                end
            end
        end
    end
    
    %Write GBCD to file (testing)
  %  WriteGBCD( gbcd )
    
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

    q_i = q;
    q_i(1) = -q(1);
    
end

%taken from Rollett's ppt notes
function e = EulersOfBunge( b )

    e(1) = b(1) - 90.0;
    e(2) = b(2);
    e(3) = 90.0 - b(3); 

    %total fudge, but this is needed to verify with original code
    e(3) = 360.0 - e(3);
    
    %test if e is within [0,0,0]->[360,180,360]
    if( e(1) > 360.0 )
        e(1) = e(1) - 360.0;
    elseif( e(1) < 0.0 )
        e(1) = e(1) + 360.0;
    end
    
    if( e(2) > 180.0 )
        e(2) = e(2) - 180.0;
    elseif( e(2) < 0.0 )
        e(2) = e(2) + 180.0;
    end
    
    if( e(3) > 360.0 )
        e(3) = e(3) - 360.0;
    elseif( e(3) < 0.0 )
        e(3) = e(3) + 360.0;
    end
    
end
