% this requires the data to be in the workspace

theta_cal = calibrate(theta);

subplot(5, 1, 1);
plot(theta);
title("theta");

subplot(5, 1, 2);
plot(theta_cal);
title("calibrated angle");

subplot(5, 1, 3);
plot(phidot);
title("phidot");

subplot(5, 1, 4);
plot(I_mot);
title("I_mot");

subplot(5, 1, 5);
plot(u);
title("u");


function [theta_cal] = calibrate(theta)
    x1 = 0.86;
    y1 = -pi;
    x2 = 131.13;
    y2 = 0;
    
    b = x2;                            
    a = (y1) / (x1 - b);               
    
    x_fit = linspace(x1 - 10, x2 + 10, 500);
    y_fit = a * (x_fit - b);
    
    theta_cal = a * theta + b;
%     figure;
%     plot(x_fit, y_fit, 'b-'); 
%     hold on;
%     plot([x1 x2], [y1 y2], 'ro', 'MarkerSize', 3);
%     grid on;
%     
%     title('Sensor Calibration Linear Model');
%     xlabel('Raw Sensor Value (x)');
%     ylabel('Physical Value (y) [rad]');
%     legend('Linear Fit: y = a(x - b)', 'Calibration Points');
end
