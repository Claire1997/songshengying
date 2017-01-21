function[]=showVehicule()
global boundaryPoints
global vehicle_number
global width_veh
global vehicle_array
global length_veh
    figure
    plot(boundaryPoints(:,1),1:200,boundaryPoints(:,2),1:200);
    axis([-100 100 0 200])
    pic = imread('./blue.png');
    for t = 1:vehicle_number
         if vehicle_array(t,5) > 0
            hold on
            pic1 = imrotate(pic, vehicle_array(t,4));
            imagesc([vehicle_array(t,1)-width_veh(vehicle_array(t,5))/2, vehicle_array(t,1)+width_veh(vehicle_array(t,5))/2],[vehicle_array(t,2)-length_veh(vehicle_array(t,5))/2 , vehicle_array(t,2)+length_veh(vehicle_array(t,5))/2],pic1);
         end
    end
end