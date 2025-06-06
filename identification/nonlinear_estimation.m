%% load data
% load("chirp_delayed.mat");
load("chirp_101.mat");
% theta_offset = theta(1);
% theta_scaling = 2*pi / 4.5;
% theta = (theta - theta_offset) * theta_scaling;
% phidot_chirp1 = phidot;
% I_mot_chirp1 = I_mot;
% u_chirp1 = u;
% sine_theta_chirp1 = sin(theta_chirp1);
% t_chirp1 = 0:0.01:(length(sine_theta_chirp1) * 0.01 - 0.01);
% thetadot_chirp = gradient(theta_chirp1, t_chirp1);



delay_estimate = 100;
initial_condition = [0; 0; 0;];

% data_end = length(theta);
data_end = 1900;

theta_offset = theta(1);
I_corrected = I_mot(delay_estimate+1:data_end);
theta_corrected = (theta(delay_estimate+1:data_end) -  theta_offset) * 2*pi/4.5;
phidot_corrected = phidot(delay_estimate+1:data_end);

Ts = 0.01;

theta_corrected = lowpass(theta_corrected, 10, 500);


y = [theta_corrected, phidot_corrected];
u = I_corrected;                          

% N = length(u);
% split_point = floor(2 * N / 3);  
% 
% u_train = u(1:split_point);
% y_train = y(1:split_point, :);
u_train = u;
y_train = y;
% 
% u_val = u(split_point+1:end);
% y_val = y(split_point+1:end, :);

%% identification and options
data_id = iddata(y_train, u_train, 'Ts', 0.01);
Ts = 0.01;

Order = [2 1 3];   % [#outputs, #inputs, #states]
Ts = 0.01;              
kt = 0.591;
mu_phi = 6.7265e-04;
mu_theta = 0.1175;
J_phi = 0.0033;
J_theta = 1;
g = 9.81;
M = 1.108;
L = 0.183;

mgL = 1.029;

% params_nonlin_init = {'J_theta', 0.89; 'mu_theta', 0.33; 'J_phi', 0.00492; 'mu_phi', 0.007535;
%     'kt', -0.9648; 'mgL', 1.353};

parameters = {J_theta, mu_theta, J_phi, mu_phi, kt, mgL};

nlgr = idnlgrey('reaction_pendulum_model', Order, parameters, initial_condition);
% nlgr = setpar(nlgr,'Minimum',{eps(0) eps(0) eps(0) eps(0) eps(0) eps(0) });
% hahaha
nlgr = setpar(nlgr,'Fixed',{false false false false false false});
data = iddata(y_train, u_train, 'Ts', 0.01);


opt = nlgreyestOptions;
opt.SearchOptions.MaxIterations = 100;
% opt.Display = "Full";

estimated_model = nlgreyest(data, nlgr, opt)


%% results and plotting

figure;
compare(data,estimated_model,compareOptions('InitialCondition', 'model'))
getpvec(estimated_model)