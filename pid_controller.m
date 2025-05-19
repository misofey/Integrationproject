function [u, theta_error, theta_integral, theta_dot, theta_prev, calibration_options] = pid_controller(theta_meas, phidot_meas, I_meas, calibration_options, theta_prev, theta_integral)
%PID_CONTROLLER Summary of this function goes here
%   Detailed explanation goes here

% calibration of theta
if calibration_options("calibrated")
    theta_cal = theta_calibration(calibration_options, theta_meas);
else
    calibration_options("theta_offset") = theta_meas;
    calibration_options("calibrated") = true;
end

h = 0.01;
kp = 0.01;
kd = 0.01;
ki = 0.01;

% intergal and derivative calculation
theta_dot = (theta_cal - theta_prev) / h;
theta_integral = theta_integral + (theta_cal * h);

% pid input
u = theta_cal * kp + theta_dot * kd + theta_integral * ki;

% additional return variables
theta_error = theta_cal;
theta_prev = theta_cal;

end
