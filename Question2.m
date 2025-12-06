clear; clc; close all;


v = 20;                   % m/s (horizontal droplet velocity)
D = 3e-3;                 % m (distance from nozzle to paper)
t_travel = D/v;        % s (time for droplet to reach paper)
dpi = 300;                % printing resolution (dots per inch)
spacing = 0.0254 / dpi;   % m (vertical spacing between droplets)
total_time = 0.0825;      % s (total time to draw the letter "I")

line_length = 25.4e-3;              % 1 inch vertical line
N = round(line_length / spacing);   % number of droplets (≈300)
dt_fire = total_time / N;           % time between droplet firings

figure('Color','w');
hold on; grid on; axis equal;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('Inkjet Simulation: Drawing the Letter "I"');

xlim([0 D]);
ylim([-line_length/2 line_length/2]);
zlim([-1e-3 1e-3]);


paperX = D;
fill3([paperX paperX paperX paperX], ...
     [-line_length/2 line_length/2 line_length/2 -line_length/2], ...
     [-1e-3 -1e-3 1e-3 1e-3], ...
     [0.9 0.9 1], 'FaceAlpha', 0.3);


droplet = plot3(0, 0, 0, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 6);
drawnow;

y_points = linspace(-line_length/2, line_length/2, N);


tic;  % start timer

for i = 1:N
    
    y_final = y_points(i);               % final landing position on paper
    

    t_local = linspace(0, t_travel, 10); % small steps to animate travel
    x = v * t_local;
    y = y_final * ones(size(x));
    z = zeros(size(x));


    for k = 1:length(t_local)
        set(droplet, 'XData', x(k), 'YData', y(k), 'ZData', z(k));
        drawnow limitrate;
    end


    plot3(D, y_final, 0, 'k.', 'MarkerSize', 10);
    drawnow limitrate;


    elapsed = toc;
    target_time = i * dt_fire;
    if elapsed < target_time
        pause(target_time - elapsed);
    end
    
end



% Get axis limits AFTER the drawing is done
xl = xlim;
yl = ylim;

% Build info text
% ---- TEXT FIXED ON RIGHT SIDE OF SCREEN ----

infoText = sprintf(['"I" Drawn\n' ...
                    'Total Time: %.4f s\n' ...
                    'Droplets: %d\n' ...
                    'dt_{fire}: %.5f s'], ...
                    total_time, N, dt_fire);
annotation('textbox', [0.60 0.70 0.30 0.20], ...
    'String', infoText, ...
    'FontSize', 12, ...
    'FontName', 'Times New Roman', ...
    'Color', 'b', ...
    'FontWeight', 'normal', ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'top');


