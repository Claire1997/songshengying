% this code contains one simulation of the traffic
B = 8; % Tollbooth number
L = 3; % Regular lane number
cell_size = 0.5; % cutting the road into small cells of 0.25 m^2

% decision period is 1s, thus minimum speed taken into account is 0.5 m/s
toll_barrier_state = zeros(B,50); % track vehicle departing from the tollbooth with historical info

