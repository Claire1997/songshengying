function[acc_output] = decideAcc2(i)
global vehicle_array % colomns 1, posx, 2, posy, 3, speed, 4, rad, 5 type
global vehicle_number
%global boundaryPoints
global test_acc
%global v_max
global width_veh
global length_veh
global dt
acc_max = 2;
angle = vehicle_array(i,4);
speed_old = [vehicle_array(i,3)*cos(angle+pi/2) ;vehicle_array(i,3)*sin(angle+pi/2)];
Trans = [cos(angle) -sin(angle); sin(angle) cos(angle)];
Trans_back = Trans^-1;
Speed_v = Trans * speed_old;
distance_foward_max = 200;
%vehicle_foward_v = zeros(40,4);
criticle_limite_intervehicle = 1;
acc_v = zeros(2,1);
foward_flag = 0; %can we go foward?

% vehicule restriction
for j = 1: vehicle_number
    if i ~= j && vehicle_array(j,5) > 0
        Pos_j_v = Trans * (vehicle_array(j,1:2)- vehicle_array(i,1:2))';
        angle_j = vehicle_array(j,4);
        Speed_j = [vehicle_array(j,3)*cos(angle_j+pi/2) ;vehicle_array(i,3)*sin(angle_j+pi/2)];
        Speed_j_v = Trans * (Speed_j - Speed_v);
        if Pos_j_v > 0 
            Pos_j_future_v = Pos_j_v + Speed_j_v * dt;
            if abs(Pos_j_future_v(1)) < criticle_limite_intervehicle + 1/2 *( width_veh(vehicle_array(i,5))+width_veh(vehicle_array(j,5)))
                if Pos_j_future_v(2) - 1/2 *( length_veh(vehicle_array(i,5))+length_veh(vehicle_array(j,5))) - criticle_limite_intervehicle < distance_foward_max
                    distance_foward_max = Pos_j_future_v(2) - 1/2 *( length_veh(vehicle_array(i,5))+length_veh(vehicle_array(j,5))) - criticle_limite_intervehicle;
                end
            end
        end
    end
    if Speed_v(2)^2 < distance_foward_max * 2 * acc_max
        Speed_future_v(2) = sqrt(2 * acc_max * distance_foward_max);
        acc_v(2) = Speed_future_v(2) - Speed_v(2);
        if acc_v(2) > acc_max
            acc_v(2) = acc_max;
        end
        acc_v(1) = 0;
        foward_flag = 1;
    end
end

% boundary restriction


[acc_road,~] = decideAcc(i);
acc_v = Trans_back * acc_v;
    test_acc(i,:) = [acc_v' acc_road 0 0];
    acc_output = acc_v' + acc_road;
    if norm(acc_output) > 2
        acc_output = acc_output/norm(acc_output);
    end

end