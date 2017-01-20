function[cells, flags] = updateCells(cells)
    for i = 1:size(cells,1)
        for j = 1:size(cells,2)
            if cells(i,j,1) > 0
                
                % can turn left?
                if cells(i,j-2) == 0 
                    if sum(sum(cells(i-vmax:i-1,j-2,1))) > 0
                        pTurnLeft = 0.02;
                        
                    elseif cells(i-1,j-1,1) == 0
                        pTurnLeft = 0.5;
                    end 
                end
                 
                
                 
            end
        
        
        end
    end
end 