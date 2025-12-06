%--------------------------------------------------------------
% PART 4(c): Drawing a Vertical Line "I"
% Droplet diameter is TENFOLD increased → fewer droplets needed
% Real-time simulation (minimal total time)
%--------------------------------------------------------------
clear; clc; close all;

%------------------- Given Parameters -------------------------
v = 20;                   % m/s droplet velocity
L1 = 0.5e-3;              % m (unchanged)
L2 = 1.25e-3;             % m (unchanged)
D  = 3e-3;                % m (unchanged)

% Total flight distance
L_total = L1 + L2 + D;

% Droplet flight time
t_travel = L_total / v;     % 237.5 microseconds (unchanged)
fprintf("Droplet travel time = %.2f microseconds\n", t_travel*1e6);

%------------------- Droplet Size Increase ---------------------
d_original = 84e-6;             % original diameter (m)
d_new = 10 * d_original;        % TENfold increased droplet size

% New vertical spacing = droplet diameter
spacing = d_new;

% Draw 1-inch vertical line
line_length = 25.4e-3;
N = round(line_length / spacing);    % about 30 droplets

% Minimal printing time
dt_fire = t_travel;
total_time = N * dt_fire;

fprintf("Total time to draw I = %.5f seconds\n", total_time);

%------------------- Figure Setup -----------------------------
figure('Color','w');
hold on; grid on; axis equal;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('PART 4(c): Inkjet Simulation with Droplet Size ×10');

xlim([0 L_total * 1.35]);
ylim([-line_length/2 line_length/2]);
zlim([-1e-3 1e-3]);

% Paper plane
paperX = L_total;
fill3([paperX paperX paperX paperX], ...
     [-line_length/2 line_length/2 line_length/2 -line_length/2], ...
     [-1e-3 -1e-3 1e-3 1e-3], [0.9 0.9 1], 'FaceAlpha', 0.3);

%------------------- Right-Side Annotations --------------------
textX = L_total * 1.18;

text(textX, line_length/2 * 0.75, 0, ...
    sprintf("Total Print Time = %.5f s", total_time), ...
    'FontSize',12,'Color','b');

text(textX, line_length/2 * 0.50, 0, ...
    "Droplet Travel Time = 237.5 µs", ...
    'FontSize',12,'Color','b');

text(textX, line_length/2 * 0.20, 0, ...
    'Letter "I" Drawn (Part c)', ...
    'FontSize',12,'Color','b');

%------------------- Droplet Initialization -------------------
droplet = plot3(0,0,0,'bo','MarkerFaceColor','b','MarkerSize',6);
drawnow;

% Y positions for droplets
y_points = linspace(-line_length/2, line_length/2, N);

%------------------- Simulation Loop --------------------------
tic;

for i = 1:N

    y_final = y_points(i);

    t_local = linspace(0, t_travel, 12);
    x = v * t_local;
    y = y_final * ones(size(t_local));
    z = zeros(size(t_local));

    % Animate droplet flight
    for k = 1:length(t_local)
        set(droplet, 'XData', x(k),'YData', y(k),'ZData', z(k));
        drawnow limitrate;
    end

    % Print droplet
    plot3(paperX, y_final, 0, 'k.', 'MarkerSize', 20);   % bigger ink spot
    drawnow limitrate;

    % Real-time sync
    elapsed = toc;
    target = i * dt_fire;
    if elapsed < target
        pause(target - elapsed);
    end
end

hold off;

