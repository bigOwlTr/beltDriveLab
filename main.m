clear; close all; clc;

data90 = readtable("data.xlsx", 'Range', 'C3:F12');
data180 = readtable("data.xlsx", 'Range', 'C13:F22');
data270 = readtable("data.xlsx", 'Range', 'I3:T12');
data360 = readtable("data.xlsx", 'Range', 'C23:F32');

%--------------------------------------------4 tensions plot --------------

figure('Units', 'centimeters', 'Position', [3, 3, 16, 10]);

hold on;


scatter(data90{:,3}, data90{:,4}, 50, 'b', 'DisplayName', ...
    '90° Data', 'Marker', '^', 'LineWidth', 1.5);
scatter(data180{:,3}, data180{:,4}, 50, 'r', 'DisplayName', ...
    '180° Data', 'Marker', '^', 'LineWidth', 1.5);
scatter(data270{:,3}, data270{:,4}, 50, 'g', 'DisplayName', ...
    '270° Data', 'Marker', '^', 'LineWidth', 1.5);
scatter(data360{:,3}, data360{:,4}, 50, 'k', 'DisplayName', ...
    '360° Data', 'Marker', '^', 'LineWidth', 1.5);


mdl90 = fitlm(data90{:,3}, data90{:,4});
mdl180 = fitlm(data180{:,3}, data180{:,4});
mdl270 = fitlm(data270{:,3}, data270{:,4});
mdl360 = fitlm(data360{:,3}, data360{:,4});


plot(data90{:,3}, predict(mdl90, data90{:,3}), 'b:', 'LineWidth', 1.5, ...
    'DisplayName', '90° Linear Fit');
plot(data180{:,3}, predict(mdl180, data180{:,3}), 'r:', 'LineWidth', 1.5, ...
    'DisplayName', '180° Linear Fit');
plot(data270{:,3}, predict(mdl270, data270{:,3}), 'g:', 'LineWidth', 1.5, ...
    'DisplayName', '270° Linear Fit');
plot(data360{:,3}, predict(mdl360, data360{:,3}), 'k:', 'LineWidth', 1.5, ...
    'DisplayName', '360° Linear Fit');

xlabel('T_2 (N)', 'FontSize', 12);
ylabel('T_1 (N)', 'FontSize', 12);
h_legend = legend('Location', 'northwest');
set(h_legend, 'FontSize', 10);
grid on;

set(gca, 'FontSize', 12, 'LineWidth', 1.5);

hold off;

%------------------------------------coefficient of friction --------------
hold on;

mubeta90 = log(1 / mdl90.Coefficients.Estimate(2));
mubeta180 = log(1 / mdl180.Coefficients.Estimate(2));
mubeta270 = log(1 / mdl270.Coefficients.Estimate(2));
mubeta360 = log(1 / mdl360.Coefficients.Estimate(2));

angles_deg = [90, 180, 270, 360];
angles_rad = deg2rad(angles_deg);

mubeta_values = [mubeta90, mubeta180, mubeta270, mubeta360];

figure('Units', 'centimeters', 'Position', [3, 3, 16, 10]);

h1 = scatter(angles_rad, mubeta_values, 60, 'Marker', '^', ...
    'LineWidth', 1.5, 'MarkerEdgeColor', 'b');

mdl = fitlm(angles_rad, mubeta_values);

hold on;
x_values = linspace(min(angles_rad), max(angles_rad), 100);
y_values = predict(mdl, x_values');

h2 = plot(x_values, y_values, 'b:', 'LineWidth', 1.5);

xlabel('\beta (Radians)', 'FontSize', 12);
ylabel('ln(T_2/T_1)', 'FontSize', 12);

equation_text = sprintf('y = %.2fx + %.2f', mdl.Coefficients.Estimate(2) ...
    , mdl.Coefficients.Estimate(1));
text(angles_rad(2), mubeta_values(2), equation_text, 'FontSize', 10, ...
    'VerticalAlignment', 'top');

legend([h1, h2], {'Data points', 'Linear fit'}, 'Location', 'northwest', ...
    'FontSize', 10);

grid on;

xlim([0, 2*pi]);
ylim([0, max(mubeta_values)+1]);

set(gca, 'FontSize', 12, 'LineWidth', 1.5);
hold off;


%-------------------------------predicted tension ratio--------------------
theta = linspace(0, 2*pi, 10); 

mu = mdl.Coefficients.Estimate(2);  

tensionRatioPredicted = exp(mu * theta);

tensionTable = table(theta', tensionRatioPredicted', ...
    'VariableNames', {'theta', 'tensionratio'});

figure('Units', 'centimeters', 'Position', [3, 3, 16, 10]);
plot(tensionTable.theta, tensionTable.tensionratio, 'LineWidth', 2, ...
    'Color', 'r', 'DisplayName','Theoretical');
hold on;

xlabel('\beta (Radians)', 'FontSize', 12);
ylabel('Tension Ratio (T_2 / T_1)', 'FontSize', 12);

grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5); 

tensionRatio90 = 1/mdl90.Coefficients.Estimate(2);  
tensionRatio180 = 1/mdl180.Coefficients.Estimate(2);  
tensionRatio270 = 1/mdl270.Coefficients.Estimate(2);  
tensionRatio360 = 1/mdl360.Coefficients.Estimate(2);  

anglesDeg = [90, 180, 270, 360];
anglesRad = deg2rad(anglesDeg); 


scatter(anglesRad, [tensionRatio90, tensionRatio180, ...
    tensionRatio270, tensionRatio360], ...
    100, 'b', 'Marker', ...
    '^', 'LineWidth', 1.5, 'DisplayName', 'Experimental');

legend('show', 'FontSize', 12, 'Location', 'northwest');
grid on;
hold off;

%--------------------motor efficiency--------------------------------------
figure('Units', 'centimeters', 'Position', [3, 3, 16, 10]);

motorTable = data270(:, 5:12);
efficiencyTable = table();

efficiencyTable.PowerDraw = motorTable{:, 1} .* motorTable{:, 2}; 
efficiencyTable.PowerOut = motorTable{:, 4} .* motorTable{:, 6}; 

efficiencyTable.Efficiency = efficiencyTable.PowerOut ./ ... 
    efficiencyTable.PowerDraw * 100;

efficiencyTable.Torque = motorTable{:, 4};

plot(efficiencyTable.Torque, efficiencyTable.Efficiency, '-^', ...
    'MarkerSize', 8, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'none', ...
    'LineWidth', 1.5);

xlabel('Torque (Nm)');
ylabel('Efficiency (%)');
grid on;
hold off;