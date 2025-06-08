load("connected_filter.mat");
h = 0.01;

sys_d = c2d(connected, h, "zoh");
Np = 40;
Nc = 12;
generate_empc = false ;
[mpcobj, state, empcobj, empcstate] = create_mpc_obj(sys_d, Np, Nc, generate_empc);
%% simulation
Nsim = 100;
Ts = h;
x0 = [0, 7 * pi/180, 0, 0];

% Dimensions
nx = 4;
nu = 1;
ny = 4;

C = sys_d.C;
D = sys_d.D;
A = sys_d.A;
B = sys_d.B;

x = zeros(nx, Nsim+1);
y = zeros(ny, Nsim+1);
u = zeros(nu, Nsim+1);
t = (0:Nsim)*Ts;

% Initial conditions
x(:,1) = x0;
u(1) = 0;
y(:,1) = C*x0';
% u_prev = 0;

% You can also track custom states from mpcobj (e.g. estimator states):
xmpc = mpcstate(mpcobj);
r = [0 0 0 0];
% Simulation loop
for k = 1:Nsim    
    % empcstate.Plant = x(:, k);
    % [u_current, Info] = mpcmoveExplicit(empcobj, empcstate, ymeas, r);
    [u(k), Info] = mpcmove(mpcobj, xmpc, y(:,k), r);
    % u_prev = u(k);
    xmpc.Plant = x(:, k);
    
    x(:,k+1) = A*x(:,k) + B*u(k);
    y(:,k+1) = C*x(:,k+1) + D*u(k);
end

%% plotting
figure;
% Theta
subplot(5,1,1);
plot(t, y(1, :), 'LineWidth',1.2);
ylabel('\theta (rad)');
title('Theta');
grid on;

% Phidot
subplot(5,1,2);
plot(t, y(2, :), 'LineWidth',1.2);
ylabel('\phi̇ (rad/s)');
title('Phidot');
grid on;

% Motor current
subplot(5,1,3);
plot(t, y(3, :), 'LineWidth',1.2);
ylabel('I_{mot} (A)');
title('Motor Current');
grid on;

% Thetadot
subplot(5,1,4);
plot(t, y(4, :), 'LineWidth',1.2);
ylabel('\thetȧ (rad/s)');
xlabel('t (s)');
title('Thetadot');
grid on;

% U
subplot(5,1,5);
plot(t, u, 'LineWidth',1.2);
ylabel('u');
xlabel('t (s)');
title('u');
grid on;

% Make subplots tighter
set(gcf,'Position',[100 100 600 800]);

if exist("settlingtimes", "var")
    result = stepinfo(y(1, :), t);    
    settlingtimes(end+1).Np = Np;
    settlingtimes(end).Nc = Nc;
    settlingtimes(end).TTime = result.TransientTime;
else
    result = stepinfo(y(1, :), t);    
    settlingtimes(1).Np = Np;
    settlingtimes(1).Nc = Nc;
    settlingtimes(1).TTime = result.TransientTime;
end

