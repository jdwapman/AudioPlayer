function [] = changeAudio( hObject, event, handles, buttonNumber)
%changeAudio Pauses audio, changes the track, and plays the new audio
%   Input: hObject, event, handles, buttonNumber. This function will pause
%   the currently playing audio (if there is any) and will change to the
%   new track and play it.

% Pause audio if it is currently playing
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded
    handles.audioPosition = playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause'); %Pauses the file, update handle variable
    handles.songPlaying = 0; %Song has been paused, so update songPlaying variable
    guidata(hObject, handles); %Updates handle data 
end %Check if no audio file has been opened

%--------------------------------------------------------------------------

%Load the desired audio file into currentTrack
if (handles.songLoaded(buttonNumber) == 1 & handles.songPlaying == 0) %Check if a file is loaded and that no song is playing
    
    handles.currentTrack = handles.soundFile{buttonNumber}; % Sets current track
    guidata(hObject, handles); %Updates handle data
    
    %Update file name text
    fileName = handles.name{buttonNumber};
    set(handles.audioName, 'String', fileName);
    
    %Update which switchboard button has been pressed.
    handles.trackPlaying = buttonNumber;
    
    % Set position to beginning of song
    handles.songPlaying = 0;
    handles.audioPosition = 0.0;
    set(handles.timeBar, 'Value', 0)
    guidata(hObject, handles); %Updates handle data
    

    % Change numbers

    % %First, calculate the time into the song
    totalTime = handles.currentTrack.TotalSamples / handles.currentTrack.SampleRate; %In seconds
    currentTime = totalTime * 0;

    %Calculate time into the song   
    [hours, minutes, seconds] = hoursMinsSecs(currentTime);

    timeElapsedString = strcat(sprintf('%02.0f', hours), ':', sprintf('%02.0f', minutes), ':', sprintf('%02.0f', seconds));
    set(handles.timeElapsed, 'String', timeElapsedString)


    %Calculate time left in the song

    [hoursLeft, minutesLeft, secondsLeft] = hoursMinsSecs(totalTime - currentTime);
    
    timeLeftString = strcat('-', sprintf('%02.0f', hoursLeft), ':', sprintf('%02.0f', minutesLeft), ':', sprintf('%02.0f', secondsLeft));
    set(handles.timeLeft, 'String', timeLeftString)

end




% Play new audio

if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded. 0 = File has been loaded
    
%----PLAY FILE-------------------------------------------------------------

    
    handles.currentTrack = processAudio(hObject, event, handles, handles.currentTrack);
    guidata(hObject, handles); %Updates handle data 
    
    handles.songPlaying = 1; %Since play button has been pressed, audio is now playing
    guidata(hObject, handles); %Updates handle data 
    
    playFile(handles, handles.currentTrack, handles.audioPosition, 'Play') %Plays the new file
    
end %Check if no audio file has been opened

