% this code contains one simulation of the traffic
B = 8; % Tollbooth number
L = 3; % Regular lane number
cell_size = 0.5; % cutting the road into small cells of 0.25 m^2
shapePoints = [32 0; 24 50;20 100;16 150; 12 200]; % (unit: m)the distance from the boundary of roads to the cell limit at y=50, 100, 150
% decision period is 1s, thus minimum speed taken into account is 0.5 m/s
toll_barrier_state = zeros(B,50); % track vehicle departing from the tollbooth with historical info
cells = ini_cells(cell_size,shapePoints,B,L); %inital the meshing of roads.

