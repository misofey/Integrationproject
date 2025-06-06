function [outputArg1,outputArg2] = nonlinear_connected(x, u)

persistent params, est_mot

if isempty(est_mot)
    load("motor_ss.mat")
end


I_dot = est_mot.A * 

dx = [x(3); ...
    (kt/ J_phi)*u(1) - (mu_phi/ J_phi)*x(2) + (mu_phi/ J_phi)*x(3); ...
    (mgL/ J_theta)*sin(x(1)) - ((mu_theta + mu_phi)/ J_theta)*x(3) + (mu_phi/ J_theta)*x(2) - (kt/ J_theta)*u(1) ...
    ];
y = [x(1); x(2)];
end

