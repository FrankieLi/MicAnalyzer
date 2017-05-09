for i=1:180
    
    j = i + 181;
    k = j + 181;
    
    if (i < 10)
        zeros1 = '0000';
    elseif ( (i < 100) && (i > 9))
        zeros1 = '000';
    else
        zeros1 = '00';
    end
    
    if (j < 10)
        zeros2 = '0000';
    elseif ( (j < 100) && (j > 9))
        zeros2 = '000';
    else
        zeros2 = '00';
    end
    
    if (k < 10)
        zeros3 = '0000';
    elseif ( (k < 100) && (k > 9))
        zeros3 = '000';
    else
        zeros3 = '00';
    end
    
    a = [];
    b = [];
    c = [];
    a = textread(strcat('C:\Research\17-oct09\CofI\Au30um_Oct09_',zeros1,int2str(i), '.d1.intens'));
    b = textread(strcat('C:\Research\17-oct09\CofI\Au30um_Oct09_',zeros2,int2str(j), '.d2.intens'));
    c = textread(strcat('C:\Research\17-oct09\CofI\Au30um_Oct09_',zeros3,int2str(k), '.d3.intens'));
    
    figure(1)
    plot(2048 - a(:,1), 2048 - a(:,2), '.r',2048- b(:,1), 2048 - b(:,2), '.g', 2048 -c(:,1), 2048 - c(:,2), '.k');
    axis ij
    axis equal
    axis([0 2048 0 2048])
    
    figure(2)
    DetOutMatlab_SingleL_Exp('C:\Research\17-oct09\z1_red\Au_Oct09_', i, i, 'd1');

end

%tagCofI = 'C:\Research\17-oct09\CofI\Au30um_Oct09_';
%tagRed = 'C:\Research\17-oct09\z1_red\Au_Oct09_';

