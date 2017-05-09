function output = fillImage(snp, x, y, shift )

if (nargin < 4 )
    shift = 0;
end


output = zeros(x, y);
% for i = 1:size(snp, 1)
%    
%     output( snp(i, 1) + shift, snp(i, 2) + shift ) = snp(i, 3);
%     
% end

Ind = sub2ind( [x, y], snp(:, 1) + shift, snp(:, 2) + shift );
output(Ind) = snp(:, 3);