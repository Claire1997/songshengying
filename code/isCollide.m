function[collide] = isCollide(pos1,pos2,type1,type2)
% pos including [x;y;alpha] alpha is between 0 to pi (pi/2 is vertical)
global width_veh 
global length_veh 
%width_veh = [1, 3*sqrt(2)/2]; %only use for test
%length_veh = [3,3*sqrt(2)];
%type1 = 1; type2 = 2;
%pos1 = [4.5;1.5;pi/2]; pos2=[4.75;4.75;pi/4];
pos1 = pos1';
pos2 = pos2';
dist = norm(pos2(1:2,:)-pos1(1:2,:));
y2 = (pos2(1)-pos1(1))*sin(pos1(3)) + (pos2(2)-pos1(2))*cos(pos1(3));
x2 = (pos2(1)-pos1(1))*cos(pos1(3)) - (pos2(2)-pos1(2))*sin(pos1(3));% x2,y2 is the position of pos2 in the coord of pos1

if abs(abs(pos2(3)-pos1(3))-pi/2)<0.002
    notcollide3 = dist > max((length_veh(type1)+length_veh(type2))/2,(width_veh(type1)+width_veh(type2))/2);
    collide = ~notcollide3;
elseif abs(pos2(3)-pos1(3)) < 0.002
    notcollide4 = dist > (width_veh(type1)+width_veh(type2))/2;
    collide = ~notcollide4;
else
    notcollide1 = (abs((abs(x2) - width_veh(type1)/2 - width_veh(type2)/2/cos(pos2(3)-pos1(3)))/tan(pos2(3)-pos1(3))) - (length_veh(type1)/2-y2) > 0.002);
    notcollide2 = (abs((abs(x2) - width_veh(type1)/2 - width_veh(type2)/2/cos(pos2(3)-pos1(3)))/sin(pos2(3)-pos1(3))) -( length_veh(type2)/2 - width_veh(type2)/2*tan(pos2(3)-pos1(3))) > 0.002);

    collide = ~(notcollide1||notcollide2);
    if collide == 1
        warning('collide!');
    end
end
