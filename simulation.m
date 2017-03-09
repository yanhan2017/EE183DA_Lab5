maxX = 100;
maxY = 100;
Xtarget = 90;
Ytarget = 5;
Xinitial = 1;
Yinitial = 1;
obsx = 3*ones(1,90);
obsy = 1:90;
obs = [obsx;obsy];
obs = obs.';
 
P_factor = 0.5;
vel = 0.20;
v = zeros(3,1); %sensor noise

%Gaussian sensor noise standard deviation
sensor1 = 0.05;
sensor2 = 0.05;
gyro = 0.005;

path = findpath(maxX,maxY,Xtarget,Ytarget,Xinitial,Yinitial,obs);
len = length(path(:,1));
actual_path = zeros(2,len);

x = zeros(6,1);
x(4) = Xinitial;
x(5) = Yinitial;
x_next = x;

for k = 0:len-1
    x_next = x;
    x_next(4) = path(len-k,1);
    x_next(5) = path(len-k,2);
    c = command(x, x_next);
    turn = c(1);
    t_a = c(2);
    t_T = c(4);
    theta = x(6);
    vx = x(1);
    vy = x(2); 
    
    v(1) = sensor1 * randn(1,1);
    v(2) = sensor2 * randn(1,1);
    v(3) = gyro * randn(1,1);
    
    
        if(c(1) == 1)   %turn left
            vCase = 'L';
            U(1) = vel;
            U(2) = -vel;
        end
        
        if(c(1) == 0)   %turn right
            vCase = 'R';
            U(1) = -vel;
            U(2) = +vel;
        end
        [x,P] = matrice(abs(t_a),x,theta, vx, vy, vCase, P_factor, v, U);
    
    %then go
    theta = x(6);
    vx = x(1);
    vy = x(2);
    
    v(1) = sensor1 * randn(1,1);
    v(2) = sensor2 * randn(1,1);
    v(3) = gyro * randn(1,1);
    
    vCase = 'F';
    U(1) = vel;
    U(2) = vel;
    
    [x,P] = matrice(abs(t_T),x,theta, vx, vy, vCase, P_factor, v, U);
        
   actual_path(1,k+1) = x(4);
   actual_path(2,k+1) = x(5);
end

startpt = [Xinitial; Yinitial];
endpt = [Xtarget;Ytarget];
actual_path = [startpt, actual_path];
path = [path; startpt.'];
plot(actual_path(1,:),actual_path(2,:));
hold on;
plot(path(:,1),path(:,2))
legend('actual path','planned path');
scatter(Xinitial,Yinitial);
scatter(Xtarget,Yinitial);
scatter(obs(:,1),obs(:,2));
hold off;
    

