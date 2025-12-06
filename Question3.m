Vx = 20.0;          % horizontal speed [m/s]
W  = 1.0e-3;        % plate separation [m]
L1 = 0.5e-3;        % capacitor length [m]
L2 = 1.25e-3;       % distance from capacitor exit to paper [m]

% Droplet properties
rho = 1000.0;       % density [kg/m^3]
d   = 84e-6;        % diameter [m]
q   = -1.9e-10;     % charge [C]

% Derived mass
volume = (pi/6) * d^3;
m = rho * volume;
dpi = 300; 
% Pixel pitch for 300 dpi
inch  = 0.0254;
pitch = (1/dpi)*inch;   % vertical pixel spacing [m]
T_cap = L1 / Vx;        % time in field per droplet [s]

% Key formula: y = (q * V * L1 * L2) / (m * W * Vx^2)
% Rearranged: V = y * (m*W*Vx^2) / (q*L1*L2)
coef_V_per_m = (m * W * Vx^2) / (q * L1 * L2);  % volts per meter of deflection

% Voltage increment per 1 pixel
dV_per_pixel = abs(coef_V_per_m) * pitch;

fprintf('Q3: Droplet mass m = %.3e kg\n', m);
fprintf('Q3: y(V) = (q*V*L1*L2)/(m*W*Vx^2)\n');
fprintf('Q3: V(y) = y*(m*W*Vx^2)/(q*L1*L2)\n');
fprintf('Q3: 300 dpi pixel pitch = %.1f micrometers\n', pitch*1e6);
fprintf('Q3: |ΔV| per pixel ≈ %.1f V\n', dV_per_pixel);
fprintf('Q3: Time step per droplet (stair step) = %.1f microseconds\n', T_cap*1e6);

%% Demonstration staircase for the first N pixels (downward direction)
N_demo = 40;  % change as desired
t = (0:N_demo) * T_cap;             % time edges of steps
V_steps = -(0:N_demo) * dV_per_pixel; % negative sign = one deflection direction

figure; 
stairs(t*1e6, V_steps, 'LineWidth', 1.5);  % time in microseconds
xlabel('Time [\mus]');
ylabel('Capacitor Voltage V(t) [V]');
title(sprintf('Staircase V(t): step = %.1f V per pixel, T_{cap} = %.0f \\mus', ...
               dV_per_pixel, T_cap*1e6));
grid on;
height_in = 11; 
%% Optional: estimate total |V| range for a full 11" vertical I
N_full = height_in * dpi;                 % 3300 pixels
V_span_est = N_full * dV_per_pixel;       % total span if purely electrostatic
fprintf('Q3 (note): Full 11" span would need ~%.2e V total range (~±%.2e V).\n', ...
        V_span_est, 0.5*V_span_est);

%% Helper functions (inline)
% y_from_V = @(V) (q.*V.*L1.*L2) ./ (m.*W.*Vx.^2);
% V_from_y = @(y) (y.*m.*W.*Vx.^2) ./ (q.*L1.*L2);
