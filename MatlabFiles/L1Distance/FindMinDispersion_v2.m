function L1_data = FindMinDispersion_v2(AllLines_LSF,Zfit_LSF, Shift_Spot)

%Function calls:  PlaneLineIntersection.m

St_val_mm = [];
St_val_tmp_mm = [];

for i = 1:10
    St_val_tmp_mm = PlaneLineIntersection(AllLines_LSF, Shift_Spot, Zfit_LSF, i);
    St_val_mm(i,1) = St_val_tmp_mm(1);
    St_val_mm(i,2) = St_val_tmp_mm(2);
    St_val_mm(i,3) = St_val_tmp_mm(3);
    St_val_mm(i,4) = St_val_tmp_mm(4);
    St_val_mm(i,5) = i;
end

min_stval = min(St_val_mm(1:10, 4));

for i = 1:10
    if (St_val_mm(i,4) == min_stval)
        min_loc_mm = i;
    end
end

%% min_loc_mm is the mm location of the minimum, min_stval is its value

mm_1_begin = min_loc_mm - 1;
mm_1_end = min_loc_mm + 1;

St_val_mm_1 = [];
St_val_tmp_mm_1 = [];

cnt_1 = 0;
for i=mm_1_begin:0.1:mm_1_end
    cnt_1 = cnt_1 + 1;
    St_val_tmp_mm_1 = PlaneLineIntersection(AllLines_LSF, Shift_Spot, Zfit_LSF, i);
    St_val_mm_1(cnt_1,1) = St_val_tmp_mm_1(1);
    St_val_mm_1(cnt_1,2) = St_val_tmp_mm_1(2);
    St_val_mm_1(cnt_1,3) = St_val_tmp_mm_1(3);
    St_val_mm_1(cnt_1,4) = St_val_tmp_mm_1(4);
    St_val_mm_1(cnt_1,5) = i;
end

min_stval_1 = min(St_val_mm_1(1:cnt_1, 4));

for i = 1:cnt_1
    if (St_val_mm_1(i,4) == min_stval_1)
        min_loc_mm_1 = St_val_mm_1(i,5);
    end
end

mm_2_begin = min_loc_mm_1 - 0.1;
mm_2_end = min_loc_mm_1 + 0.1;

St_val_mm_2 = [];
St_val_tmp_mm_2 = [];

cnt_2 = 0;
for i=mm_2_begin:0.01:mm_2_end
    cnt_2 = cnt_2 + 1;
    St_val_tmp_mm_2 = PlaneLineIntersection(AllLines_LSF, Shift_Spot, Zfit_LSF, i);
    St_val_mm_2(cnt_2,1) = St_val_tmp_mm_2(1);
    St_val_mm_2(cnt_2,2) = St_val_tmp_mm_2(2);
    St_val_mm_2(cnt_2,3) = St_val_tmp_mm_2(3);
    St_val_mm_2(cnt_2,4) = St_val_tmp_mm_2(4);
    St_val_mm_2(cnt_2,5) = i;
end

min_stval_2 = min(St_val_mm_2(1:cnt_2, 4));

for i = 1:cnt_2
    if (St_val_mm_2(i,4) == min_stval_2)
        min_loc_mm_2 = St_val_mm_2(i,5);
    end
end

mm_3_begin = min_loc_mm_2 - 0.01;
mm_3_end = min_loc_mm_2 + 0.01;

St_val_mm_3 = [];
St_val_tmp_mm_3 = [];

cnt_3 = 0;
for i=mm_3_begin:0.001:mm_3_end
    cnt_3 = cnt_3 + 1;
    St_val_tmp_mm_3 = PlaneLineIntersection(AllLines_LSF, Shift_Spot, Zfit_LSF, i);
    St_val_mm_3(cnt_3,1) = St_val_tmp_mm_3(1);
    St_val_mm_3(cnt_3,2) = St_val_tmp_mm_3(2);
    St_val_mm_3(cnt_3,3) = St_val_tmp_mm_3(3);
    St_val_mm_3(cnt_3,4) = St_val_tmp_mm_3(4);
    St_val_mm_3(cnt_3,5) = i;
end

min_stval_3 = min(St_val_mm_3(1:cnt_3, 4));

for i = 1:cnt_3
    if (St_val_mm_3(i,4) == min_stval_3)
        min_loc_mm_3 = St_val_mm_3(i,5);
    end
end

PlaneData = [St_val_mm; St_val_mm_1; St_val_mm_2; St_val_mm_3];
%plot(PlaneData(:,5), PlaneData(:,4), 'x')



L1_data = min_loc_mm_3;

