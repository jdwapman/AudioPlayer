function [pausePosition] = playFile(handles, audioFile , startTime, playPause)
%playFile This function handles playing the audio file and updates the user
%interface
%   Input: playFile(audioFile)
%       When run, this function will play the audio file given from the
%       indicated start time, and will update the progress bar and time
%       counters

%Calculate the total runtime of the audio sample
totalTime = audioFile.TotalSamples / audioFile.SampleRate;

%Variables to allow the audio to continue playing while interacting with
%the user interface. "Persistent" variables are not cleared from memory
%when the function is ended

persistent finalAudio;
finalAudio = audioFile;

% Assign custom function to audio player that updates the progression of
% the slider bar

finalAudio.TimerFcn = {@updateSlider, handles, audioFile, totalTime};

%Play audio file
if (strcmp(playPause, 'Play') == 1 & startTime == 0) %If playing from the very beginning
    playblocking(finalAudio);
else if (strcmp(playPause, 'Pause') == 1) %If pausing the track
    pause(finalAudio);
    pausePosition = get(handles.timeBar, 'Value') * totalTime;
else %Start from middle of audio track
    startPosition = startTime * audioFile.SampleRate;
    playblocking(finalAudio, round(startPosition))
end


handles.songPlaying = 0;





end

