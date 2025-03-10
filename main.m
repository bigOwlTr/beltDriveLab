clear; close all; clc;

data90 = readtable("data.xlsx", 'Range', 'C3:F12');
data180 = readtable("data.xlsx", 'Range', 'C13:F22');
data270 = readtable("data.xlsx", 'Range', 'I3:T12');
data360 = readtable("data.xlsx", 'Range', 'C23:F32');

figure('Units', 'centimeters', 'Position', [3, 3, 16, 10]);

hold on;

plot(data90{:,4}, data90{:,3}, 'LineWidth', 2, 'DisplayName', '90°');
plot(data180{:,4}, data180{:,3}, 'LineWidth', 2, 'DisplayName', '180°');
plot(data270{:,4}, data270{:,3}, 'LineWidth', 2, 'DisplayName', '270°');
plot(data360{:,4}, data360{:,3}, 'LineWidth', 2, 'DisplayName', '360°');

xlabel('T_2 (N)', 'FontSize', 14, 'FontName', 'Arial');
ylabel('T_1 (N)', 'FontSize', 14, 'FontName', 'Arial');
h_legend = legend('Location', 'southeast');
set(h_legend, 'FontSize', 14);  % Increase legend font size
grid on;
set(gca, 'FontSize', 12, 'LineWidth', 1.5);
