function ClassifiedSpots = ClassifySpots(Spots, AllLines_ini, AllLines_Final)

%Function is used to figure out which spots are contributing to L1
%calculation

%ClassifiedSpots columns 1-6 are same as Spots
%Column 7 has a 1 if it is part of a valid line (satisfies all the requirements to be a possible scattering vector)
%Column 8 has a 2 if it contributes to the L1 calculation

%Hence there are 3 possibilites:
%Col 7  = 0, Col 8 = 0 - spot isn't on a line
%Col 7  = 1, Col 8 = 0 - spot is on a line that DOESN'T contribute to the L1 calculation (scattering from unknown origin)
%Col 7  = 1, Col 8 = 2 - spot is on a line that comes from the sample

N_Spots = size(Spots,1);
N_Lines_ini = size(AllLines_ini,1);
N_Lines_Final = size(AllLines_Final,1);

for i=1:N_Lines_ini
    Spots(AllLines_ini(i,5),7) = 1;
    Spots(AllLines_ini(i,6),7) = 1;
    Spots(AllLines_ini(i,7),7) = 1;
end

for i=1:N_Lines_Final
    Spots(AllLines_ini(i,5),8) = 2;
    Spots(AllLines_ini(i,6),8) = 2;
    Spots(AllLines_ini(i,7),8) = 2;
end

ClassifiedSpots = Spots;

