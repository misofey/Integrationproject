function [A,B,C,D] = linear_reaction_pendulum(J_theta, mu_theta,J_phi, mu_phi,kt, mgL, Ts)
A = [
    0, 0, 1;
    0, -mu_phi/J_phi, mu_phi/J_phi;
    -(mgL)/J_theta, mu_phi/J_theta, -(mu_theta+mu_phi)/J_theta
    ];
B = [0; kt/J_phi; -kt/J_theta];
C = [1, 0, 0; 0, 1, 0];
D = zeros(2,1);
end 

% function [A,B,C,D] = linear_reaction_pendulum(J_theta, mu_theta,J_phi, mu_phi,kt,M,L, g,Ts)
% A = [0, 0, 1; 0, -mu_phi/J_phi, mu_phi/J_phi; -(M*g*L)/J_theta, mu_phi/J_theta, -(mu_theta+mu_phi)/J_theta];
% B = [0; kt/J_phi; -kt/J_theta];
% C = [1, 0, 0; 0, 1, 0];
% D = zeros(2,1);
% end 