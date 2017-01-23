function[output] = isCollideSimple(pos1,pos2,type1,type2,criticle_y)
global width_veh 
global length_veh 
if abs(pos1(1) - pos2(1)) < 1/2*(width_veh(type1) + width_veh(type2)) &&...
        abs(pos1(2) - pos2(2)) < ...
        1/2*(length_veh(type1) + length_veh(type2))+criticle_y 
    output =1;
else output = 0;
end