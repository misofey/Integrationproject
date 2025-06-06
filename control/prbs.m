Ts = 0.05;
T_total = 40;
N = T_total/Ts;
u = idinput([N 1 1], 'prbs');
t = (0:N-1)'* Ts;
input_signal = [t,u];
save('prbs_input.mat',"input_signal")