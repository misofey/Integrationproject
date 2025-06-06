%% data loading

load("slow_squares.mat");
theta_offset = theta(1);
theta_scaling = 2*pi / 4.5;
theta_squares = (theta - theta_offset) * theta_scaling;
phidot_squares = phidot;
I_mot_squares = I_mot;
u_square = u;
sine_theta_squares = sin(theta_squares);

initial_condition_squares = [0; 0; 0];

load("chirp_102.mat");
theta_offset = theta(1);
theta_scaling = 2*pi / 4.5;
theta_chirp1 = (theta - theta_offset) * theta_scaling;
phidot_chirp1 = phidot;
I_mot_chirp1 = I_mot;
u_chirp1 = u;
sine_theta_chirp1 = sin(theta_chirp1);
t_chirp1 = 0:0.01:(length(sine_theta_chirp1) * 0.01 - 0.01);
thetadot_chirp = gradient(theta_chirp1, t_chirp1);


%% identification
Ts = 0.01;

% u_train = [I_mot_squares, sine_theta_square
% y_train = [theta_squares, phidot_squares];

u_train = [I_mot_chirp1, sine_theta_chirp1];
y_train = [theta_chirp1, phidot_chirp1];

data_start = 280;
initial_condition_start = [theta_chirp1(data_start); phidot_chirp1(data_start); thetadot_chirp(data_start)];

u_train = u_train(data_start:end, :);
y_train = y_train(data_start:end, :);

data_id = iddata(y_train, u_train, Ts);
opt = greyestOptions;
opt.InitialState =  initial_condition_start;
opt.SearchOptions.MaxIterations = 200;

params_lin_init = {'J_theta', 0.5; 'mu_theta', 0.9; 'J_phi', 0.00492; 'mu_phi', 0.007535;
    'kt', 0.9648; 'mgL', 1.8};

lpv_model = idgrey(@lpv_pendulum, params_lin_init, 'c');
lpv_model.InputDelay = [0.01; 0.00];
% lpv_model.Structure.Parameters(1).Free = false;

lpv_result = greyest(data_id, lpv_model, opt)



optcom = compareOptions;
optcom.InitialCondition = initial_condition_start;
compare(data_id, lpv_result, optcom)

%% validation

% load("sines0_01.mat");
% 
% start_index = 2;
% theta_valid = (theta - theta(1)) * 2 * pi / 4.5;
% theta_sin_valid = sin(theta_valid);
% sz = size(theta_valid);
% y_valid = zeros(sz(1), sz(2)+1);
% y_valid(:, 1) = theta_valid;
% y_valid(:, 2) = phidot;
% % y_valid = [theta_valid; phidot];
% y_valid = y_valid(start_index:end, :);
% u_valid = [I_mot(start_index:end) theta_sin_valid(start_index:end)];
% 
% validation_data = iddata(y_valid, u_valid, 'Ts', 0.01);
% 
% figure;
% compare(validation_data, lpv_result, optcom)


function [A,B,C,D] = lpv_pendulum(J_theta, mu_theta, J_phi, mu_phi,kt, mgL, Ts)
A = [
    0, 0, 1;
    0, -mu_phi/J_phi, mu_phi/J_phi;
    0, mu_phi/J_theta, -(mu_theta+mu_phi)/J_theta
    ];
B = [0 0; kt/J_phi 0; -kt/J_theta -mgL/J_theta];
C = [1, 0, 0; 0, 1, 0];
D = zeros(2,2);
end 
