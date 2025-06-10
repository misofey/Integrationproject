% This script is executed every time that an experiment is initialized

% Define the sampling time here:
h = 0.01;

% load linear model parameters
params = load("linear_parameters.mat");
J_theta = params.params(1);
kt = params.params(5);
mgL = params.params(6);


% load('connected_filter.mat');
A = connected.A;
%A(3,1) = -A(3,1);
B = connected.B;
C = [connected.C; [0 0 0 1]];
D = [connected.D; 0];
[num, den] = ss2tf(A, B, C, D, 1);
linear_sys = ss(A, B, C, D);


sys_min = minreal(linear_sys);

q = [1, 3, 10, 0.18, 0.01];
Q = 1 * diag(q);
% Q = 1e-5 * eye(4);  
r = [0.01, 0.1, 0.1, 0.0001];
R = 1 * diag(r);   
G = zeros(4);

sys_d = c2d(linear_sys, h);
Ad = sys_d.A;
Bd = sys_d.B;
Cd = sys_d.C;
Dd = sys_d.D;

% system with output disturbance on theta
A_dist = [Ad zeros(4, 1); zeros(1, 4), 1];
B_dist = [Bd; 0];
C_dist = [Cd [1 0 0 0]'];
D_dist = Dd;

disturbed = ss(A_dist, B_dist, C_dist, D_dist, h);


% Q_lqr = diag([0.0001, 10, 0.001, 0.001]);
% R_lqr = 0.01;
% N_lqr = zeros(4, 1);

Q_maxes = [5 10*pi/180 300 10];
Q_lqr = diag(Q_maxes.^-2);
R_lqr = (1)^-2;
N_lqr = zeros(4, 1);

[K, S, P] = dlqr(Ad, Bd, Q_lqr, R_lqr, N_lqr);

K_dist = [K 0];

Np = 36;
Nc = 3;

mpcobj = mpc(sys_d, h, Np, Nc);
mpcobj.Weights.ManipulatedVariables = [1];      
% mpcobj1.Weights.ManipulatedVariablesRate = [0.01];
mpcobj.Weights.OutputVariables = [100, 0.1, 0.1, 0.1];
mpcobj.Weights.OutputVariables = [Q_lqr(2, 2), Q_lqr(3, 3), Q_lqr(1, 1), Q_lqr(4, 4)];

mpcobj.MV(1).Min = -1;
mpcobj.MV(1).Max = 1;

mpcobj.OV(1).Min = -(15/180)*pi;
mpcobj.OV(1).Max = (15/180)*pi;
mpcobj.OV(2).Min = -400;
mpcobj.OV(2).Max = 400;
% mpcobj1.OV(2).Min = -100;
% mpcobj1.OV(2).Max = 100;

% [Kest, L] = kalman(sys_d, Q, R);
setEstimator(mpcobj, 'default');
% setmpcsignals(mpcobj1, 'MV', 1, 'MO', 1:4);

mpcobj.Model.Nominal.X = [0; 0; 0; 0];
mpcobj.Model.Nominal.U = 0;
mpcobj.Model.Nominal.Y = [0; 0; 0; 0];
% state = mpcstate(mpcobj1);
% 
% global mpcobj1

cutoff = 1/0.05;
alpha = h/(1/cutoff + h);
