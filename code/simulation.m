% this code contains one simulation of the traffic
B = 8; % Tollbooth number
L = 3; % Regular lane number
cell_size = 0.5; % cutting the road into small cells of 0.25 m^2
shapePoints = [32 0; 24 50;20 100;16 150; 12 200]; % (unit: m)the distance from the boundary of roads to the cell limit at y=50, 100, 150
% only the middle 3 points are needed
boundaryPoints = interp1(shapePoints(:,2), shapePoints(:,1),-0.5+(1:1:400),'spline');
                        
toll_barrier_state = zeros(70,B); % track vehicle departing from the tollbooth with historical info
toll_barrier_config = [3,3,3,3,3,3,3,3; 10,10,10,10,10,10,10,10];
% line 1 for vehicle types: 1, small, 2, medium, 3, large
% line 2 for delay caused by charge mechanisms: 10, conventional, 5, exact exchange, 2,
% electronic
flow_total = 30; % total flow
flow_instant = zeros(901,1); % number of vehicles per 15 minutes
% distribute flow into each second
for i=1:flow_total
    ind = floor(rand()*900) + 1;
    flow_instant(ind) = flow_instant(ind) + 1;
end

vehicle_array = []; % colomns 1, posx, 2, posy, 3, speed, 4, rad, 5 type
for i=1:900 % one simulation per second;
    [toll_barrier_state, flow_queue] = updateTollStation(flow_total, flow_instant(i), toll_barrier_state, toll_barrier_config);
    flow_instant(i+1) = flow_queue + flow_instant(i+1);
    
    vehicle_number = size(vehicle_array,1);
    
    % detect position for collision and merge completion
    for j = 1:vehicle_number
        % Gaspard
    end
    
    % insert new cars into the traffic
    vehicle_array = [vehicle_array; addNewVehicle(toll_barrier_state(1,:))];
    vehicle_number = size(vehicle_array,1);
    
    % make and store decision for each driver
    decision_array = zeros(vehicle_number,2); % colomn 1: acc_forward, 2: acc_side
    for j = 1:vehicle_number
        
    end
end
