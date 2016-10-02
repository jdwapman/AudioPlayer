function updateSlider(obj, event, handles, audioFile, totalTime)
% updateSlider This function is called every 0.05 seconds by an audioplayer
% object. When it is run, it slightly increments the position of the
% slider, and changes the text of the time labels to match the position in
% the song

%Calculate new position to move slider to, and check that it is in
%bounds

currentPosition = get(handles.timeBar, 'Value'); %Gets current position of the slider
newPosition = currentPosition + audioFile.TimerPeriod / totalTime; %Calculates position to move the slider to

%Check that newPosition is within min/max bounds
if (newPosition > 1)
    newPosition = 1;
end

set(handles.timeBar, 'Value', newPosition); %Updates position of the slider

% Change numbers

% %First, calculate the time into the song
totalTime = audioFile.TotalSamples / audioFile.SampleRate; %In seconds
currentTime = totalTime * newPosition; % 0 < newPosition < 1
 
%Update labels

%Calculate time into the song
[hours, minutes, seconds] = hoursMinsSecs(currentTime);

% Update time label
timeElapsedString = strcat(sprintf('%02.0f', hours), ':', sprintf('%02.0f', minutes), ':', sprintf('%02.0f', seconds));
set(handles.timeElapsed, 'String', timeElapsedString)


%Calculate time left in the song
[hoursLeft, minutesLeft, secondsLeft] = hoursMinsSecs(totalTime - currentTime);

% Update time label
timeLeftString = strcat('-', sprintf('%02.0f', hoursLeft), ':', sprintf('%02.0f', minutesLeft), ':', sprintf('%02.0f', secondsLeft));
set(handles.timeLeft, 'String', timeLeftString)