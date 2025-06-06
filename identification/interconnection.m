load("pendulum_down.mat");
% pendulum_sys = c2d(sys_min, 0.01, "zoh");
load("motor_ss.mat");

est_mot.InputName = ["u", "phidot"];
est_mot.OutputName = "I_mot";


dt = 0.01;
sys_min.InputName = "I_mot";
sys_min.OutputName = ["theta", "phidot"];
est_mot = d2c(est_mot, "foh");
connected = connect(est_mot, sys_min, "u", ["theta", "phidot", "I_mot"]);

save("../models/connected_down.mat", "connected");


nt = 10000;
u = 0.3 * ones(nt, 1);
t = 0:dt:dt*(nt-1);
lsim(connected, u, t)

clear
