function[isOut] = isOutLimit(pos)
global merge_length
isOut = 1;
if isOutBoundary(pos) == 0
        if pos(2) < merge_length
            isOut = 0;
        end    
end
end
