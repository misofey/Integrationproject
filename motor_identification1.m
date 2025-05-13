load("squares_held.mat");
I_mot_square = I_mot;
u_square = u;
theta_square = theta;
phidot_square = -phidot;

nt = length(u_square);
dt = 0.05;
Tf = (nt-1) * dt;
t_square = 0:dt:Tf;


load("sines2_held.mat");
I_mot_sine = I_mot;
u_sine = u;
theta_sine = theta;
phidot_sine = -phidot;

nt = length(u_sine);
Tf = (nt-1) * dt;
t_sine = 0:dt:Tf;

load("sines0_01.mat");
I_mot_sinefast = I_mot;
u_sinefast = u;
theta_sinefast = theta;
phidot_sinefast = -phidot;

nt = length(u_sinefast);
dt_fast = 0.01;
Tf = (nt-1) * dt_fast;
t_sinefast = 0:dt_fast:Tf;

% create initial state space system
A = [1];
B = [1, 1];
C = [1];
D = [0 0];

init_sys = idss(A, B, C, D, 0)
init_sys.Structure.K.Free = false;
init_sys.Structure.D.Free = [false, false];
init_sys.Structure.C.Free = false;
init_sys.Ts = dt_fast;

u_id = [u_sinefast, phidot_sinefast];
y_id = [I_mot_sinefast];

est_mot = ssest(u_id, y_id, init_sys);

training_output = lsim(est_mot, [u_sinefast, phidot_sinefast], t_sinefast);

% rmse(validation_output, I_mot_sine)

% square_validation = lsim(est_mot, [u_square, phidot_square], t_square);

figure;
hold on;
plot(I_mot_sinefast);
plot(training_output);
legend("sine wave data", "identified model");
hold off

figure;
hold on;
plot(I_mot_square);
plot(square_validation);
legend("square wave data", "identified model");
hold off

save("motor_ss.mat", "est_mot");



% identified = tfest(u_square, I_mot_square, 4, "Ts", 0.05)

% I_sim = lsim(identified, u_square', t_square);
% rmse = [];
% fit = [];

% for i = 0:10
%     ident = tfest(u_square, I_mot_square, i, "Ts", 0.05);
%     rmse = [rmse, ident.Report.Fit.MSE];
%     fit = [fit, ident.Report.Fit.FitPercent];
% end
% figure;
% plot(rmse);
% title("transfer function order fitting");
% ylabel("RMSE");
% xlabel("Order");


% figure;
% hold on;
% plot(I_mot)
% plot(I_sim)
% legend("data", "identified")
% hold off;

% I_sim_sine = lsim(identified, u_sine', t_sine);

% figure;

% hold on;
% plot(I_mot_sine);
% plot(I_sim_sine);
% legend("sine wave data", "identified model");
% hold off