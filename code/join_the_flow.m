function [ cell_line ] = join_the_flow( toll_barrier_state_line, width_cells)
% fix vehicle sizes
L_l = 1 % Length of large vehicle 10m (20 - 1 + 1)/2
L_m = 7 % Length of medium vehicle 7m
L_s = 13 % Length of small vehicle 4m

% all vehicles freshly passed the toll join the flow
cell_line = zeros(width_cells);
D = size(toll_barrier_state_line);

for i = 1:D
    % update cell map
    for j = 1:4
        type = toll_barrier_state_line(i);
        if type == 1
            for a = 13:20
                cell_line(i * 8 - 1 - j, a) = type;
            end
        elseif type == 2
            for a = 7:20
                cell_line(i * 8 - 1 - j, a) = type;
            end
        elseif type == 3
            for a = 1:20
                cell_line(i * 8 - 1 - j, a) = type;
            end
        end
    end
    
    % update vehicle array
    
end

end

