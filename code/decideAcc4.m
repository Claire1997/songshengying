function[acc_v] = decideAcc4(i)
global vehicle_array % colomns 1, posx, 2, posy, 3, speed, 4, rad, 5 type
global vehicle_number
global boundaryPoints
global test_acc
%global v_max
global width_veh
global length_veh
global dt

DeBug_Pos_i = vehicle_array(i,2);
acc_max = 2;
acc_brake = 8;
Speed_v = [0;vehicle_array(i,3)];
distance_foward_max = 200;Speed_foward=0;
vehicle_other_v = zeros(40,4);
criticle_limite_intervehicle = 3;

acc_v = zeros(2,1);
foward_flag = 0; %can we go foward?

% vehicule restriction
for j = 1: vehicle_number
    if i ~= j && vehicle_array(j,5) > 0  
        Speed_j = [0;vehicle_array(j,3)];
        Speed_j_v = (Speed_j - Speed_v);
        vehicle_other_v(j,3:4) = Speed_j_v;
        Pos_j_v = (vehicle_array(j,1:2)- vehicle_array(i,1:2))';
        Pos_j_future_v = Pos_j_v + Speed_j_v * dt;
        vehicle_other_v(j,1:2) = Pos_j_future_v';
        

        if Pos_j_v(2) > 0 
            if abs(Pos_j_future_v(1)) < 1 +...
                    1/2 *( width_veh(vehicle_array(i,5))+...
                    width_veh(vehicle_array(j,5)))
                if Pos_j_future_v(2) - 1/2 *( ...
                        length_veh(vehicle_array(i,5))+...
                        length_veh(vehicle_array(j,5))) - ...
                        criticle_limite_intervehicle < distance_foward_max
                    distance_foward_max = Pos_j_future_v(2) - ...
                        1/2 *( length_veh(vehicle_array(i,5))+...
                        length_veh(vehicle_array(j,5))) - ...
                        criticle_limite_intervehicle;
                    Speed_foward = Speed_j_v(2) + Speed_v(2);
                end
            end
        end
    end
end

boundaryPoints_left = zeros(2,200);
boundaryPoints_left(2,:) = 1:200;
boundaryPoints_left(2,:) = boundaryPoints_left(2,:)- ...
    vehicle_array(i,2)*ones(1,200);
boundaryPoints_left(1,:) = boundaryPoints(:,2)- vehicle_array(i,1);

boundaryPoints_right = zeros(2,200);
boundaryPoints_right(2,:) = 1:200;
boundaryPoints_right(2,:) = boundaryPoints_right(2,:) - vehicle_array(i,2);
boundaryPoints_right(1,:) = boundaryPoints(:,1)- vehicle_array(i,1);

   [~,isPositiveLeft] = find(boundaryPoints_left(1,:) > 0 );
   [~,isPositiveRight] = find(boundaryPoints_right(1,:) > 0 );
   index_left = intersect(find(boundaryPoints_left(1,isPositiveLeft) > ...
       - width_veh(vehicle_array(i,5))/2), ...
       find(boundaryPoints_left(1,isPositiveLeft) <...
       width_veh(vehicle_array(i,5))/2 ));
   index_right = intersect(find(boundaryPoints_right(1,isPositiveRight) > ...
       - width_veh(vehicle_array(i,5))/2), ...
       find(boundaryPoints_right(1,isPositiveRight) < ...
       width_veh(vehicle_array(i,5))/2 ));
   if isempty(index_left) == 0
       distance_boundary = min( boundaryPoints_left(2,index_left));
   elseif isempty(index_right) == 0
       distance_boundary = min( boundaryPoints_right(2,index_right));
   else distance_boundary = 200;
   end
 
   if distance_foward_max > distance_boundary
       distance_foward_max = distance_boundary;
       Speed_foward = 0;
   end
   
   if distance_foward_max - criticle_limite_intervehicle - 25 < 0 &&...
           distance_foward_max - criticle_limite_intervehicle > 5
        foward_flag = -1;
        Speed_future_v(2) = sqrt(2 * acc_max * distance_foward_max + ...
            Speed_foward^2 - 10);
        acc_v(2) = Speed_future_v(2) - Speed_v(2);
   elseif Speed_v(2)^2 -Speed_foward^2< ...
           (distance_foward_max -2*criticle_limite_intervehicle) * 2 * ...
           acc_brake/2
        Speed_future_v(2) = sqrt(2 * acc_max * distance_foward_max +...
            Speed_foward^2);
        acc_v(2) = Speed_future_v(2) - Speed_v(2);
        if acc_v(2) > acc_max
            acc_v(2) = acc_max;
        end
        acc_v(1) = 0;
        foward_flag = 1;
        
        test_acc = [acc_v(1),acc_v(2),0,0,0,0];
   end
   
   turn_flag =0;
   % second part
  if(foward_flag == 0 || foward_flag == -1) && (Speed_foward == 0 || ...
          distance_foward_max < 10)
      Pos_future_v = [-4;0];
      count1 = 0; count2 =0;
      for j = 1: vehicle_number
        if i ~= j && vehicle_array(j,5) > 0  
            if (~isCollideSimple(Pos_future_v,vehicle_other_v(j,1:2),...
                    vehicle_array(i,5),vehicle_array(j,5),5)) &&...
                    (~isOutBoundary([(Pos_future_v(1) + vehicle_array(i,1))...
                    ;(Pos_future_v(2)+ vehicle_array(i,2) + ...
                    vehicle_array(i,3) + vehicle_array(i,3)^2/2/acc_brake+1)],...
                    vehicle_array(i,5))) && (Speed_j_v(2) >= 0)
            else 
                count1 = 1; break
            end
        end
      end
      if count1 == 1
          Pos_future_v = [4;0];
          for j = 1: vehicle_number
          if i ~= j && vehicle_array(j,5) > 0  
              if (~isCollideSimple(Pos_future_v,vehicle_other_v(j,1:2),...
                      vehicle_array(i,5),vehicle_array(j,5),5)) &&...
                      (~isOutBoundary([Pos_future_v(1) + vehicle_array(i,1);...
                      Pos_future_v(2)+ vehicle_array(i,2) + vehicle_array(i,3)...
                      + vehicle_array(i,3)^2/2/acc_brake + 1],vehicle_array(i,5))...
                      && (Speed_j_v(2) >= 0)
              else 
                 count2 = 1; break
              end
          end
          end
      end
      if count1 == 0
          turn_flag = 1;
          if Speed_v(2) == 0
             acc_v(1) =  -4;
             acc_v(2) = 1/2 * acc_max;
          else
             acc_v(1) = -4;
             acc_v(2) = 0;
          end
      elseif count2 == 0
          turn_flag = 1;
          if Speed_v(2) == 0
             acc_v(1) =  4 ;
             acc_v(2) = 1/2 * acc_max;
          else
             acc_v(1) = 4;
             acc_v(2) = 0;
          end
      else foward_flag = 0;
      end
     
  end
 
  % thrid part
  if turn_flag == 0 && foward_flag == 0
      if distance_foward_max - criticle_limite_intervehicle < 5
          acc_v(2) = -abs((Speed_foward^2 - Speed_v(2)^2)/2/...
              (distance_foward_max - criticle_limite_intervehicle));
      else acc_v(2) = -abs((Speed_foward^2 - Speed_v(2)^2)/2/...
          (distance_foward_max - criticle_limite_intervehicle - 5));
      end
      if acc_v(2) < -acc_brake
          acc_v(2) = -acc_brake;
      end
      test_acc = [0,0,0,0,0,acc_v(2)];
  end


end
