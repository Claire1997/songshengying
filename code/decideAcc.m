function[acc] = decideAcc(i)
% acc is the acceleration(3*1) of the vehicule i in the vehicule_array in coord.
% of the earth.

global vehicle_array % colomns 1, posx, 2, posy, 3, speed, 4, rad, 5 type
global vehicle_number
global boundaryPoints
lamda = 
L =
m =
alpha =
L2 = 
m2 = 
beta =
v_max
acc_max =

%acc of interaction
acc_inter = zeros(1,2);
acc_road = zeros(1,2);
acc_will = zeros(1,2);
temp_inter = zeros(vehicle_number,2);
for j = 1: vehicle_number
    if j == i || vehicle_array(j,5) == 0
        continue
    end
    temp_inter = temp_inter + (vehicle_array(j,3) - vehicle_array(i,3)) / norm(vehicle_array(i,1:2)-vehicle_array(j,1:2))^L * (vehicle_array(j,1:2) - vehicle_array(i,1:2));
end
acc_inter(1,:)= lamda * (vehicle_array(i,3))^m * temp_inter;

%acc of road boundary
distance_boundary_right = abs(vehicle_array(i,1) - (boundaryPoints(floor(vehicle_array(i,2)),1)+boundaryPoints(floor(vehicle_array(i,2))+1,1))/2 );
distance_boundary_left = abs(vehicle_array(i,1) - (boundaryPoints(floor(vehicle_array(i,2)),2)+boundaryPoints(floor(vehicle_array(i,2))+1,2))/2 );
critical = 2;
if distance_boundary_left < critical
    acc_road(1,1) = - alpha* distance_boundary_left^(- L2) * vehicle_array(i,3)^m2;
elseif distance_boundary_right < critical
    acc_road(1,1) = alpha* distance_boundary_right^(- L2) * vehicle_array(i,3)^m2;
end

%acc of self will
acc_will(1,2) = beta * (v_max - vehicle_array(i,3)) * acc_max;

% sum
acc = acc_inter + acc_road + acc_will;
end