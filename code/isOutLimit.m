function[isOut] = isOutLimit(pos)
isOut = 1;
if isOutBoundary(pos) == 0
        if pos(2) < 200
            isOut = 0;
        end    
end
end
