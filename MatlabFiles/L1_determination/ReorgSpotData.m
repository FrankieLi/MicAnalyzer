%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ReorgSpotData.m
%                       
% Function reorganizes the center of intensity matrix to reflect the column
% convention used in the L1 program.
%
% Input - cofi_matrix, N x 8 matrix of the form:
%                       col1 = j(center) (horizontal)
%                       col2 = k(center) (vertical)
%                       col3,4 = +- pixel distances for j edges
%                       col5,6 = +- pixel distances for k edges 
%                       col7 = total intensity in peak
%                       col8 = total number of pixels in peak
%
% Output - newDmatrix, N x 7 matrix similar to cofi_matrix, except:
%                      col3 = total number of pixels in peak
%                      col4-7 = pixel addresses of edges instead of +-
%                      displacements.
%


function newDmatrix = ReorgSpotData(cofi_matrix)
  
newDmatrix = [];
  
if (size(cofi_matrix,1) > 0)
      
%        newDmatrix(:,1) = 2048 - cofi_matrix(:,1); %returns j pixel in cofi_matrix (horizontal pixel address)
%        newDmatrix(:,2) = 2048 - cofi_matrix(:,2); %returns k pixel in cofi_matrix (vertical pixel address)
        newDmatrix(:,1) = cofi_matrix(:,1);
        newDmatrix(:,2) = cofi_matrix(:,2);
        newDmatrix(:,4) = cofi_matrix(:,2) + cofi_matrix(:,5); %vertical spot edges
        newDmatrix(:,5) = cofi_matrix(:,2) + cofi_matrix(:,6);
        newDmatrix(:,6) = cofi_matrix(:,1) + cofi_matrix(:,3); %hor spot edges
        newDmatrix(:,7) = cofi_matrix(:,1) + cofi_matrix(:,4);
     %   newDmatrix(:,3) = (newDmatrix(:,7) - newDmatrix(:,6) + 1) .* (newDmatrix(:,5) - newDmatrix(:,4) + 1); %width*height of spot (size estimate)
        newDmatrix(:,3) = cofi_matrix(:,8);
end