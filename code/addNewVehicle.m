function [ output_args ] = addNewVehicle( toll_barrier_state_line )
% all vehicles freshly passed the toll join the flow
% generate lines of vehicle array
D = size(toll_barrier_state_line,2);
vehicle = zeros(D, 5);
count = 0;
for i = 1:D
    if toll_barrier_state_line(i) == 1
        count = count + 1;
        vehicle(count,:) = [i * 4 - 2, 0, 5, pi/2, 1];
        % initial position: center of the lane
        % initial speed: 5 m/s
        % initial speed position: 90"
    elseif toll_barrier_state_line(i) == 2
        count = count + 1;
        vehicle(count,:) = [i * 4 - 2, 0, 5, pi/2, 2];
    elseif toll_barrier_state_line(i) == 3
        count = count + 1;
        vehicle(count,:) = [i * 4 - 2, 0, 5, pi/2, 3];
    end
end
if count > 0
        output_args = vehicle(1:count,:);
    else
        output_args = [];
end
end
