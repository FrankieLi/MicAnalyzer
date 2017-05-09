%%
%%   MeshArea
%%    Given triangles and their corresponding nodes
%%    calculate the area of the mesh within the bounding
%%    box specified
%%
function Area = MeshArea( Triangles, Nodes, NodeScale, pMin, pMax )

Nodes(:, 1) = Nodes(:, 1) * NodeScale(1);
Nodes(:, 2) = Nodes(:, 2) * NodeScale(2);
Nodes(:, 3) = Nodes(:, 3) * NodeScale(3);
n1 = Nodes( Triangles(:, 1), : );
n2 = Nodes( Triangles(:, 2), : );
n3 = Nodes( Triangles(:, 3), : );

p1 = n1 - n3;
p2 = n2 - n3;


bInside1 = InRange( n1, pMin, pMax );
bInside2 = InRange( n2, pMin, pMax );
bInside3 = InRange( n3, pMin, pMax );

findvec = bInside1 & bInside2 & bInside3;

p1 = p1( findvec, : );
p2 = p2( findvec, : );

A = cross(p1, p2, 2);
A = sqrt( dot(A, A, 2) )/2;

Area = sum( A );
end


function v = InRange( p, pMin, pMax )


v = ( p(:, 1) > pMin(1) & p(:, 1) < pMax(1) ...
& p(:, 2) > pMin(2) & p(:, 2) < pMax(2)...
& p(:, 3) > pMin(3) & p(:, 3) < pMax(3) );

end