function[isOut] = isOutBoundary(pos)
    global boundaryPoints
    isOut = 1;
    if pos(2) >=0
        if pos(1) < (boundaryPoints(floor(pos(1)))+boundaryPoints(floor(pos(1))+1))/2 && pos(1) >=0
            isOut = 0; 
        end
    end
end