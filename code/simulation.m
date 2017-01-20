% this code contains one simulation of the traffic
B = 8; % Tollbooth number
L = 3; % Regular lane number
cell_size = 0.5; % cutting the road into small cells of 0.25 m^2
shapePoints = [32 0; 24 50;20 100;16 150; 12 200]; % (unit: m)the distance from the boundary of roads to the cell limit at y=50, 100, 150
% decision period is 1s, thus minimum speed taken into account is 0.5 m/small

toll_barrier_state = zeros(70,B); % track vehicle departing from the tollbooth with historical info
toll_barrier_config = [3,3,3,3,3,3,3,3; 20,20,20,20,20,20,20,20]; 
% line 1 for vehicle types: 1, small, 2, medium, 3, large
% line 2 for delay caused by charge mechanisms: 20, conventional, 10, exact exchange, 2,
% electronic
flow_total = 300; % total flow
flow_instant = zeros(901,1); % number of vehicles per 15 minutes
% distribute flow into each second
for i=1:flow_total
    ind = floor(rand()*900);
    flow_instant(ind) = flow_instant(ind) + 1;
end
cells = ini_cells(cell_size,shapePoints,B,L); %inital the meshing of roads.

for i=1:900 % one simulation per second;
[toll_barrier_state, flow_queue] = updateTollStation(flow_total, flow_instant(i), toll_barrier_state, toll_barrier_config);
flow_instant(i+1) = flow_queue + flow_instant(i+1);
end