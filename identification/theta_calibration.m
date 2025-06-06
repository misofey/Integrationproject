function [theta_cal] = theta_calibration(calibration_options, theta)
%THETA_CALIBRATION Summary of this function goes here
%   Detailed explanation goes here
scaling = calibration_options("scaling");
offset = calibration_options("offset");

% remove offset and scale
theta_cal = (theta-offset) * scaling;

if calibration_options("top_zero")
    theta_cal = theta_cal + pi;
end

% put the angle between -pi / +pi
theta_cal = mod(theta_cal + pi, 2 * pi) - pi;

end
