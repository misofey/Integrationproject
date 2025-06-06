load("squares_held.mat");
I_mot_square = I_mot;
u_square = u;
theta_square = theta;
phidot_square = phidot;

nt = length(u_square);
dt = 0.05;
Tf = (nt-1) * dt;
t_square = 0:dt:Tf;


load("sines2_held.mat");
I_mot_sine = I_mot;
u_sine = u;
theta_sine = theta;
phidot_sine = phidot;

nt = length(u_sine);
Tf = (nt-1) * dt;
t_sine = 0:dt:Tf;

load("sines0_01.mat");
I_mot_sinefast = I_mot;
u_sinefast = u;
theta_sinefast = theta;
phidot_sinefast = phidot;

nt = length(u_sinefast);
dt_fast = 0.01;
Tf = (nt-1) * dt_fast;
t_sinefast = 0:dt_fast:Tf;

load("slow_squares.mat");
I_mot_ssquares = I_mot;
u_ssquares = u;
theta_ssquares = theta;
phidot_ssquares = phidot;

nt = length(u_ssquares);
dt_fast = 0.01;
Tf = (nt-1) * dt_fast;
t_ssquares = 0:dt_fast:Tf;

% create initial state space system
    A = [1];
    B = [1, -1];
    C = [1];
    D = [1 -1];

init_sys = idss(A, B, C, D, 0)
init_sys.Structure.K.Free = false;
% init_sys.Structure.D.Free = [false, false];
init_sys.Structure.C.Free = false;
init_sys.Ts = dt_fast;

u_id = [u_ssquares, phidot_ssquares];
y_id = [I_mot_ssquares];
t_id = t_ssquares;

u_val = [u_sinefast, phidot_sinefast];
y_val = [I_mot_sinefast];
t_val = t_sinefast;

est_mot = ssest(u_val, y_val, init_sys);


% rmse(validation_output, I_mot_sine)

% square_validation = lsim(est_mot, [u_square, phidot_square], t_square);

training_output = lsim(est_mot, u_id, t_ssquares);
figure;
hold on;
plot(I_mot_ssquares);
plot(training_output);
legend("sine wave data", "identified model");
hold off


validation_output = lsim(est_mot, [u_sinefast, I_mot_sinefast], t_sinefast);
figure;
hold on;
plot(I_mot_sinefast);
plot(validation_output);
legend("sine wave data", "identified model");
hold off


est_mot.Report.Fit
est_mot
% figure;
% hold on;
% plot(I_mot_square);
% plot(square_validation);
% legend("square wave data", "identified model");
% hold off

est_mot.InputName = ["u", "phidot"];
est_mot.OutputName = "I_mot";

save("motor_ss.mat", "est_mot");
