function[cells] =  ini_cells(cell_size,shapePoints,B,L)
% initial cells, including the shape

length_cells = 400;
width_cells = 64; %>=32
shapePoints = shapePoints/0.5; %shapePoints in cells
cells = zeros(length_cells,width_cells,4); %meshing the road into hundreds of cells
boundaryPoints = interp1(shapePoints(:,2), shapePoints(:,1),-0.5+(1:1:length_cells),'spline');
%plot(-0.5+1:1:length_cells,boundaryPoints); only for test
for i = 1:length_cells
    cells(i,round(boundaryPoints(i)):end,1) = -1;
end

%% test part
%HeatMap(cells);
end 

