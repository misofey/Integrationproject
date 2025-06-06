function [u] = swingup(x)

persistent J_theta kt mgL

if isempty(J_theta)
    [J_theta, ~, ~, ~, kt, mgL] = get_model_parameters();
end

    E0 = 0.0;
    theta = x(2);
    thetadot = x(4);

    E = energy(theta, thetadot);
    
    sign_term = sign(thetadot * cos(theta));
    
    k = 1;

    u = k * (E - E0) * sign_term;
    u = clip(u, -1, 1);
end

function [E] = energy(theta, thetadot)
    
    persistent J_theta kt mgL

     % energy is 0 at the unstable equilibrium
    e_kin = 0.5 * J_theta * thetadot * thetadot;
    e_pot = 0.5 * mgL * (cos(theta) - 1);
    E = e_kin + e_pot;
end