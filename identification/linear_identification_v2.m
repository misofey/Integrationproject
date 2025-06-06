load("slow_squares.mat");

delay_estimate = 100;
initial_condition = [0; 0; 0;];

theta_offset = theta(1);
I_corrected = I_mot(delay_estimate+1:end);
theta_corrected = (theta(delay_estimate+1:end) -  theta_offset) * 2 * pi / 4.5;
phidot_corrected = phidot(delay_estimate+1:end);

Ts = 0.01;

y = [theta_corrected, phidot_corrected];
u = I_corrected;                          

N = length(u);
split_point = floor(3 * N / 3);  

u_train = u(1:split_point);
y_train = y(1:split_point, :);

u_val = u(split_point+1:end);
y_val = y(split_point+1:end, :);


data_id = iddata(y_train, u_train, 'Ts', 0.01);
Ts = 0.01;
opt = greyestOptions;
opt.InitialState =  initial_condition;
% params_lin_init = {'J_theta', 0.029; 'mu_theta', 8.82e-2; 'J_phi', 2.3e-4; 'mu_phi', 1.32e-4;
%     'kt', 0.00227254; 'M', 1.104; 'L', 0.02;  'g', 9.81};

params_lin_init = {'J_theta', 0.8; 'mu_theta', 0.33; 'J_phi', 0.00492; 'mu_phi', 0.007535;
    'kt', 0.9648; 'mgL', 1.353};


linear_model = idgrey('linear_reaction_pendulum', params_lin_init, 'c');
linear_model.Structure.Parameters(1).Free = false;
% linear_model.Structure.Parameters(8).Free = false;
linear_pendulum = greyest (data_id, linear_model, opt)

optcom = compareOptions;
optcom.InitialCondition = initial_condition;
compare(data_id, linear_pendulum, optcom);

clear u;
clear theta;
clear I_mot;
clear phidot;

load("sines0_01.mat");

start_index = 2;
theta_valid = (theta - theta(1)) * 2 * pi / 4.5;
sz = size(theta_valid);
y_valid = zeros(sz(1), sz(2)+1);
y_valid(:, 1) = theta_valid;
y_valid(:, 2) = phidot;
% y_valid = [theta_valid; phidot];
y_valid = y_valid(start_index:end, :);
u_valid = I_mot(start_index:end);

validation_data = iddata(y_valid, u_valid, 'Ts', 0.01);

figure;
compare(validation_data, linear_pendulum, optcom)

