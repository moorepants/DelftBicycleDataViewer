% plots cadence data so I can see what it looks like
clear all
close all
clc
filename = [];
startFile = 1;
endFile = 34;
numFiles = endFile-startFile;
cadence = zeros(9000,numFiles);
time = zeros(9000,numFiles);
for i = startFile:endFile
    if i < 10
        filename = ['M00' num2str(i) '.dat'];
    elseif i > 99
        filename = ['M'   num2str(i) '.dat'];
    else
        filename = ['M0'  num2str(i) '.dat'];
    end
    data = load(filename);
    if length(data) < 9000
        data = [data; zeros(9000-length(data),9)];
    end
    cadence(:,i-startFile+1) = data(:,8);
    time(:,i-startFile+1) = data(:,9);
%     subplot(endFile-startFile+1,1,i-startFile+1)
%     plot(time(:,i-startFile+1),cadence(:,i-startFile+1))
%     title(filename)
end
