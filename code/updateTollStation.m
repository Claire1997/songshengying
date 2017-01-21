function [toll_barrier_state, flow_queue] = updateTollStation(flow_total, flow_instant, toll_barrier_state, toll_barrier_config)
global small_delay
global medium_delay
global large_delay
% B for lane number, D for time stamp
B = size(toll_barrier_state,1);
D = size(toll_barrier_state,2);
critical_flow = 300;
% aging the info
i = B;
while i > 1
    for j = 1:D
        toll_barrier_state(i,j) = toll_barrier_state(i-1, j);
    end
    i = i-1;
end
for j = 1:D
    toll_barrier_state(1,j) = 0;
end

% populating newest state
if flow_total > critical_flow
    % queue before toll station, continuous vehicle flow generated
    for i = 1:D
        % respect time interval of vehicles
        for j = 1:B
            if toll_barrier_state(j,i) == 1
                if j >= small_delay + toll_barrier_config(2,i)
                    % toll ready for next vehicle
                    tmp = rand(1);
                    if toll_barrier_config(1,i) == 3
                        if tmp > 0.8 % 20% large vehicle
                            toll_barrier_state(1,i) = 3;
                        elseif tmp > 0.5 % 30% medium vehicle
                            toll_barrier_state(1,i) = 2;
                        else
                            toll_barrier_state(1,i) = 1;
                        end
                    elseif toll_barrier_config(1,i) == 2
                        if tmp > 0.625
                            toll_barrier_state(1,i) = 2;
                        else
                            toll_barrier_state(1,i) = 1;
                        end
                    elseif toll_barrier_config(1,i) == 1
                        toll_barrier_state(1,i) = 1;
                    else
                        warning('Wrong toll_barrier_config');
                    end
                else
                    break
                end % j < 30, port not ready
            elseif toll_barrier_state(j,i) == 2
                if j >= medium_delay + toll_barrier_config(2,i)
                    % toll ready for next vehicle
                    tmp = rand(1);
                    if toll_barrier_config(1,i) == 3
                        if tmp > 0.8 % 20% large vehicle
                            toll_barrier_state(1,i) = 3;
                        elseif tmp > 0.5 % large_delay% medium vehicle
                            toll_barrier_state(1,i) = 2;
                        else
                            toll_barrier_state(1,i) = 1;
                        end
                    elseif toll_barrier_config(i,1) == 2
                        if tmp > 0.625
                            toll_barrier_state(1,i) = 2;
                        else
                            toll_barrier_state(1,i) = 1;
                        end
                    else
                        warning('Wrong toll_barrier_config');
                    end
                else
                    break
                end % j < 40, port not ready
            elseif toll_barrier_state(j,i) == 3
                if j >= large_delay + toll_barrier_config(2,i)
                    % toll ready for next vehicle
                    tmp = rand(1);
                    if toll_barrier_config(1,i) == 3
                        if tmp > 0.8 % 20% large vehicle
                            toll_barrier_state(1,i) = 3;
                        elseif tmp > 0.5 % 30% medium vehicle
                            toll_barrier_state(1,i) = 2;
                        else
                            toll_barrier_state(1,i) = 1;
                        end
                    else
                        warning('Wrong toll_barrier_config');
                    end
                else
                    break
                end % j < 50, port not ready
            end
        end
        if j == B % port ready
            tmp = rand(1);
            if toll_barrier_config(1,i) == 3
                if tmp > 0.8 % 20% large vehicle
                    toll_barrier_state(1,i) = 3;
                elseif tmp > 0.5 % 30% medium vehicle
                    toll_barrier_state(1,i) = 2;
                else
                    toll_barrier_state(1,i) = 1;
                end
            else
                warning('Wrong toll_barrier_config');
            end
        end
    end
    flow_queue = 0;
else
    % toll station is idle
    count = 0;
    if flow_instant ~= 0
        % allocate tolls for vehicles
        tolls_available_ind = zeros(B);
        for i = 1:D
            % respect time interval of vehicles
            for j = 1:B
                if toll_barrier_state(j,i) == 1
                    if j >= small_delay + toll_barrier_config(2,i)
                        % toll ready for next vehicle
                        count = count + 1;
                        tolls_available_ind(count) = i;
                    else
                        break
                    end % j < large_delay, port not ready
                elseif toll_barrier_state(j,i) == 2
                    if j >= medium_delay + toll_barrier_config(2,i)
                        % toll ready for next vehicle
                        count = count + 1;
                        tolls_available_ind(count) = i;
                    else
                        break
                    end % j < 40, port not ready
                elseif toll_barrier_state(j,i) == 3
                    if j >= large_delay + toll_barrier_config(2,i)
                        % toll ready for next vehicle
                        count = count + 1;
                        tolls_available_ind(count) = i;
                    else
                        break
                    end % j < 50, port not ready
                end
            end
            if j == B % port ready
                % toll ready for next vehicle
                count = count + 1;
                tolls_available_ind(count) = i;
            end
        end % traversing D and B
        for i=1:min(count,flow_instant)
            tmp = rand(1);
            if toll_barrier_config(1,tolls_available_ind(i)) == 3
                if tmp > 0.8 % 20% large vehicle
                    toll_barrier_state(1, tolls_available_ind(i)) = 3;
                elseif tmp > 0.5 % 30% medium vehicle
                    toll_barrier_state(1, tolls_available_ind(i)) = 2;
                else
                    toll_barrier_state(1, tolls_available_ind(i)) = 1;
                end
            elseif toll_barrier_config(1,tolls_available_ind(i)) == 2
                if tmp > 0.625
                    toll_barrier_state(1, tolls_available_ind(i)) = 2;
                else
                    toll_barrier_state(1, tolls_available_ind(i)) = 1;
                end
            elseif toll_barrier_config(1,tolls_available_ind(i)) == 1
                toll_barrier_state(1, tolls_available_ind(i)) = 1;
            else
                warning('Wrong toll_barrier_config');
            end
        end
        flow_queue = max(flow_instant - count, 0);
    else % flow_instant ~= 0
        flow_queue = 0;
    end
end

end