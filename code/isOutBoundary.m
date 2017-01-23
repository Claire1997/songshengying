function[isOut] = isOutBoundary(pos, type)
    global boundaryPoints
    global width_veh 
    isOut = 1;
    if pos(2) >=0 && pos(2) <= 199
        if pos(1) < 200 && pos(1) > 0
            if (pos(1) < boundaryPoints(floor(pos(2))+1,1) - width_veh(type)/2)  && (pos(1) > boundaryPoints(floor(pos(2))+1,2) + width_veh(type)/2)
                isOut = 0; 
            end
        end
    end
end