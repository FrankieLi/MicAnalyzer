function [breaks_start, breaks_end] = AmendRadiusBreaks(breaks_start, breaks_end, Spots_List, figureNumber)
 
    fig = figure(figureNumber);
    new_breaks_start = breaks_start
    new_breaks_end = breaks_end
    cursor_obj = [];
    cursor_obj = datacursormode(fig);
    set(cursor_obj,'DisplayStyle','datatip', 'SnapToDataVertex','on','Enable','on')
    omit = 0;
    
    omit = input('Would you like to remove any radial partitions? 1-yes 0-no');
    %Omitting radius breaks
    if (omit == 1)
   
        input('Press enter after selection');
        toOmit = getCursorInfo(cursor_obj);
        N_omit = size(toOmit,2);
        
        for i=1:N_omit
            loc = [];
            break_start_toOmit(i) = toOmit(i).Position(1)
            loc = find(break_start_toOmit(i) == breaks_start)           
            new_breaks_start(loc) = -1;
            new_breaks_end(loc - 1) = -1;
        end
    end
    q = [];
    q = find(new_breaks_start < 0);
    new_breaks_start(q) = [];
    q = [];
    
    r = [];
    r = find(new_breaks_end < 0);
    new_breaks_end(r) = [];
    r = [];

    new_breaks_start = sort(new_breaks_start);
    new_breaks_end = sort(new_breaks_end);
    
    size(new_breaks_start)
    size(new_breaks_end)
    new_breaks_start
    new_breaks_end

    cursor_obj = [];
    cursor_obj = datacursormode(fig);
    set(cursor_obj,'DisplayStyle','datatip', 'SnapToDataVertex','on','Enable','on')

    %Adding new radius breaks
    insertVal = input('Would oyou like to add radius partitions? yes-1 no-0');
    if (insertVal == 1)
        insertVal = input('Please insert new END POINTS, by using the cursor. \n Press <Enter> when completed. \n');
        toInsert = getCursorInfo(cursor_obj);
        N_toInsert = size(toInsert,2)
        
        for i=1:N_toInsert
            break_end_toAdd(i) = toInsert(i).Position(1)
        end
    
        new_breaks_end = [new_breaks_end, break_end_toAdd];
        break_start_toAdd = break_end_toAdd + 1;
        new_breaks_start = [new_breaks_start, break_start_toAdd];
    
        new_breaks_start = sort(new_breaks_start);
        new_breaks_end = sort(new_breaks_end);
        new_breaks_start
        new_breaks_end
    
    end
   figure(figureNumber)
   hold on
   vline(new_breaks_start, 'k');