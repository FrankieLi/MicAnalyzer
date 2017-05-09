function [indx_2theta, Only2Thetas] = Theory2Thetas_Au(max_Index, Energy)

%This function will produce the possible Miller indices for an FCC crystal
%max_Index is the maximum miller index that is used (hence nothing bigger
%than [max_index , max_index , max_index] will be looked at


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
    twotheta(mm,:) = CalcTwoTheta_Au(H(mm), K(mm), L(mm), Energy);
end

hkl2theta = [H', K', L', twotheta];
hkl = sortrows(hkl2theta,4);

indx_2theta = hkl;

Only2Thetas = unique(indx_2theta(:,4));
Only2Thetas = Only2Thetas(2:end,:);
