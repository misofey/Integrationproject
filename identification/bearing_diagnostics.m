clear;
clf;
clc;
load("swing_test.mat");

data_start = 1600;
nt = length(theta);
t = (data_start:nt)*h;


theta = theta(data_start:end);
theta_offset = mean(theta);

theta = (theta - theta_offset) * 2 * pi / 4.5;
theta_smooth = lowpass(theta, 10, 500);
% theta_smooth = theta;
thetadot = gradient(theta_smooth, t);
thetadotdot = gradient(thetadot, t);

A = sin(theta_smooth);
b = thetadotdot;
x = lsqr(A, b);

x = -7.8;

friction_force = thetadotdot - x * sin(theta_smooth);

hold on;
scatter(theta, thetadotdot);
plot(theta, x*sin(theta));
ylim([-15 15]);
hold off;

figure;
hold on;
plot(theta);
plot(theta_smooth);
legend("og", "smooth");
hold off;

figure;
selector = (friction_force< 15) & (friction_force>-15);
hold on;
scatter3(theta(selector), ...
    thetadot(selector), ...
    friction_force(selector), ...
    1, friction_force(selector));
colormap("turbo");
% zlim([-10  10]);
ylim([-5 5]);
xlabel("theta");
ylabel("thetadot");
zlabel("friction")
grid;
hold off;


figure;
hold on;
scatter(thetadot, friction_force, 1, theta);
ylim([-10 10]);
xlim([-5 5]);
% xlabel("theta");
xlabel("thetadot");
ylabel("friction")
grid;
hold off;

figure;
selector = (friction_force< 10) & (friction_force>-10);
hold on;
scatter(theta(selector), ...
    thetadot(selector), ...
    6, friction_force(selector));
colormap("turbo");
% zlim([-10  10]);
ylim([-5 5]);
xlabel("theta");
ylabel("thetadot");
% zlabel("friction")
grid;
hold off;


% figure;
% selector = (friction_force< 10) & (friction_force>-10);
% scatter(thetadot, friction_force);