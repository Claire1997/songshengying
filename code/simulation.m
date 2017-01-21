% this code contains one simulation of the traffic
B = 8; % Tollbooth number
L = 3; % Regular lane number

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
shapePoints = [32 0; 24 merge_length/4;20 merge_length/2;16 merge_length/4*3; 12 merge_length]; % (unit: m)the distance from the boundary of roads to the cell limit at y=50, 100, 150
boundaryPoints = zeros(merge_length,2); % the second row presents the left boundary.
boundaryPoints(:,1) = interp1(shapePoints(:,2), shapePoints(:,1),-0.5+(1:1:merge_length),'spline');
             
global has_collision

toll_barrier_state = zeros(70,B); % track vehicle departing from the tollbooth with historical info
toll_barrier_config = [3,3,3,3,3,3,3,3; 10,10,10,10,10,10,10,10];
global small_delay
global medium_delay
global large_delay
global initial_speed
small_delay = 10; % delay caused by a small vehicle to pass a booth
medium_delay = 15;
large_delay = 30;
initial_speed = 5;
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

vehicle_array = zeros(flow_total,7); % colomns 1, posx, 2, posy, 3, speed, 4, rad, 5 type, 6 collision, 7 is_AI
vehicle_number = 0; % the total vehicle number after the simulation start.

completion_count = 0;
for i=1:900 % one simulation per second;
    [toll_barrier_state, flow_queue] = updateTollStation(flow_total, flow_instant(i), toll_barrier_state, toll_barrier_config);
    flow_instant(i+1) = flow_queue + flow_instant(i+1);
         
    % detect position for collision and merge completion
    for j = 1:vehicle_number
        if vehicle_array(j,5) > 0 && vehicle_array(j,6) ~= 1
            % check if the merge is completed
            if vehicle_array(j,2) > merge_length
                vehicle_array(j,5) = -1;
                completion_count = completion_count + 1;
            else
                % check if out of boundary
                isOut = isOutBoundary([vehicle_array(j,1),vehicle_array(j,2)]);
                if isOut == 1 % collision with road
                    has_collision = has_collision||isOut;
                    vehicle_array(j,6) = 1;
                    vehicle_array(j,3) = 0; % set speed to 0
                end
                % check if collision with other cars
                for a = 1:vehicle_number
                    if a ~= j
                       isCollide = isCollide([vehicle_array(j,1),vehicle_array(j,2)],[vehicle_array(a,1),vehicle_array(a,2)],vehicle_array(j,5),vehicle_array(a,5));
                       if isCollide == 1
                           % collision with car
                           has_collision = has_collision||isCollide;
                           vehicle_array(j,3) = 0;
                           vehicle_array(a,3) = 0;
                           vehicle_array(j,6) = 1;
                           vehicle_array(a,6) = 1;
                       end
                    end
                end
            end
        end
    end

    
    % insert new cars into the traffic
    addNewVehicle(toll_barrier_state(1,:));
    
    
    % make and store decision for each driver
    decision_array = zeros(vehicle_number,2); % colomn 1: acc_x, 2: acc_y
    for j = 1:vehicle_number
        if vehicle_array(j,5) > 0 && vehicle_array(j,6) ~= 1
            decision_array(j,:) = decideAcc(j);
            acc = decision_array(j,:);
            angle = vehicle_array(j,4);
            speed_old = [vehicle_array(j,3)*cos(angle) ;vehicle_array(j,3)*sin(angle)];
            speed = [speed_old(1) +  acc(1);speed_old(2) +  acc(2)];
            
            Trans = [cos(angle) -sin(angle); sin(angle) cos(angle)];
            Trans_back = Trans^-1;
            speed_old_v = Trans * speed_old;
            speed_v= Trans * speed;
                    %speed of vehicule in coord. vehicule.
            acc_v = Trans * acc;
            
           if speed_v(2) <= 0
                vehicle_array(j,3) = 0;
                continue
           end
            
           if speed_v(2) > abs(speed_v(1)) %45 degree            
           elseif speed_v(1) > 0
               speed_v(1) = speed_v(2);
               acc_v(1) = speed_v(1) - speed_old_v(1);
               acc = Trans_back * acc_v;
               speed = Trans_back *  speed_v;
           elseif speed_x < 0
               speed_v(1) = -speed_v(2);
               acc_v(1) = speed_v(1) - speed_old_v(1);
               acc = Trans_back * acc_v;
               speed = Trans_back *  speed_v;
           end 
           vehicle_array(j,4) = tan(speed(2)/speed(1));
           vehicle_array(j,1) = 1/2 * acc(1)+ speed_old(1) + vehicle_array(j,1);
           vehicle_array(j,2) = 1/2 * acc(2)+ speed_old(2) + vehicle_array(j,2);
           vehicle_array(j,3) = norm(speed);
        end
    end
end