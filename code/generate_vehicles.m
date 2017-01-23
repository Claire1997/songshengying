% this code contains one simulation of the traffic
B = 8; % Tollbooth number
L = 3; % Regular lane number
global test_acc
test_acc = zeros(60,6);
global toll_barrier_config;
toll_barrier_config = [3,3,3,3,3,3,3,3; 10,10,10,10,10,10,10,10; ...
    0 0 0 0 0 0 0 0];

%cell_size = 0.5; % cutting the road into small cells of 0.25 m^2

global merge_length; % Whole merge part length
merge_length = 200;
global width_veh % vehicle size config
global length_veh
width_veh = [2 3 3];
length_veh = [4 7 10];

global boundaryPoints
global vehicle_array
global vehicle_number
shapePoints = [32 0; 32 merge_length/4;32 merge_length/2;...
    32 merge_length/4*3; 32 merge_length];
boundaryPoints = zeros(merge_length,2); 
% the second row presents the left boundary.
boundaryPoints(:,1) = interp1(shapePoints(:,2), ...
    shapePoints(:,1),-0.5+(1:1:merge_length),'spline');
             
global has_collision
has_collision = 0;
toll_barrier_state = zeros(70,B);
% track vehicle departing from the tollbooth with historical info
global small_delay
global medium_delay
global large_delay
global initial_speed

global v_max;
v_max = 15; 

small_delay = 10; % delay caused by a small vehicle to pass a booth
medium_delay = 15;
large_delay = 30;
initial_speed = 5;
% line 1 for vehicle types: 1, small, 2, medium, 3, large
% line 2 for delay caused by charge mechanisms: 
%10, conventional, 5, exact exchange, 2,
% electronic
flow_total = 600; % total flow
flow_instant = zeros(901,1); % number of vehicles per 15 minutes
% distribute flow into each second
for i=1:flow_total
    ind = floor(rand()*900) + 1;
    flow_instant(ind) = flow_instant(ind) + 1;
end

vehicle_array = zeros(flow_total,7); 
% colomns 1, posx, 2, posy, 3, speed, 4, rad, 5 type, 6 collision, 7 is_AI
vehicle_number = 0; % the total vehicle number after the simulation start.

completion_count = 0;

for i=1:70 % one simulation per second;
    [toll_barrier_state, flow_queue] = ...
        updateTollStation(flow_total, flow_instant(i), ...
        toll_barrier_state, toll_barrier_config);
    flow_instant(i+1) = flow_queue + flow_instant(i+1);
end