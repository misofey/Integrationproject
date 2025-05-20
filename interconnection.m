load("pendulum_sys.mat");
pendulum_sys = c2d(sys_min, 0.01, "zoh");
load("motor_ss.mat");

dt = 0.01;
pendulum_sys.InputName = "I_mot";
pendulum_sys.OutputName = ["theta", "phidot", "theta_dot"];

connected = connect(est_mot, pendulum_sys, "u", ["theta", "phidot", "theta_dot"]);


nt = 10000;
u = 0.3 * ones(nt, 1);
t = 0:dt:dt*(nt-1);
lsim(connected, u, t)
