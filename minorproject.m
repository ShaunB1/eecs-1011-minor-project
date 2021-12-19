%{
Minor Project
Shaun Bautista
218750935
EECS 1011
December 6, 2021
%}
%%
clear; clc; close all;
a = arduino

h = animatedline('Color', 'r');
j = animatedline('Color', 'b');
ax = gca;
ax.YGrid = 'on';
ax.YLim = [-0.1 3.7];
startTime = datetime('now');
title('Moisture Sensor Voltage Readings vs Time');
xlabel('Time [HH:MM:SS]');
ylabel('Voltage [V]');
legend('Voltage', 'Moisture Level');

running = false;
filter = zeros(1, 5);
while ~running
    % Set filter
    filter = setFilter(filter);
    filter(length(filter)) = readVoltage(a, 'A1');
    average = mean(filter);
    
    %-----------------------------------------------------
    % Get current time
    if readVoltage(a, 'A0') == 0
        t = datetime('now') - startTime;
        moistLevel = moistMeter(average);

        % Add points to animation
        addpoints(h, datenum(t), average);
        addpoints(j, datenum(t), moistLevel);

        % Update axes
        ax.XLim = datenum([t - seconds(15) t]);
        datetick('x', 'keeplimits');
        drawnow;
    end
    %-----------------------------------------------------
    
    %-----------------------------------------------------
    % Water output according to level of moisture
    if readVoltage(a, 'A0') == 5
        moistLevel = moistMeter(average);
        if moistLevel <= 0.3
            "Soil is dry!"
            writeDigitalPin(a, 'D2', 1);
            pause(5)
            writeDigitalPin(a, 'D2', 0);
            pause(10);

        elseif moistLevel > 0.3 && moistLevel <= 0.6
            "Soil is wet but not completely saturated!"
            writeDigitalPin(a, 'D2', 1);
            pause(3);
            writeDigitalPin(a, 'D2', 0);
            pause(10);
        end
    end
    %-----------------------------------------------------
    
    % Stop
    running = readDigitalPin(a, 'D6');

end