function varargout = videoIOGUI(varargin)
global vr fps frame
% VIDEOIOGUI M-file for videoIOGUI.fig
%      VIDEOIOGUI, by itself, creates a new VIDEOIOGUI or raises the existing
%      singleton*.
%
%      H = VIDEOIOGUI returns the handle to a new VIDEOIOGUI or the handle to
%      the existing singleton*.
%
%      VIDEOIOGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDEOIOGUI.M with the given input arguments.
%
%      VIDEOIOGUI('Property','Value',...) creates a new VIDEOIOGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before videoIOGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to videoIOGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help videoIOGUI

% Last Modified by GUIDE v2.5 02-Dec-2008 19:42:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @videoIOGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @videoIOGUI_OutputFcn, ...
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


% --- Executes just before videoIOGUI is made visible.
function videoIOGUI_OpeningFcn(hObject, eventdata, handles, varargin)
global vr fps frame
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to videoIOGUI (see VARARGIN)

% Choose default command line output for videoIOGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes videoIOGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% open the video file
fname = [pwd '\M050BCT3S00_26_23.wmv'];
% create read object
handles.vr = videoReader(fname); 
% get video info 
vrinfo = getinfo(vr);
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
s1 = [vrinfo.url ...
      '  fps:' num2str(vrinfo.fps) ...
      '  ' num2str(vrinfo.width) 'x' num2str(vrinfo.height) ...
      '  numFrames:' num2str(vrinfo.numFrames)];
set(handles.videoinfo,'String',s1);
fps = vrinfo.fps;
frame = 0;




% --- Outputs from this function are returned to the command line.
function varargout = videoIOGUI_OutputFcn(hObject, eventdata, handles)
global vr fps
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%
next(vr);           % read next frame
img = getframe(vr); % extract frame
imshow(img);        % show it
pause(1/fps);      % wait



% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
global vr fps frame
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'UserData',1)
while(get(handles.start,'UserData'))
  next(vr);           % read next frame
  frame = frame+1;
  set(handles.framenumber,'String',num2str(frame))
  img = getframe(vr); % extract frame
  imshow(img);        % show it
  pause(1/fps);      % wait
end



% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.start,'UserData',0)


% --- Executes on slider movement.
function speed_Callback(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function fps_Callback(hObject, eventdata, handles)
global vr fps frame
% hObject    handle to fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fps as text
%        str2double(get(hObject,'String')) returns contents of fps as a double
fps = str2num(get(hObject,'String'));
if (isempty(fps))
  warning('Input must be a number')
  fps = 25;
  set(hObject,'String',num2str(fps))
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function fps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in forward.
function forward_Callback(hObject, eventdata, handles)
global vr fps frame
% hObject    handle to forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% stop if playing
set(handles.start,'UserData',0)
next(vr);           % read next frame
frame = frame+1;
set(handles.framenumber,'String',num2str(frame))
img = getframe(vr); % extract frame
imshow(img);        % show it
guidata(hObject,handles);

% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
global vr fps frame
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.start,'UserData',0)
step(vr,-1);           % read next frame
frame = frame-1;
set(handles.framenumber,'String',num2str(frame))
img = getframe(vr); % extract frame
imshow(img);        % show it



function framenumber_Callback(hObject, eventdata, handles)
global vr fps frame
% hObject    handle to framenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of framenumber as text
%        str2double(get(hObject,'String')) returns contents of framenumber as a double

frame = str2num(get(hObject,'String'));
if (isempty(frame))
  warning('Input must be a number')
  frame=0;
end
seek(vr,frame);
img = getframe(vr); % extract frame
imshow(img);        % show it
set(hObject,'String',num2str(frame))
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function framenumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to framenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


