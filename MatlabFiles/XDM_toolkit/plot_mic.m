  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
  %%  plot_mic.m
  %%
  %%  Usage:
  %%  plot_mic( snp, sidewidth, plotType, minConfidence )
  %%
  %%  snp - a snapshot read from a .mic file using load_mic
  %%  sidewidth - the width of one side of a hexagon returned by load_mic
  %%  plotType - 1 => plots of orientations, 2 => plots of confidence level
  %%
  %%  Note that there is limitations ont he colormap resolution.
  %%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%
  %% Legacy File Format:
  %% Col 1-3 x, y, z
  %% Col 4   1 = triangle pointing up, 2 = triangle pointing down
  %% Col 5 generation number; triangle size = sidewidth /(2^generation number )
  %% Col 6 Phase - 1 = exist, 0 = not fitted
  %% Col 7-9 orientation
  %% Col 10  Confidence
  %%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function h = plot_mic(snp, sidewidth, plotType, ConfidenceRange, NewFigure, bCenter, bTightFit )
  function h = plot_mic( varargin )

  
  snp       = varargin{1};
  sidewidth = varargin{2};
  plotType  = varargin{3};
  ConfidenceRange = varargin{4};
  
  %% default parameters
  bTightFit = false;
  bCenter   = false;
  NewFigure = false;
  if( nargin >= 5 )
    NewFigure = varargin{5};
  end
  if( nargin >= 7 )
    bTightFit = varargin{7};
  end
  
  if( nargin >= 6 )
    bCenter = varargin{6};
  end
    
  if( nargin >= 8 )
    ConfColorScale = varargin{8};
  end
  
  if( nargin >= 9 )
    ColorType = varargin{9};
  else
    ColorType = 'Red';
  end
  if ( nargin < 4 )
    DisplayUsage();
    error('Not enough argument');
  end

  ValidPlotType = [1, 2, 3, 4, 5, 6];

  if( plotType < 1 & plotType > 6 )
    DisplayUsage();
    error('Plot Type not defined!  See USAGE for detail');
  end

  ConfSize = size( ConfidenceRange );
  if( ConfSize(1) > 1 || ConfSize(2) > 1 )
	findvec = snp(:, 10) >= ConfidenceRange(1)  & snp(:, 10) <= ConfidenceRange(2);
%    disp('Confidance range not yet supported');
  else
    findvec = snp(:, 10) > ConfidenceRange ;
  end


  [tri_x, tri_y, snp_Euler, snp_Conf ] = GetTriangleVertices( snp, sidewidth );

  % plot grain
  if(plotType == 1)
    tmp =  [ snp_Euler ]/480;
    tmp = [1-tmp(:, 1), tmp(:, 2), 1-tmp(:, 3)];

  elseif(plotType == 2) % plot confidence map
      if( nargin < 8 )
        tmp = [ snp_Conf ];
        tmp = [ snp_Conf ] - min( snp_Conf );   % original auto rescale
        tmp = tmp /( max(snp_Conf) - min(snp_Conf) );  % original auto rescale
        tmp = [tmp, zeros(length(tmp), 1), 1-tmp];
        xConf = [0:0.01:1]';
        colormap( [ xConf, xConf * 0, 1- xConf]  );
        caxis( [min(snp_Conf), max(snp_Conf) ] );   % original, auto rescale
        caxis( [min(snp_Conf), max(snp_Conf) ] );
      else  % clipping
        
        tmp = [ snp_Conf ];
        tmp = max(tmp, ConfColorScale(1));
        tmp = min(tmp, ConfColorScale(2) );

%         tmp = [ snp_Conf ] - ConfColorScale(1);   % original auto rescale
        	 % original auto rescale
        disp('rescale');
        tmp = tmp - min(tmp);

        tmp = tmp /( max(tmp) - min(tmp) ); 
        if( strcmp( ColorType, 'Red') )
          tmp = [tmp, zeros(length(tmp), 1), 1-tmp];
          xConf = [ min(tmp):0.01:max(tmp)]';
          colormap( [ xConf, xConf * 0, 1- xConf]  );
        elseif( strcmp(ColorType, 'Gray') )
          tmp = [tmp , tmp, tmp];
          xConf = [ min(tmp):0.01:max(tmp)]';
          colormap( [ xConf, xConf , xConf]  );
        else
          error('Unknown type');
        end
        caxis( [ConfColorScale(1),ConfColorScale(2)] );   % original, auto rescal 
    end
  
  colorbar( 'location', 'eastoutside');
    
  elseif(plotType==3) % plot rodrigues vectors
    tmp =  [ snp_Euler ] * pi/180;
    % convert
    for i = 1:length(tmp)
      tmpR = getEuler_rad_pos(tmp(i, :));
      tmp(i, :) = MatrixToRFVector(tmpR);
    end

    tmp(:, 1) =  tmp(:, 1) - min(tmp(:, 1))  ;
    tmp(:, 2) =  tmp(:, 2) - min(tmp(:, 2))  ;
    tmp(:, 3) =  tmp(:, 3) - min(tmp(:, 3))  ;

    
    tmp(:, 3) = tmp(:, 3) / ( max(tmp(:, 3) ) - min(tmp(:, 3) ) );
    tmp(:, 2) = tmp(:, 2) / ( max(tmp(:, 2) ) - min(tmp(:, 2) ) );
    tmp(:, 1) = tmp(:, 1) / ( max(tmp(:, 1) ) - min(tmp(:, 1) ) );


  elseif(plotType == 4) % plot pole figure
    tmp = fixedEulerColor( snp_Euler );
  elseif(plotType == 5)
    disp('IPF');
    tmp = inversePoleFigureColor([ snp_Euler ] * pi/180);

  elseif(plotType == 6)

    tmp =  [snp_Euler]/480;
    tmp = [1-tmp(:, 1), tmp(:, 2), 1-tmp(:, 3)];
    size_vec = size(tmp);
    tri_color = ones(1, size_vec(1), size_vec(2));
    % figure;
    axis equal;
    h = patch(tri_x, tri_y, tri_color);
    
 elseif(plotType == 7) % plot misorientation map

    tmp = [ snp_Conf ];
    tmp = tmp/max(tmp);
    tmp = [tmp, zeros(length(tmp), 1), 1-tmp];

    step = ( max(snp_Conf) - min(snp_Conf) ) /10;
    xConf = [min(snp_Conf):step:max(snp_Conf)]';
    xConf = xConf / max(xConf);
    colormap( [ xConf, xConf * 0, 1- xConf]  );
    caxis( [min(snp_Conf), max(snp_Conf) ] );
    colorbar( 'location', 'eastoutside');
  elseif(plotType == 8) % plot color map (grain map)
  
    tmp =   snp_Euler ;
   
    tmp(:, 1) =  tmp(:, 1) - min(tmp(:, 1))  ;
    tmp(:, 2) =  tmp(:, 2) - min(tmp(:, 2))  ;
    tmp(:, 3) =  tmp(:, 3) - min(tmp(:, 3))  ;


    tmp(:, 3) = tmp(:, 3) / max(tmp(:, 3));
    tmp(:, 2) = tmp(:, 2) / max(tmp(:, 2));
    tmp(:, 1) = tmp(:, 1) / max(tmp(:, 1));


  end
  
  if( plotType ~= 6 )
    size_vec = size(tmp);
    tri_color = zeros(1, size_vec(1), size_vec(2));
    tri_color(1, :, :) = tmp;
    %figure;
    if ~bCenter 
      if ( ~bTightFit )
        axis([ -sidewidth, sidewidth, -sidewidth, sidewidth], 'square');
      else
        micCenter = [mean(snp(:, 1)), mean( snp(:, 2) )];
        dx = max( tri_x(:) ) - min( tri_x(:) );
        dy = max( tri_y(:) ) - min( tri_y(:) );
        
        newSw = max( [dx, dy] ) / 2;
        axis([ micCenter(1) - newSw, micCenter(1) + newSw, micCenter(2) - newSw, micCenter(2) + newSw ], 'square' );
        
      end
    else
      findvec = find( snp(:, 6) > 0 );
      xCenter = mean( snp(findvec, 1) );
      yCenter = mean( snp(findvec, 2) );
      axis([ -sidewidth + xCenter, sidewidth + xCenter, -sidewidth + yCenter, sidewidth + yCenter], 'square');
    end
    h = patch(tri_x, tri_y,  tri_color, 'EdgeColor', 'none');
  end


  box on;
  axis square;


  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%
  %%  GetTriangleVertices
  %%
  %%   Compute all vertices given a legacy snapshot format
  %%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  function [tri_x, tri_y, snp_Euler, snp_Conf ] = GetTriangleVertices( snp, sidewidth )

  snp(:,5) = 2.^ snp(:, 5);

  % find range
  max_x = 1*sidewidth;
  max_y = 1*sidewidth;
  min_x = -1*sidewidth;
  min_y = -1*sidewidth;

  % find all fitted triangles
  snp = sortrows(snp, 6);
  findvec = find(snp(:, 6) > 0);
  snp = snp(findvec, :);

  % sort by triangle
  snp = sortrows(snp, 4);

  % find triangles pointing up
  downsIndex = find(snp(:, 4) > 1);
  upsIndex = find(snp(:, 4) <= 1);

  ups = snp(upsIndex, :);
  downs = snp(downsIndex, :);


  ups_sides = sidewidth ./ ups(:, 5);
  downs_sides = sidewidth ./ downs(:, 5);

  % calculate ups v1, ups v2, and ups v3
  ups_v1 = ups(:, 1:2);      % (x, y)
  ups_v2 = ups(:, 1:2);
  ups_v2(:, 1) = ups_v2(:, 1) + ups_sides;  % (x+s, y) direction
  ups_v3 = ups(:, 1:2);
  ups_v3(:, 1) = ups_v3(:, 1) + ups_sides/2; % (x+s/2, y)
  ups_v3(:, 2) = ups_v3(:, 2) + ups_sides/2 * sqrt(3); % (x+s/2, y+s/2 *sqrt(3));


  % calculate downs v1, downs v2, and downs v3
  downs_v1 = downs(:, 1:2);      % (x, y)
  downs_v2 = downs(:, 1:2);
  downs_v2(:, 1) = downs_v2(:, 1) + downs_sides;  % (x+s, y) direction
  downs_v3 = downs(:, 1:2);
  downs_v3(:, 1) = downs_v3(:, 1) + downs_sides/2; % (x+s/2, y)
  downs_v3(:, 2) = downs_v3(:, 2) - downs_sides/2 * sqrt(3); % (x+s/2, y - s/2 *sqrt(3));

  % format is in [v1; v2; v3], where v1, v2, and v3 are rol vectors
  tri_x = [ [ups_v1(:, 1); downs_v1(:, 1)]'; [ups_v2(:, 1); downs_v2(:, 1)]'; [ups_v3(:, 1); downs_v3(:, 1)]'];
  tri_y = [ [ups_v1(:, 2); downs_v1(:, 2)]'; [ups_v2(:, 2); downs_v2(:, 2)]'; [ups_v3(:, 2); downs_v3(:, 2)]'];

  snp_Reordered = [ ups; downs];
  snp_Euler = snp_Reordered( :, 7:9 );
%   snp_Conf  = snp_Reordered( :, 10  );
   snp_Conf  = snp_Reordered( :, 10  );
%  snp_Conf  = snp_Reordered( :, 13  ) ./snp_Reordered( :, 14  );
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%
  %%  DisplayUsage
  %%
  %%
  %%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  function DisplayUsage()

  disp('USAGE:  plot_mic( SnapShotName, SideWidth, PlotType, MinConfidence)')
  disp('PlotType = 1 -- Direct mapping of angles to RGB color')
  disp('PlotType = 2 -- Confidence plot')
  disp('PlotType = 3 -- Mapping of RF-vectors to RGB color')
  disp('PlotType = 5 -- Inverse Pole Figure')
  disp('PlotType = 6 -- Mesh Structure')
  end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%
  %%  fixedEulerColor
  %%
  %%
  %%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  function colorOut = fixedEulerColor(Eu)

  colorOut = Eu;
  EuSize = size(Eu);
  EuLength = EuSize(1);

  % calculate misorientation from fixed color and vectors

  %
  %  (35, 45, 0)
  %  (90, 35, 45)
  %  (42, 37, 9)
  %  (59, 37, 63)
  %  (0, 45, 0)
  %  (0, 0, 0)
  %  (90, 25, 65)

  colorList = cell(7, 2);
  colorList{1, 1} = [35, 45, 0];
  colorList{2, 1} = [90, 35, 45];
  colorList{3, 1} = [42, 37, 9];
  colorList{4, 1} = [59, 37, 63];
  colorList{5, 1} = [0, 45, 0];
  colorList{6, 1} = [0, 0, 0];
  colorList{7, 1} = [90, 25, 65];


  colorList{1, 2} = [.5, 0, 0];
  colorList{2, 2} = [0, .5, 0];
  colorList{3, 2} = [0, 0, .5];
  colorList{4, 2} = [.5, .5, 0];
  colorList{5, 2} = [0, .5, 1];
  colorList{6, 2} = [.5, 0, .5];
  colorList{7, 2} = [.5, .5, .5];


  allowedMisorient = 15;

  cubicSymOps = GetCubicSymOps();

  test = zeros(EuLength, 2);
  for i = 1:EuLength

    minMisorient = 360;
    minJ = -1;
    for j = 1:7
      currentMisorient = misorient_sym_deg(Eu(i, :), colorList{j, 1}, cubicSymOps, 24);
      if(currentMisorient < minMisorient)
        minMisorient = currentMisorient;
        minJ = j;
      end
    end

    test(i, 1) = minJ;
    test(i, 2) = minMisorient;
    if(minJ > -1 & minMisorient < allowedMisorient)
      colorOut(i, :) = colorList{minJ, 2};
    else
      colorOut(i, :) = [0, 0, 0];
    end

  end
  disp('end');
  end