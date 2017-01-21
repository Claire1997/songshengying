function[acc] = decideAcc(i)
% acc is the acceleration(3*1) of the vehicule i in the vehicule_array in coord.
% of the earth.

global vehicle_array % colomns 1, posx, 2, posy, 3, speed, 4, rad, 5 type
global vehicle_number
global boundaryPoints
lamda = 
l =
m =

%acc of interaction
temp_inter = zeros(vehicle_number,2);
for j = 1: vehicle_number
    if j == i 
        continue
    end
    temp_inter = temp_inter + (vehicle_array(i,3) - vehicle_array(j,3)) / norm(vehicle_array(i,1:2)-vehicle_array(j,1:2))^l * (vehicle_array(j,1:2) - vehicle_array(i,1:2));
end
acc_inter= lamda * (vehicle_array(i,3))^m * temp_inter;

%acc of road boundary
distance_boundary_right = abs(vehicle_array(i,1) - boundaryPoints(floor(veh)) ) 

end