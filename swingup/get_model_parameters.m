function [J_theta, mu_theta, J_phi, mu_phi, kt, mgL] = get_model_parameters()
    load("pendulum_linear_sys.mat");
    [J_theta, mu_theta, J_phi, mu_phi, kt, mgL] = getpvec(sys);
end

