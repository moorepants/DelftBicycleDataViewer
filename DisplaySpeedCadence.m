function DisplaySpeedCadence(handles)

% Set the speed
if get(handles.MeterPerSecToggle,'Value') == 1 % display meters per second
    set(handles.SpeedDisplay,'String',sprintf('%1.2f',...
        handles.bikedata(handles.itime,1)));
else % display kilometers per hour
    set(handles.SpeedDisplay,'String',sprintf('%1.1f',...
        handles.bikedata(handles.itime,1).*3.6));
end

% Set the cadence
if get(handles.HertzToggle,'Value') == 1 % display hertz
    set(handles.CadenceDisplay,'String',sprintf('%1.2f',...
        handles.bikedata(handles.itime,11)));
else % display rotations per minute
    set(handles.CadenceDisplay,'String',sprintf('%1.1f',...
        handles.bikedata(handles.itime,12)));
end