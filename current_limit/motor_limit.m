load("step_05.mat");
I_mot_05 = I_mot;
u_05 = u;
theta_05 = theta;
phidot_05 = phidot;

load("step_07.mat");
I_mot_07 = I_mot;
u_07 = u;
theta_07 = theta;
phidot_07 = phidot;

load("step_08.mat");
I_mot_08 = I_mot;
u_08 = u;
theta_08 = theta;
phidot_08 = phidot;

load("step_10.mat");
I_mot_10 = I_mot;
u_10 = u;
theta_10 = theta;
phidot_10 = phidot;

load("step_11.mat");
I_mot_11 = I_mot;
u_11 = u;
theta_11 = theta;
phidot_11 = phidot;


maxes = [max(I_mot_05), max(I_mot_07), max(I_mot_08), max(I_mot_10), max(I_mot_11)];

plot([5, 7, 8, 10, 11], maxes)
