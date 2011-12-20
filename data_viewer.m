function varargout = data_viewer(varargin)
% DATA_VIEWER M-file for data_viewer.fig
%      DATA_VIEWER, by itself, creates a new DATA_VIEWER or raises the existing
%      singleton*.
%
%      H = DATA_VIEWER returns the handle to a new DATA_VIEWER or the handle to
%      the existing singleton*.
%
%      DATA_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_VIEWER.M with the given input arguments.
%
%      DATA_VIEWER('Property','Value',...) creates a new DATA_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before data_viewer_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to data_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help data_viewer

% Last Modified by GUIDE v2.5 11-Dec-2008 13:23:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @data_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @data_viewer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before data_viewer is made visible.
function data_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to data_viewer (see VARARGIN)

% Choose default command line output for data_viewer
handles.output = hObject;

DisableControls(handles); % disables the controls

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes data_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = data_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in FileListBox.
function FileListBox_Callback(hObject, eventdata, handles)
% hObject    handle to FileListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns FileListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileListBox


% --- Executes during object creation, after setting all properties.
function FileListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AddFilesButton.
function AddFilesButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddFilesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% gets input file(s) from user.
[input_file,pathname] = uigetfile( ...
       {'*.dat', 'Data Files (*.dat)'; ...
        '*.*', 'All Files (*.*)'}, ...
        'Select files', ... 
        'MultiSelect', 'on');
 
% if file selection is cancelled, pathname should be zero
% and nothing should happen
if pathname == 0
    return
end
 
% gets the current data file names inside the listbox
inputFileNames = get(handles.FileListBox,'String');
 
%if they only select one file, then the data will not be a cell
if iscell(input_file) == 0
 
    %add the most recent data file selected to the cell containing
    %all the data file names
    inputFileNames{length(inputFileNames)+1} = ...
        fullfile(pathname,input_file);
 
% else, data will be in cell format
else
    % stores full file path into inputFileNames
    for n = 1:length(input_file)
        inputFileNames{length(inputFileNames)+1} = fullfile(pathname,input_file{n});
    end
end
 
% updates the gui to display all filenames in the listbox
set(handles.FileListBox,'String',inputFileNames);
 
% make sure first file is always selected so it doesn't go out of range
% the GUI will break if this value is out of range
set(handles.FileListBox,'Value',1);
 
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in LoadDataButton.
function LoadDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% wipe the GUI clean
ClearData(handles);

% get the selected file from the listbox
inputFileName = get(handles.FileListBox,'String');
selectionNumber = get(handles.FileListBox,'Value');
 
% if no files are selected then nothing happens
if isempty(inputFileName)
    return
end
 
% disables the button while data is processing
DisableButtons(handles);
DisableControls(handles);

% refresh the figure to reflect changes
refresh(data_viewer); 

% gets the filename and the extension
[path,fileName,ext,ignore]=fileparts(inputFileName{selectionNumber});

% create the video file path and filename
videoPath = ['videoFiles/' fileName '.wmv'];

% does the video exist?
type = exist(videoPath,'file');
if type == 2 % then the file exists
    handles.videoExist = 1;
else % then the file doesn't exist
    handles.videoExist = 0;
end

if handles.videoExist == 1 % show the first frame of the video
    % read in the video file
    handles.vr = videoReader(videoPath);
    % get video info
    vrinfo = getinfo(handles.vr);
    % vrinfo =
    %                    url: [1x71 char]
    %                    fps: 25
    %                  width: 640
    %                 height: 480
    %                    bpp: 24
    %                   type: 'rgb'
    %              numFrames: 2089
    %         approxFrameNum: -1
    %                 fourcc: 'WMV3'
    %     nHiddenFinalFrames: 0
    %         frameTimeoutMS: 3000
    % store the info for use in other functions
    handles.fps = vrinfo.fps;
    handles.numFrames = vrinfo.numFrames;
    handles.videoWidth = vrinfo.width;
    handles.videoHeight = vrinfo.height;
    
    handles.frame = 0;
    % display the first frame of the video
    axes(handles.VideoDisplay)
    next(handles.vr);           % read next frame
    img = getframe(handles.vr); % extract frame
    imshow(img);        % show it
    pause(1/handles.fps);      % wait
else % there is no video, so show the "no video available" graphic
    handles.frame = 0;
    handles.fps = 25;
    handles.vr = 0;
    cla(handles.VideoDisplay)
    axes(handles.VideoDisplay)
    imshow('NoVid.jpg')
end

% stores the numerical data using the custom function 
handles.bikedata = {};
[handles.bikedata,runInfo] = ParseData(inputFileName{selectionNumber});

% store the sample time [seconds]
handles.SampleTime = str2num(runInfo{1,1}{ 3,1})/1000;

% populate the run information
set(handles.FileNameDisplay,  'String',[get(handles.FileNameDisplay,  ...
    'String') ' ' fileName ext]);
set(handles.DateDisplay,      'String',[get(handles.DateDisplay,      ...
    'String') ' ' runInfo{1,1}{ 1,1}])
set(handles.NameDisplay,      'String',[get(handles.NameDisplay,      ...
    'String') ' ' runInfo{1,1}{ 2,1}]) 
set(handles.SampleTimeDisplay,'String',[get(handles.SampleTimeDisplay,...
    'String') ' ' runInfo{1,1}{ 3,1} ' ms'])
set(handles.SamplesDisplay,   'String',[get(handles.SamplesDisplay,   ...
    'String') ' ' runInfo{1,1}{ 4,1}])
set(handles.AgeDisplay,       'String',[get(handles.AgeDisplay,       ...
    'String') ' ' runInfo{1,1}{ 5,1}])
set(handles.HeightDisplay,    'String',[get(handles.HeightDisplay,    ...
    'String') ' ' runInfo{1,1}{ 6,1} ' cm'])
set(handles.MassDisplay,      'String',[get(handles.MassDisplay,      ...
    'String') ' ' runInfo{1,1}{ 7,1} ' kg'])
set(handles.GenderDisplay,    'String',[get(handles.GenderDisplay,    ...
    'String') ' ' runInfo{1,1}{ 8,1}])
set(handles.ExperienceDisplay,'String',[get(handles.ExperienceDisplay,...
    'String') ' ' runInfo{1,1}{ 9,1}])
set(handles.BicycleDisplay,   'String',[get(handles.BicycleDisplay,   ...
    'String') ' ' runInfo{1,1}{10,1}])
set(handles.NotesDisplay,     'String',[get(handles.NotesDisplay,     ...
    'String') ' ' runInfo{1,1}{11,1}])

% find the start and end time of the data
handles.TimeStart = handles.bikedata(1,10);
handles.TimeEnd = handles.bikedata(length(handles.bikedata(:,10)),10);

% display the start and end times
set(handles.TimeStartDisplay,'String',num2str(handles.TimeStart));
set(handles.TimeEndDisplay,'String',num2str(handles.TimeEnd));

% set the limits of the time slider
set(handles.TimeSlider,'Min',handles.TimeStart,'Max',handles.TimeEnd);

% set the time
handles.Time = 0;

% display the current time
set(handles.TimeInput,'String',num2str(handles.Time));
set(handles.TimeSlider,'Value',handles.Time);

% calculate the times needed to plot
handles = GraphTimes(handles);

DisplaySpeedCadence(handles);

% make intitial plots
% steer angle
[handles.SteerAngleLine, handles.SteerAngleVertLine] = ...
    PlotData(handles.bikedata,2,handles.Time,handles.TimeWidth,...
    handles.imin,handles.imax,handles.SteerAngleGraph,'Steer Angle [deg]');
% steer rate
[handles.SteerRateLine, handles.SteerRateVertLine] = ...
    PlotData(handles.bikedata,13,handles.Time,handles.TimeWidth,...
    handles.imin,handles.imax,handles.SteerRateGraph,'Steer Rate [deg/s]');
% lean rate
[handles.LeanRateLine, handles.LeanRateVertLine] = ...
    PlotData(handles.bikedata,14,handles.Time,handles.TimeWidth,...
    handles.imin,handles.imax,handles.LeanRateGraph,'Lean Rate [deg/s]');
% yaw rate
[handles.YawRateLine, handles.YawRateVertLine] = ...
    PlotData(handles.bikedata,5,handles.Time,handles.TimeWidth,...
    handles.imin,handles.imax,handles.YawRateGraph,'Yaw Rate [deg/s]');

%the data must be done processing before other Callbacks will be 
%able to function properly. this variable will be used as a "check"
%to see whether the data has been processed or not
handles.DataLoaded = 1;
 
% data is done processing, so re-enable the buttons
EnableButtons(handles);
EnableControls(handles);
% disable the frame number input if there is no video
if handles.videoExist == 0
    set(handles.FrameNumInput,'String','N/A','Enable','off');
end
guidata(hObject, handles);


% --- Executes on button press in DeleteFilesButton.
function DeleteFilesButton_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteFilesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get the current list of file names from the listbox
inputFileNames = get(handles.FileListBox,'String');
 
%get the values for the selected file names
option = get(handles.FileListBox,'Value');
 
%is there is nothing to delete, nothing happens
if (isempty(option) == 1 || option(1) == 0 )
    return
end
 
%erases the contents of highlighted item in data array
inputFileNames(option) = [];
 
%updates the gui, erasing the selected item from the listbox
set(handles.FileListBox,'String',inputFileNames);
 
%moves the highlighted item to an appropiate value or else will get error
if option(end) > length(inputFileNames)
    set(handles.FileListBox,'Value',length(inputFileNames));
end
 
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in ClearDataButton.
function ClearDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ClearData(handles); % calls the ClearData m-file

DisableControls(handles); % disables the inputs

% Update handles structure
guidata(hObject, handles);


% --- Executes on slider movement.
function TimeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to TimeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% obtains the slider value from the slider component and sets the time
handles.Time = get(hObject,'Value');

% puts the slider value into the edit text component
set(handles.TimeInput,'String', num2str(handles.Time));

% calculate the plot times
handles = GraphTimes(handles);

% display the current speed and cadence
DisplaySpeedCadence(handles);

% update the plots
UpdatePlot('SteerAngle',handles)
UpdatePlot('SteerRate' ,handles)
UpdatePlot('LeanRate'  ,handles)
UpdatePlot('YawRate'   ,handles)

% disable the slider to prevent overload while searching for a video frame
set(hObject,'Enable','off');

% find the closest frame and set the video to display it
handles.frame = GoToFrame(handles);

% turn the slider back on
set(hObject,'Enable','on');

% display the frame number
set(handles.FrameNumInput,'String',num2str(handles.frame));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function TimeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function TimeInput_Callback(hObject, eventdata, handles)
% hObject    handle to TimeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeInput as text
%        str2double(get(hObject,'String')) returns contents of TimeInput as a double

% get the string for the editText component and set the time
handles.Time = str2num(get(hObject,'String'));

%if user inputs a value not within the time range then it defaults to zero
if (isempty(handles.Time) || handles.Time < handles.TimeStart || handles.Time > handles.TimeEnd)
    handles.Time = 0;
    set(handles.TimeSlider,'Value',handles.Time);
    set(hObject,'String','0');
else
    set(handles.TimeSlider,'Value',handles.Time);
end

% calculate the needed plot times
handles =  GraphTimes(handles);

% disable the input and slider to prevent overload while searching for a
% video frame
set(hObject,'Enable','off');
set(handles.TimeSlider,'Enable','off');

% find the closest frame and set the video to display it
handles.frame = GoToFrame(handles);

% turn the input and slider back on
set(hObject,'Enable','on');
set(handles.TimeSlider,'Enable','on');

% display the frame number
set(handles.FrameNumInput,'String',num2str(handles.frame));

% display the speed and cadence values
DisplaySpeedCadence(handles)

% replot the data graphs
UpdatePlot('SteerAngle',handles)
UpdatePlot('SteerRate' ,handles)
UpdatePlot('LeanRate'  ,handles)
UpdatePlot('YawRate'   ,handles)

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TimeInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TimeWidthInput_Callback(hObject, eventdata, handles)
% hObject    handle to TimeWidthInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeWidthInput as text
%        str2double(get(hObject,'String')) returns contents of TimeWidthInput as a double

handles =  GraphTimes(handles);

% UpdatePlot('SteerAngle',handles)
% UpdatePlot('SteerRate' ,handles)
% UpdatePlot('LeanRate'  ,handles)
% UpdatePlot('YawRate'   ,handles)

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TimeWidthInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeWidthInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in PlayButton.
function PlayButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlayButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.videoExist == 1 % then play the video
    axes(handles.VideoDisplay)
    set(hObject,'UserData',1)
    while(get(handles.PlayButton,'UserData'))
        next(handles.vr);           % read next frame
        handles.frame = handles.frame+1;
        handles.Time = handles.frame/handles.fps;
        % display the frame number
        set(handles.FrameNumInput,'String',num2str(handles.frame));
        % display the time
        set(handles.TimeInput,'String',num2str(handles.Time));
        % set the slider value
        set(handles.TimeSlider,'Value',handles.Time);
        handles = GraphTimes(handles);
        DisplaySpeedCadence(handles);
        UpdatePlot('SteerAngle',handles)
        UpdatePlot('SteerRate' ,handles)
        UpdatePlot('LeanRate'  ,handles)
        UpdatePlot('YawRate'   ,handles)
        img = getframe(handles.vr); % extract frame
        imshow(img);        % show it
        pause(1/handles.fps);      % wait
    end
else % scroll through the data only
    set(hObject,'UserData',1)
    handles.Time = str2num(get(handles.TimeInput,'String'));
    while(get(handles.PlayButton,'UserData'))
        handles = GraphTimes(handles);
        DisplaySpeedCadence(handles);
        UpdatePlot('SteerAngle',handles)
        UpdatePlot('SteerRate' ,handles)
        UpdatePlot('LeanRate'  ,handles)
        UpdatePlot('YawRate'   ,handles)
        pause(handles.SampleTime)
        handles.Time = handles.Time + handles.SampleTime;
        set(handles.TimeInput,'String',num2str(handles.Time))
        set(handles.TimeSlider,'Value',handles.Time)
    end
end
    
guidata(hObject, handles);


% --- Executes on button press in StopButton.
function StopButton_Callback(hObject, eventdata, handles)
% hObject    handle to StopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.PlayButton,'UserData',0)
guidata(hObject, handles);


function FrameNumInput_Callback(hObject, eventdata, handles)
% hObject    handle to FrameNumInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrameNumInput as text
%        str2double(get(hObject,'String')) returns contents of FrameNumInput as a double

% get the input frame number
handles.frame = str2num(get(hObject,'String'));

% calculate the time at the input frame number
handles.Time = handles.frame/handles.fps;

% display the time and set the time slider
set(handles.TimeInput,'String',num2str(handles.Time));
set(handles.TimeSlider,'Value',handles.Time);

%if user inputs a value not within the time range then it defaults to zero
if (isempty(handles.Time) || handles.Time < handles.TimeStart || handles.Time > handles.TimeEnd)
    handles.Time = 0;
    set(handles.TimeSlider,'Value',handles.Time);
    set(hObject,'String','0');
else
    set(handles.TimeSlider,'Value',handles.Time);
end

% calculate the needed plot times
handles =  GraphTimes(handles);

% disable the input and slider to prevent overload while searching for a
% video frame
set(hObject,'Enable','off');
set(handles.TimeSlider,'Enable','off');

% find the closest frame and set the video to display it
handles.frame = GoToFrame(handles);

% turn the input and slider back on
set(hObject,'Enable','on');
set(handles.TimeSlider,'Enable','on');

% display the frame number
set(handles.FrameNumInput,'String',num2str(handles.frame));

% display the speed and cadence values
DisplaySpeedCadence(handles)

% replot the data graphs
UpdatePlot('SteerAngle',handles)
UpdatePlot('SteerRate' ,handles)
UpdatePlot('LeanRate'  ,handles)
UpdatePlot('YawRate'   ,handles)

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function FrameNumInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameNumInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ShowFreq.
function ShowFreq_Callback(hObject, eventdata, handles)
% hObject    handle to ShowFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ShowJBike6.
function ShowJBike6_Callback(hObject, eventdata, handles)
% hObject    handle to ShowJBike6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


