function frame = GoToFrame(handles)

% find closest frame to the input time
frame = round(handles.Time*handles.fps);
if handles.videoExist == 1
    % update the video frame
    axes(handles.VideoDisplay)
    % go to the new frame
    seek(handles.vr,handles.frame);
    img = getframe(handles.vr); % extract frame
    imshow(img);        % show it
    pause(1/handles.fps);      % wait
else
end