load("connected_filter.mat");
h = 0.01;

sys_d = c2d(connected, h, "zoh");

Ad = sys_d.A;
Bd = sys_d.B;
Cd = sys_d.C;
Dd = sys_d.D;

Q_maxes = [100 1 * pi/180 500 100];

Q_lqr = diag(Q_maxes.^-2);
R_lqr = (10)^-2;
N_lqr = zeros(4, 1);

% Q_lqr = diag([0.0001, 10, 0.001, 0.001]);
% R_lqr = 0.0001;
% N_lqr = zeros(4, 1);

[K, S, P] = dlqr(Ad, Bd, Q_lqr, R_lqr, N_lqr);

fedback = ss(Ad - Bd * K, Bd, [Cd; K], [Dd; 0], sys_d.Ts);
fedback.OutputName = ["theta", "phidot", "I_mot", "thetadot", "u"];

sys_d.InputName = "u";
sys_d.OutputName = ["I_mot", "theta", "phidot", "thetadot"];

controller = ss(0, [0 0 0 0], 0, K, sys_d.Ts);
controller.InputName = ["I_mot", "theta", "phidot", "thetadot"];
controller.OutputName = "uc";

summer = sumblk("u = r - uc");

controlled = connect(sys_d, controller, summer, "r", ["I_mot", "theta", "phidot", "thetadot", "u"]);

pole(controlled)
sys_d.A-Bd*K
controlled.A
pole(controlled)

%% simulate
    
Nsim = 50;
dt = 0.01;

t = (0:Nsim)*dt;
u = zeros(size(t));
x0 = [1 5*pi/180 50 0.8];

lsim(fedback  , u, t, x0)

y = lsim(fedback  , u, t, x0);
% plot(clip(y(:, 5), -1, 1))