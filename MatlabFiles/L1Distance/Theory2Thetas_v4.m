function indx_2theta = Theory2Thetas_v4(max_Index, material)

%This function will produce the possible Miller indices for an FCC crystal
%max_Index is the maximum miller index that is used (hence nothing bigger
%than [max_index , max_index , max_index] will be looked at

%Edit - September 28, 2007 - to eliminate returning 2theta = 0 possiblity

%Notes - Oct. 5, 2007
% Added material parameter to reflect if we're using gold or ruby
     % material = 0 (gold) OR 1 (ruby)

%Function calls:
    %CalcTwoTheta_50keV_Au.m
    %CalcTwoTheta_50keV_Ruby.m
    
 

Ints_even = 0:2:max_Index;
Ints_odd = 1:2:max_Index;


sz_even = size(Ints_even,2);
sz_odd = size(Ints_odd,2);
cnt = 0;

for i = 1:sz_even
    for j = 1:sz_even
        for m = 1:sz_even
         
          cnt = cnt + 1;
          H(cnt) = Ints_even(i);
          K(cnt) = Ints_even(j);
          L(cnt) = Ints_even(m);
      end
  end
end

for i = 1:sz_odd
    for j = 1:sz_odd
        for m = 1:sz_odd
         
          cnt = cnt + 1;
          H(cnt) = Ints_odd(i);
          K(cnt) = Ints_odd(j);
          L(cnt) = Ints_odd(m);
      end
  end
end

sz_H = size(H,2);

for mm = 1:sz_H
    %if ((H(mm) ~= 0) && (K(mm) ~= 0) && (L(mm) ~= 0))
    if (material == 0) %Using Gold
        twotheta(mm,:) = CalcTwoTheta_50keV_Au(H(mm), K(mm), L(mm));
    end
    
    if (material == 1) %Using Ruby
        twotheta(mm,:) = CalcTwoTheta_50keV_Ruby(H(mm), K(mm), L(mm));
    end
        %end
end

hkl2theta = [H', K', L', twotheta];
hkl = sortrows(hkl2theta,4);
N_hkl = size(hkl,1);
cnt = 0;
indx_2theta = [];

for i=1:N_hkl
    if (hkl(i,4) > 0)
      cnt = cnt + 1;
      indx_2theta(cnt,:) = hkl(i,:);
    end
end


