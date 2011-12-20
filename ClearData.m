function ClearData(handles)
% Resest the GUI to original settings

% the data is not loaded
handles.DataLoaded = 0;

% erase the data
handles.data = {};

% clear all the graphs
cla(handles.SteerAngleGraph,  'reset');
cla(handles.SteerRateGraph,   'reset');
cla(handles.LeanRateGraph,    'reset');
cla(handles.YawRateGraph,     'reset');
cla(handles.VideoDisplay,     'reset');

% removes the axis and tick marks from the video display
set(handles.VideoDisplay,     'Visible','off');

% reset all the inputs to the original values
set(handles.TimeWidthInput,   'String', '4'           );
set(handles.TimeInput,        'String', '0'           );
set(handles.TimeEndDisplay,   'String', '0'           );
set(handles.TimeStartDisplay, 'String', '0'           );
set(handles.TimeSlider,       'Value' ,  0            );
set(handles.FrameNumInput,    'String', '0'           );
set(handles.SpeedDisplay,     'String', '0.00'        );
set(handles.CadenceDisplay,   'String', '0.00'        );
set(handles.FileNameDisplay,  'String', 'File name:'  );
set(handles.DateDisplay,      'String', 'Date:'       );
set(handles.NameDisplay,      'String', 'Name:'       );
set(handles.SampleTimeDisplay,'String', 'Sample time:');
set(handles.SamplesDisplay,   'String', 'Samples:'    );
set(handles.AgeDisplay,       'String', 'Age:'        );
set(handles.HeightDisplay,    'String', 'Height:'     );
set(handles.MassDisplay,      'String', 'Mass:'       );
set(handles.GenderDisplay,    'String', 'Gender:'     );
set(handles.ExperienceDisplay,'String', 'Experience:' );
set(handles.BicycleDisplay,   'String', 'Bicycle:'    );
set(handles.NotesDisplay,     'String', 'Notes:'      );