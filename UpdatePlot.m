function UpdatePlot(axesName,handles)
switch axesName
    case 'SteerAngle'
        lineName = handles.SteerAngleLine;
        vertLine = handles.SteerAngleVertLine;
        graphName = handles.SteerAngleGraph;
        num = 2;
    case 'SteerRate'
        lineName = handles.SteerRateLine;
        vertLine = handles.SteerRateVertLine;
        graphName = handles.SteerRateGraph;
        num = 13;
    case 'LeanRate'
        lineName = handles.LeanRateLine;
        vertLine = handles.LeanRateVertLine;
        graphName = handles.LeanRateGraph;
        num = 14;
    case 'YawRate'
        lineName = handles.YawRateLine;
        vertLine = handles.YawRateVertLine;
        graphName = handles.YawRateGraph;
        num = 5;
end
% find max and min of data
maxValue = max(handles.bikedata(:,num));
minValue = min(handles.bikedata(:,num));

set(lineName,'XData',handles.bikedata(handles.imin:handles.imax,10),'YData',handles.bikedata(handles.imin:handles.imax,num));
set(vertLine,'XData',[handles.Time handles.Time],'YData',[minValue maxValue])
set(graphName,'XLim',[(handles.Time-handles.TimeWidth/2) (handles.Time+handles.TimeWidth/2)])