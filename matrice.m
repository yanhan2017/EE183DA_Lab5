%DEFINE VARIABLES BEFORE USE
function [x ,P] = matrice(t,x,theta, vx, vy, vCase, P_factor, v, U)
A = zeros(6,6);
A(4,1) = 0;
A(5,2) = 0;
A(6,3) = 0;
A(4,4) = 1;
A(5,5) = 1;
A(6,6) = 1;
A_T = transpose(A);

B = zeros(6,2);
B(1,1) = cos(theta) / 2;
B(1,2) = cos(theta) / 2;
B(2,1) = sin(theta) / 2;
B(2,2) = sin(theta) / 2;
B(3,1) = 1 / 8.5;
B(3,2) = -B(3,1);
B(4,1) = t*B(1,1);
B(4,2) = t*B(1,2);
B(5,1) = t*B(2,1);
B(5,2) = t*B(2,2);
B(6,1) = t*B(3,1);
B(6,2) = t*B(3,2);

C = zeros(3,6);
if (vCase == 'F' || vCase == 'B')
    C(1,1) = vx / sqrt(vx*vx+vy*vy+0.00001);
    C(2,1) = vx / sqrt(vx*vx+vy*vy+0.00001);
    C(1,2) = vy / sqrt(vx*vx+vy*vy+0.00001);
    C(2,2) = vy / sqrt(vx*vx+vy*vy+0.00001);
elseif (vCase == 'L')
    C(1,3) = 8.5 / 2;
    C(2,3) = 8.5 / 2;
    C(3,3) = 1;
elseif (vCase == 'R')
    C(1,3) = -8.5 / 2;
    C(2,3) = 8.5 / 2;
    C(3,3) = 1;
end
C_T = transpose(C);

P = eye(6,6);
P = P .* P_factor;

R = eye(3,3);


z = C*x + v; % need v
% Predict
x = A*x + B*U;
P = A * P * A_T;

% Update
temp = C*P*C_T+R;
temp1 = P*C_T;
G = (P*C_T)*(C*P*C_T+R)^(-1);
x = x + G*(z-C*x);
P = (eye(6,6) - G * C) * P;
end