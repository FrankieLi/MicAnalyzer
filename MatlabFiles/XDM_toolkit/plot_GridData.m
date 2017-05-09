function plot_GridData(snp, sidewidth, plotType, writeToFile, filename)

% (x, y, data, minX, maxX, minY, maxY, nx, ny)

findvec = find(snp(:, 6) == 1);
snp = snp(findvec, :);

snp(:, 7:9) = snp(:, 7:9) *pi/180;   

sidewidth ;
x = snp(:, 1);
y = snp(:, 2);
%data = snp(:, 7);
minX = min(x);
maxX = max(x);
minY = min(y);
maxY = max(y);


% dx = (maxX - minX) /nx;
% dy = (maxY - minY) /ny;


%myMesh = zeros(nx, ny);

top_x = [ x - sidewidth/2, x + sidewidth/2, x - sidewidth/2] ;
top_y = [ y + sidewidth/2, y + sidewidth/2, y - sidewidth/2] ; 

bottom_x = [ x + sidewidth/2, x + sidewidth/2, x - sidewidth/2] ;
bottom_y = [ y + sidewidth/2, y - sidewidth/2, y - sidewidth/2] ; 


quad_x = [top_x; bottom_x]';
quad_y = [top_y; bottom_y]';


% plot grain
if(plotType == 1)
    tmp =  snp(:, 7:9);
    tmp = [tmp(:, 1)/(360), tmp(:, 2)/(360), tmp(:, 3)/(360)];
%    tmp = [sin(tmp(:, 1)), cos(tmp(:, 2)), sin(tmp(:, 3))];
elseif(plotType == 2) % plot confidence map
    tmp = snp(:, 10)/67;
    tmp = tmp;%/max(tmp); 
    tmp = [tmp, zeros(length(tmp), 1), 1-tmp];
elseif(plotType==3) % plot rodrigues vectors
    tmp =  snp(:, 7:9);
    % convert
    for i = 1:length(tmp)
        tmpR = getEuler_rad_pos(tmp(i, :));
        tmp(i, :) = MatrixToRFVector(tmpR);
    end

    tmp(:, 1) =  tmp(:, 1) - min(tmp(:, 1))  ;
    tmp(:, 2) =  tmp(:, 2) - min(tmp(:, 2))  ;
    tmp(:, 3) =  tmp(:, 3) - min(tmp(:, 3))  ;
    
   
%     tmp(:, 1) = tmp(:, 1) / max(tmp(:, 1));
%     tmp(:, 2) = tmp(:, 2) / max(tmp(:, 2));
%     tmp(:, 3) = tmp(:, 3) / max(tmp(:, 3));
    tmp(:, 1) = tmp(:, 1) / 0.84;
    tmp(:, 2) = tmp(:, 2) / 0.84;
    tmp(:, 3) = tmp(:, 3) / 0.84;

elseif(plotType == 5)
    disp('IPF');
    tmp = inversePoleFigureColor( snp(:, 7:9) ); 
end

tmp = [tmp; tmp];


size_vec = size(tmp);
tri_color = zeros(1, size_vec(1), size_vec(2));
tri_color(1, :, :) = tmp;
% myFigure = figure;
axis([minX, maxX, minY, maxY]);
h = patch(quad_x, quad_y,  tri_color, 'EdgeColor', 'none');

if(writeToFile == 1)
    title(filename);
    saveas(myFigure, filename, 'bmp ');
    close(myFigure)
end
if(plotType == 2)
    colormap(sortrows(tmp, -3));
    colorbar(tmp); 
end