function[collide] = isCollide(pos1,pos2,type1,type2)
% pos including [x;y;alpha] alpha is between 0 to pi (pi/2 is vertical)
global width_veh 
global length_veh 
%width_veh = [1, 3*sqrt(2)/2]; %only use for test
%length_veh = [3,3*sqrt(2)];
%type1 = 1; type2 = 2;
%pos1 = [4.5;1.5;-pi/2]; pos2=[5.75;4.75;-pi/4];
pos1 = pos1';
pos2 = pos2';
Trans1 = [cos(pos1(3)) -sin(pos1(3)); sin(pos1(3)) cos(pos1(3))];
points1(:,1) = Trans1 * [+ width_veh(type1)/2 ;  + length_veh(type1)/2]+[pos1(1) ;pos1(2)];
points1(:,2) = Trans1 * [ - width_veh(type1)/2 ;  + length_veh(type1)/2]+[pos1(1) ;pos1(2)];
points1(:,3) = Trans1 * [ - width_veh(type1)/2 ;  - length_veh(type1)/2]+[pos1(1) ;pos1(2)];
points1(:,4) = Trans1 * [ + width_veh(type1)/2 ;  - length_veh(type1)/2]+[pos1(1) ;pos1(2)];

Trans2 = [cos(pos2(3)) -sin(pos2(3)); sin(pos2(3)) cos(pos2(3))];
points2(:,1) = Trans2 * [width_veh(type2)/2 ; + length_veh(type2)/2]+[pos2(1);pos2(2) ];
points2(:,2) = Trans2 * [- width_veh(type2)/2 ;length_veh(type2)/2]+[pos2(1);pos2(2) ];
points2(:,3) = Trans2 * [- width_veh(type2)/2 ;  - length_veh(type2)/2]+[pos2(1);pos2(2) ];
points2(:,4) = Trans2 * [width_veh(type2)/2 ; - length_veh(type2)/2]+[pos2(1);pos2(2) ];

collide = 0;
for i = 1:4
    for j = 1:4
        if i==4
            i2 = 1;
        else i2 = i+1;
        end
        if j ==4
            j2 = 1;
        else j2 = j+1;
        end
        
        collide = isCollideHelp(points1(:,i),points1(:,i2),points2(:,j),points2(:,j2));
        if collide == 1
            %warning('collode!');
            break;
        end
    end
end




