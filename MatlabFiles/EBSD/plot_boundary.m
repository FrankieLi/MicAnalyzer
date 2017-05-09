function plot_boundary(b)

b_size = size(b);
hold on;
for i = 1:b_size(1)
   
    line( [b(i, 1), b(i, 3)], [b(i, 2), b(i, 4)],'Color','r' );
    
end
hold off;