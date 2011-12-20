function handles =  GraphTimes(handles)

% Get the input time and the time width
handles.TimeWidth = str2num(get(handles.TimeWidthInput,'String'));

% Calculate the graph time limits
if (handles.Time - handles.TimeWidth/2) < 0
    handles.TimeMin = handles.TimeStart;
    handles.TimeMax = handles.Time + handles.TimeWidth/2;
elseif (handles.Time + handles.TimeWidth/2) > handles.TimeEnd
    handles.TimeMin = handles.Time - handles.TimeWidth/2;
    handles.TimeMax = handles.TimeEnd;
else
    handles.TimeMin = handles.Time - handles.TimeWidth/2;
    handles.TimeMax = handles.Time + handles.TimeWidth/2;
end

% Find indices of important times
[m,handles.imin]  = min(abs(handles.TimeMin-handles.bikedata(:,10)));
[m,handles.imax]  = min(abs(handles.TimeMax-handles.bikedata(:,10)));
[m,handles.itime] = min(abs(handles.Time-handles.bikedata(:,10)));
