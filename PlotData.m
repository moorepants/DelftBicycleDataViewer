function [h1 h2] = PlotData(bikedata,num,Time,TimeWidth,imin,imax,axesName,yName)
cla(axesName); %clear the axes
axes(axesName); %set the axes to plot
hold on
% find max and min of data
maxValue = max(bikedata(:,num));
minValue = min(bikedata(:,num));
axis([Time-TimeWidth/2 Time+TimeWidth/2 minValue maxValue])
h1 = plot(bikedata(imin:imax,10),bikedata(imin:imax,num));
h2 = plot([Time Time],[minValue maxValue],'k');
xlabel('Time [s]')
ylabel(yName)
box on
hold off