function [ output_args ] = changeButtonColor(hObject, handles )
%changeButtonColor Makes all switchboard buttons turn on again

% Turn all buttons back on (0 = on, 1 = off)
set(handles.audio1, 'Value', 0)
set(handles.audio2, 'Value', 0)
set(handles.audio3, 'Value', 0)
set(handles.audio4, 'Value', 0)
set(handles.audio5, 'Value', 0)
set(handles.audio6, 'Value', 0)
set(handles.audio7, 'Value', 0)
set(handles.audio8, 'Value', 0)
set(handles.audio9, 'Value', 0)

end

