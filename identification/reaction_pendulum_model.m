function [dx, y] = reaction_pendulum_model(t, x, u, J_theta, mu_theta,J_phi, mu_phi,kt, mgL, varargin)
 
%     theta = x(1);
%     dphi = x(2);
%     dtheta = x(3);
% 
%     i = u(1);  

%     J_theta = p(1);
%     mu_theta = p(2);
%     J_phi = p(3);
%     mu_phi = p(4);
%     kt = p(5);
%     M = p(6);
%     L = p(7);
%     g = 9.81;

%     ddtheta = (-M*g*L*sin(theta) - mu_theta*dtheta + mu_phi*dphi - kt*i) / J_theta;
%     ddphi = (kt*i - mu_phi*dphi) / J_phi;

    dx = [x(3); ...
        (kt/ J_phi)*u(1) - (mu_phi/ J_phi)*x(2) + (mu_phi/ J_phi)*x(3); ...
        (-mgL*sin(x(1))/ J_theta) - ((mu_theta + mu_phi)/ J_theta)*x(3) + (mu_phi/ J_theta)*x(2) - (kt/ J_theta)*u(1) ...
        ];
    y = [x(1); x(2)];
end