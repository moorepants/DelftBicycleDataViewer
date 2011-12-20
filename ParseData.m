% File: parsedata.m
% Date: November 24, 2008
% Author: Jason Moore
% Description: Modifies the raw data to be used in the data_viewer.m GUI.
% Data ouput is in the format: [speed (m/s),steering angle (deg),steering rate 
% (deg/s),lean rate (deg/s),yaw rate (deg/s),sensor battery voltage (V),
% computer battery voltage (V),cadence spikes,time (ms), time (s), cadence
% (Hz), cadence (rpm)]
% Header output is in the format: [date/time; name ;sample time (ms);
% samples; age (years); height (cm); mass (kg); gender; experiene; bicycle;
% notes]
function [data,header]= ParseData(name)

% load the data from the selected .dat file
data = load(name);

% make a time column in seconds
data(:,10) = data(:,9)/1000;

% define the cadence spike data and the time in seconds
cadence = data(:,8);
time = data(:,10);
k = 1;
index = 0;
% if the first cadence value is a spike then record the indice
if cadence(1) == 1
    index(1,1) = 1;
    k = k+1;
end
% check through the cadence data for spikes at positive 1 and record the
% indices in the index vector
for i = 2:length(cadence)
    if cadence(i) == 1 && cadence(i-1) ~= 1
        index(k,1) = i;
            k = k+1;
    end
end
% if spikes where recorded at all calculate the period between spikes
if index ~= 0
    % find the period between each spike
    periodSeed = zeros(length(index),1); % intialize the period seed vector
    % set the first period as the time between the first spike and time = 0
    periodSeed(1,1) = time(index(1))-time(1);
    % set the rest of the periods according to the spike indices
    for i = 2:length(index)
        periodSeed(i,1) = time(index(i))-time(index(i-1));
    end
    % intialize the corrupt vector and the first good value
    corrupt = zeros(length(periodSeed),1);
    firstGood = 0;
    % check the periods and if they are really short call them corrupt
    for i = 1:length(periodSeed)
        if periodSeed(i,1) < 0.4
            corrupt(i,1) = 1;
        end
        % find the first index that is not corrupt after i = 1
        if corrupt(i,1) == 0 && i ~= 1 && firstGood == 0
            firstGood = i;
        end
    end
    % if there is no good data (i.e. big gaps between the spikes, set the
    % cadence to zero
    if firstGood == 0
        data(:,11) = zeros(length(data),1);
        data(:,12) = zeros(length(data),1);
    else
        % change the first corrupt part of the data to the first good values
        periodSeed(1:firstGood) = periodSeed(firstGood)*ones(firstGood,1);
        % now change any corrupt values to the good value before it
        for i = 1:length(periodSeed)
            if periodSeed(i,1) < 0.4
                periodSeed(i,1) = periodSeed(i-1,1);
            end
        end
        % populate the full length period vector
        period = periodSeed(1)*ones(index(1),1); % set the first values
        for i = 2:length(index)
            period = [period; periodSeed(i)*ones(index(i)-index(i-1),1)];
        end
        % set the last values
        period = [period; periodSeed(length(periodSeed))*...
            ones(length(cadence)-length(period),1)];
        % calculate the frequency in hertz
        data(:,11) = 1./period;
        % calculate the rotation frequency in rad/s
        omega = 2.*pi.*data(:,11);
        % calculate the rotations per minute
        data(:,12) = omega.*60./2./pi;
    end
else % set cadence data to zero if there are no spikes
    data(:,11) = zeros(length(data),1);
    data(:,12) = zeros(length(data),1);
end

% enter lambda for the bicycle in the experiment. this is for the batavus
% browser. this must be updated for a different bicycle.
lambda = 0.4276;
% subtract the roll rate and the yaw rate from the steer sensor data
data(:,13) = data(:,3)+data(:,4).*sin(lambda)-data(:,5).*cos(lambda);
% switch the roll rate direction
data(:,14) = -data(:,4);

% grab the header information and store it in a cell
fid=fopen(name);
% skip the first character
fseek(fid,1,'bof');
% get the first 11 strings separated by '|'
header = textscan(fid,'%s',11,'delimiter','|');
fclose(fid);