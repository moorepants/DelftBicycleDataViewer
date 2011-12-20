function [data] = showdata(fname)

data = load([fname '.dat'],'-ascii');

speed      = data(:,1);
steerangle = data(:,2);
steerrate  = data(:,3);
leanrate   = data(:,4);
yawrate    = data(:,5);
battery    = data(:,6);
%battery2   = data(:,7);
%cadence    = data(:,8);
%clock      = data(:,9);

fid=fopen([fname '.dat']);
fseek(fid,1,'bof');
c = textscan(fid,'%s%s%s%d%d%d%d%d%s%s%s%s',1,...
    'delimiter','$');
fclose(fid);

date       = c{1,1}{1,1};
timestamp  = c{1,2}{1,1};
name       = c{1,3}{1,1};
runnum     =2;%= c{1,3}(1,1);
sampletime = c{1,4}(1,1);
samples    = c{1,5}(1,1);
age        = c{1,6}(1,1);
height     = c{1,7}(1,1);
mass       = c{1,8}(1,1);
gender     = c{1,9}{1,1};
experience = c{1,10}{1,1};
bicycle    = c{1,11}{1,1};
notes      = c{1,12}{1,1};
runtime    = 45.32; %clock(length(clock))-clock(1);
clear c

s = sprintf('%s, %s, Run %d\nFilename: %s.dat, Run time: %1.2f s, Sample time: %d ms, Number of samples: %d\nRider: %s, %s %s, %d years, %d kg, %d cm   Bicycle: %s\nNotes: %s',date,timestamp,runnum,fname,runtime,sampletime,samples,name,experience,gender,age,mass,height,bicycle,notes);

[n,m]   = size(data);

time = (1:n)./100;

figure

subplot(2,3,1)
plot(time,speed);
xlabel('time [sec]')
ylabel('speed [m/s]')
grid

subplot(2,3,2)
plot(time,steerangle);
xlabel('Time [sec]')
ylabel('Steer Angle [deg]')
title(s)
grid

subplot(2,3,3)
plot(time,steerrate);
xlabel('Time [sec]')
ylabel('Steer Rate [deg/s]')
grid

subplot(2,3,4)
plot(time,leanrate);
xlabel('Time [sec]')
ylabel('Lean Rate [deg/s]')
grid

subplot(2,3,5)
plot(time,yawrate);
xlabel('Time [sec]')
ylabel('Yawrate [deg/s]')
grid

subplot(2,3,6)
plot(time,battery);
xlabel('Time [sec]')
ylabel('Battery [V]')
grid