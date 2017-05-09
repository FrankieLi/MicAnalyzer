function EuColor = EulerToColor( eu, type )


RF = RodOfQuat( QuatOfRMat( RMatOfBunge( eu', type )));


RF = RF';
min(RF)
% RF(:, 1) = RF(:, 1) - min( RF(:, 1) );
% RF(:, 2) = RF(:, 2) - min( RF(:, 2) );
% RF(:, 3) = RF(:, 3) - min( RF(:, 3) );

RF(:, 1) = RF(:, 1) + 0.5;
RF(:, 2) = RF(:, 2) + 0.5;
RF(:, 3) = RF(:, 3) + 0.5;

max(RF)

d1 = max(RF(:, 1));
d2 = max(RF(:, 2));
d3 = max(RF(:, 3));


RF(:, 1) = RF(:, 1);
RF(:, 2) = RF(:, 2);
RF(:, 3) = RF(:, 3);

EuColor = uint8(RF * 255);

findvec = find( isnan( EuColor(:, 1) ) | isnan( EuColor(:, 2) ) | isnan( EuColor(:, 3)));
EuColor( findvec, : ) = 255;
end