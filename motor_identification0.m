load("squares_held.mat");
I_mot_square = I_mot;
u_square = u;
theta_square = theta;
phidot_square = phidot;

load("sines2_held.mat");
I_mot_sine = I_mot;
u_sine = u;
theta_sine = theta;
phidot_sine = phidot;

nt = length(u_square);
dt = 0.05;
Tf = (nt-1) * dt;
t_square = 0:dt:Tf;

nt = length(u_sine);
Tf = (nt-1) * dt;
t_sine = 0:dt:Tf;

identified = tfest(u_square, I_mot_square, 3, "Ts", 0.05)

I_sim = lsim(identified, u_square', t_square);


rmse = [];
fit = [];

for i = 0:10
    ident = tfest(u_square, I_mot_square, i, "Ts", 0.05);
    rmse = [rmse, ident.Report.Fit.MSE];
    fit = [fit, ident.Report.Fit.FitPercent];
end

figure;
plot(rmse);
title("transfer function order fitting");
ylabel("RMSE");
xlabel("Order");


figure;
hold on;
plot(I_mot)
plot(I_sim)
legend("data", "identified")
hold off;

I_sim_sine = lsim(identified, u_sine', t_sine);

figure;

hold on;
plot(I_mot_sine);
plot(I_sim_sine);
legend("sine wave data", "identified model");
hold off