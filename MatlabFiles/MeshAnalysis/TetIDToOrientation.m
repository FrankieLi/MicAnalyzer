%%
%%  TetIDToOrientation
%%
%%
%%
function Orient = TetIDToOrientation( DomainFile, OrientationFile, TetID )


snpDomain = load( DomainFile );
snpOrient = load( OrientationFile );



GrainIDs = snpDomain( TetID, 1 );
GrainIDs = GrainIDs + 1;
findvec = find( GrainIDs > 0 );

Orient  = zeros( length(GrainIDs), 3 );

qOrient = QuatOfRMat( RMatOfBunge( snpOrient', 'degrees') );
qOrient = ToFundamentalRegionQ( qOrient, CubSymmetries );

snpOrient = BungeOfRMat( RMatOfQuat( qOrient ), 'degrees' );

Orient(findvec, :) = snpOrient( :, GrainIDs(findvec) )'; 

end