function[acc] = decideAcc2(i)
global vehicle_array % colomns 1, posx, 2, posy, 3, speed, 4, rad, 5 type
global vehicle_number
global boundaryPoints
global test_acc
%global v_max
global width_veh
global length_veh
global dt
acc_max = 2;
acc_brake = 8;
angle = vehicle_array(i,4);
speed_old = [vehicle_array(i,3)*cos(angle+pi/2) ;vehicle_array(i,3)*sin(angle+pi/2)];
Trans = [cos(angle) -sin(angle); sin(angle) cos(angle)];
Trans_back = Trans^-1;
Speed_v = Trans * speed_old;
distance_foward_max = 200;Speed_foward=0;
vehicle_other_v = zeros(40,4);
criticle_limite_intervehicle = 1;
deltaL_min = 1.4;

acc_v = zeros(2,1);
foward_flag = 0; %can we go foward?
boundaryPoints_left = zeros(2,200);
boundaryPoints_left(2,:) = 1:200;
boundaryPoints_left(2,:) = boundaryPoints_left(2,:)- vehicle_array(i,2)*ones(1,200);
boundaryPoints_left(1,:) = boundaryPoints(:,1)- vehicle_array(i,1);

boundaryPoints_right = zeros(2,200);
boundaryPoints_right(2,:) = 1:200;
boundaryPoints_right(2,:) = boundaryPoints_right(2,:) - vehicle_array(i,2);
boundaryPoints_right(1,:) = boundaryPoints(:,2)- vehicle_array(i,1);
boundaryPoints_v_right = Trans * boundaryPoints_right;
boundaryPoints_v_left = Trans * boundaryPoints_left;
% vehicule restriction
for j = 1: vehicle_number
    if i ~= j && vehicle_array(j,5) > 0
        angle_j = vehicle_array(j,4);
        
        Speed_j = [vehicle_array(j,3)*cos(angle_j+pi/2) ;vehicle_array(i,3)*sin(angle_j+pi/2)];
        Speed_j_v = Trans * (Speed_j - Speed_v);
        vehicle_other_v(j,3:4) = Speed_j_v;
        Pos_j_v = Trans * (vehicle_array(j,1:2)- vehicle_array(i,1:2))';
        Pos_j_future_v = Pos_j_v + Speed_j_v * dt;
        vehicle_other_v(j,1:2) = Pos_j_future_v';
        

        if Pos_j_v > 0 
            if abs(Pos_j_future_v(1)) < criticle_limite_intervehicle + 1/2 *( width_veh(vehicle_array(i,5))+width_veh(vehicle_array(j,5)))
                if Pos_j_future_v(2) - 1/2 *( length_veh(vehicle_array(i,5))+length_veh(vehicle_array(j,5))) - criticle_limite_intervehicle < distance_foward_max
                    distance_foward_max = Pos_j_future_v(2) - 1/2 *( length_veh(vehicle_array(i,5))+length_veh(vehicle_array(j,5))) - criticle_limite_intervehicle;
                    Speed_foward = Speed_j_v(2);
                end
            end
        end

    end
end
   [~,isPositiveLeft] = find(boundaryPoints_v_left(1,:) > 0 );
   [~,isPositiveRight] = find(boundaryPoints_v_right(1,:) > 0 );
   index_left = intersect(find(boundaryPoints_v_left(2,isPositiveLeft) > - width_veh(vehicle_array(i,5))/2), find(boundaryPoints_v_left(2,isPositiveLeft) <  width_veh(vehicle_array(i,5))/2 ));
   index_right = intersect(find(boundaryPoints_v_right(2,isPositiveRight) > - width_veh(vehicle_array(i,5))/2), find(boundaryPoints_v_right(2,isPositiveRight) <  width_veh(vehicle_array(i,5))/2 ));
   if isempty(index_left) == 0
       distance_boundary = min( boundaryPoints_v_left(1,index_left));
   elseif isempty(index_right) == 0
       distance_boundary = min( boundaryPoints_v_right(1,index_right));
   else distance_boundary = 200;
   end
   
   if distance_foward_max > distance_boundary
       distance_foward_max = distance_boundary;
       Speed_foward = 0;
   end
   
   if distance_foward_max - criticle_limite_intervehicle - 15 < 0 && distance_foward_max - criticle_limite_intervehicle > 5
       foward_flag = -1;
   
   elseif Speed_v(2)^2 -Speed_foward^2< (distance_foward_max - criticle_limite_intervehicle - 4) * 2 * acc_brake/2
        Speed_future_v(2) = sqrt(2 * acc_max * distance_foward_max + Speed_foward^2);
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
  if(foward_flag == 0 && foward_flag == -1)
        if Speed_v(2) == 0
           delta_y_max = Speed_v(2)*dt + 1/4*acc_max*dt^2;
           delta_x_max = Speed_v(1)*dt +1/4 * acc_max*dt^2;
        else
            delta_y_max = Speed_v(2)*dt;
            delta_x_max = Speed_v(1)*dt +1/2 * min(acc_max,(Speed_v(2)-Speed_v(1))/dt)*dt^2;
        end     
        alpha_min_r = 10;
        alpha_min_l = 10;

     x_boundary_cross_left = interp1(boundaryPoints_v_left(:,1), boundaryPoints_v_left(:,2),delta_y_max,'spline');
     x_boundary_cross_right = interp1(boundaryPoints_v_left(:,1), boundaryPoints_v_left(:,2),delta_y_max,'spline');
     if x_boundary_cross_left > - delta_x_max
         alpha_max_left = atan2(delta_y_max,x_boundary_cross_left - pi/2);
     else alpha_max_left = pi/2;
     end
     if x_boundary_cross_right < delta_x_max
         alpha_min_right = atan2(delta_x_max,x_boundary_cross_right -pi/2);
     else alpha_min_right = -pi/2;
     end
         
     
     count = -1;
     for alpha_degree = 0:5:45
          alpha = alpha_degree * pi / 180;
          if alpha > alpha_max_left || alpha< alpha_min_right
            continue
          end
       count = 0;
        for j = 1: vehicle_number
            if i ~= j && vehicle_array(j,5) > 0 && vehicle_other_v(j,2) > 0 && vehicle_other_v(j,2)-1/2*length_veh(vehicle_array(j,5)) <= delta_y_max && abs(vehicle_other_v(j,1))<=delta_x_max+1/2*width_veh(vehicle_array(j,5))

               count = count +1;
                %deltaL = abs(vehicle_other_v(j,1)*tan(pi/2 + alpha) - vehicle_other_v(j,2))/sqrt(1+tan(pi/2+alpha)^2);
                if  abs(vehicle_other_v(j,1)*tan(pi/2 + alpha) - vehicle_other_v(j,2))/sqrt(1+tan(pi/2+alpha)^2) > deltaL_min * length_veh(vehicle_array(j,5)) 
                    alpha_min_r = alpha; 
                end
                if  abs(vehicle_other_v(j,1)*tan(pi/2 - alpha) - vehicle_other_v(j,2))/sqrt(1+tan(pi/2-alpha)^2) > deltaL_min * length_veh(vehicle_array(j,5)) 
                    alpha_min_l = alpha;
                end
                
            end
           
           if count == 0 
               break %no vehicule in dangerous area
           end
        end
     end
     
     if alpha_min_l ~= 10 || alpha_min_r ~= 10||count ==0
         if count == 0
            
            
            if alpha_min_right > -pi/2 && alpha_max_left > pi/2
                alpha_min = pi/4;
                %alpha_min = 3/4*pi/4 + 1/4*alpha_min_right;
            elseif  alpha_min_right < -3*pi/8 && alpha_max_left < pi/2
                alpha_min = -pi/4;
                %alpha_min = -3/4*pi/4 + 1/4*alpha_max_left;
            else alpha_min = 1/2 * (min(alpha_max_left,pi/4) + max(alpha_min_right,-pi/4));
            end
         elseif alpha_min_l < alpha_min_r 
             alpha_min =  alpha_min_l;
         else 
             alpha_min = - alpha_min_r;
         end
         Speed_future_v(1) = cos(alpha_min) * (norm(Speed_v) + 1/2*acc_max);
         Speed_future_v(2) = sin(alpha_min) * (norm(Speed_v) + 1/2*acc_max);
         acc_v(2) = Speed_future_v(2) - Speed_v(2);
         acc_v(1) = Speed_future_v(1) - Speed_v(1);
         test_acc = [0,0,acc_v(1),acc_v(2),0,0];
         turn_flag = 1;
     end
     
  end
 
  % thrid part
  if turn_flag == 0 && foward_flag == 0
      if distance_foward_max < distance_foward_max - 2*criticle_limite_intervehicle-5
          acc_v(2) = -abs((Speed_foward^2 - Speed_v(2)^2)/2/(distance_foward_max - criticle_limite_intervehicle));
      else acc_v(2) = -abs((Speed_foward^2 - Speed_v(2)^2)/2/(distance_foward_max - 2*criticle_limite_intervehicle-5));
      end
      acc_v = acc_v * 2;
      if acc_v(2) < -acc_brake
          acc_v(2) = -acc_brake;
      end
      test_acc = [0,0,0,0,0,acc_v(2)];
  end
 acc = Trans_back * acc_v;
% boundary restriction


% [acc_road,~] = decideAcc(i);
% acc_v = Trans_back * acc_v;
%     test_acc(i,:) = [acc_v' acc_road 0 0];
%     acc_output = acc_v' + acc_road;
%     if norm(acc_output) > 2
%         acc_output = acc_output/norm(acc_output);
%     end

end