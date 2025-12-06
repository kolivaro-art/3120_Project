
%--------------------------------------------------------------
% Inkjet Printer Simulation: Drawing a Vertical Line ("I")
% Real-time (0.0825 s total duration)
%--------------------------------------------------------------
clear; clc; close all;
%------------------- Given Parameters -------------------------
v = 20;                   % m/s (horizontal droplet velocity)
D = 3e-3;                 % m (distance from nozzle to paper)
t_travel = 150e-6;        % s (time for droplet to reach paper)
dpi = 300;                % printing resolution
spacing = 0.0254 / dpi;   % m (vertical spacing between droplets)
total_time = 0.0825;      % s (total time to draw letter "I")
%------------------- Line Geometry ----------------------------
line_length = 25.4e-3;    % 1 inch vertical line
N = round(line_length / spacing);     % number of droplets (≈300)
dt_fire = total_time / N;             % time between droplet firings
%------------------- Figure Setup -----------------------------
figure('Color','w');
hold on; grid on; axis equal;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('Inkjet Simulation: Drawing the Letter "I"');
xlim([0 D]); ylim([-line_length/2 line_length/2]); zlim([-1e-3 1e-3]);
% Draw Paper Plane
paperX = D;
fill3([paperX paperX paperX paperX], ...
     [-line_length/2 line_length/2 line_length/2 -line_length/2], ...
     [-1e-3 -1e-3 1e-3 1e-3], [0.9 0.9 1], 'FaceAlpha', 0.3);
%------------------- Droplet Initialization -------------------
droplet = plot3(0,0,0,'bo','MarkerFaceColor','b','MarkerSize',6);
drawnow;
% Preallocate for printed dots
y_points = linspace(-line_length/2, line_length/2, N);
%------------------- Simulation Loop --------------------------
tic;  % Start real-time timer
for i = 1:N
   y_final = y_points(i);
   % Droplet trajectory (moves horizontally to paper)
   t_local = linspace(0, t_travel, 10);
   x = v * t_local;
   y = y_final * ones(size(x));
   z = zeros(size(x));
   % Move droplet toward paper
   for k = 1:length(t_local)
       set(droplet, 'XData', x(k), 'YData', y(k), 'ZData', z(k));
       drawnow limitrate;
   end
   % Mark droplet on paper (printed dot)
   plot3(D, y_final, 0, 'k.', 'MarkerSize', 10);
   drawnow limitrate;
   % Wait until next droplet firing (maintain total 0.0825 s)
   elapsed = toc;
   target = i * dt_fire;
   if elapsed < target
       pause(target - elapsed);
   end
end
%------------------- Completion -------------------------------
text(D/2, 0, 5e-4, 'Letter "I" Drawn', ...
    'HorizontalAlignment','center','FontSize',12,'Color','b');
hold off;
