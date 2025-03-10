clear;close all;clc;       %clearing the workspace and any windows

data90 = readtable("data.xlsx", 'Range', 'C3:F12');
data180 = readtable("data.xlsx", 'Range', 'C13:F22');
data270 = readtable("data.xlsx", 'Range', 'I3:T12');
data360 = readtable("data.xlsx", 'Range', 'C23:F32');

