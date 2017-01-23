function [  ] = addNewVehicle( toll_barrier_state_line )
% all vehicles freshly passed the toll join the flow
% generate lines of vehicle array
global vehicle_array
global vehicle_number
global initial_speed
global toll_barrier_config;
D = size(toll_barrier_state_line,2);
vehicle = zeros(D, 7);
count = 0;
for i = 1:D
    if toll_barrier_state_line(i) == 1
        count = count + 1;
        vehicle(count,:) = [i * 4 - 2, 0, initial_speed,...
            toll_barrier_config(3,i), 1,0,0];
        % initial position: center of the lane
        % initial speed: initial_speed m/s
        % initial speed position: 90"
    elseif toll_barrier_state_line(i) == 2
        count = count + 1;
        vehicle(count,:) = [i * 4 - 2, 0, initial_speed,...
            toll_barrier_config(3,i), 2, 0, 0];
    elseif toll_barrier_state_line(i) == 3
        count = count + 1;
        vehicle(count,:) = [i * 4 - 2, 0, initial_speed,...
            toll_barrier_config(3,i), 3, 0, 0];
    end
end
if count > 0
        output_args = vehicle(1:count,:);
        vehicle_array(vehicle_number+1:vehicle_number +...
            count,:) = output_args;
        vehicle_number = vehicle_number+count;
end

end
