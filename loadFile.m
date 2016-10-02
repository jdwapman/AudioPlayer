function [ handles ] = loadFile( hObject, event, handles, buttonNumber )
%loadFile Loads a new file and adds it to the list of available audio
%tracks


[fileName, pathName] = uigetfile('*.wav'); %Get file

if(ischar(fileName)) %Handles cancel button error

    fullPathName = strcat(pathName, fileName);
    [data, fs] = audioread(fullPathName); %Extract sound data
    
    audioTrack = audioplayer(data, fs); %Creates audioplayer object from sound data
    audioTrack.UserData = data;
    handles.soundFile{buttonNumber} = audioTrack; %Adds audio file to array in "handles"
    guidata(hObject, handles); %Update handles
    
    handles.songLoaded(buttonNumber) = 1;
    handles.originalSampleRate(buttonNumber) = fs;
    guidata(hObject, handles);
    
    %Depending on which load button is clicked, change the name of the
    %switchboard label
    
    switch buttonNumber
        case 1
            set(handles.audio1, 'String', fileName) %Change label of the switchboard button
        case 2
            set(handles.audio2, 'String', fileName) %Change label of the switchboard button
        case 3
            set(handles.audio3, 'String', fileName) %Change label of the switchboard button
        case 4
            set(handles.audio4, 'String', fileName) %Change label of the switchboard button
        case 5
            set(handles.audio5, 'String', fileName) %Change label of the switchboard button
        case 6
            set(handles.audio6, 'String', fileName) %Change label of the switchboard button
        case 7
            set(handles.audio7, 'String', fileName) %Change label of the switchboard button
        case 8
            set(handles.audio8, 'String', fileName) %Change label of the switchboard button
        case 9
            set(handles.audio9, 'String', fileName) %Change label of the switchboard button
    end
    
    handles.name{buttonNumber} = fileName; %Stores the name of the file
    guidata(hObject, handles);
    
end

handles = guidata(hObject); %Updates handles so variables are not lost when exiting function


end

