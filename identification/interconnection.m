load("../models/pendulum_sys.mat");
load("../models/pendulum_linear_sys.mat");
load("../models/pendulum_upright.mat");
load("../models/motor_ss.mat");

% pendulum_sys = c2d(sys_min, 0.01, "zoh");
% pendulum_sys.InputName = "I_mot";

sys_min.InputName = "I_mot";
sys_min.OutputName = ["theta", "phidot"];
disc = c2d(sys_min, est_mot.Ts, "foh");

connected = connect(est_mot, disc, "u", ["theta", "phidot", "I_mot"]);

save("../models/connected.mat", "connected");
