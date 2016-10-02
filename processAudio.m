function [ processedAudio ] = processAudio( hObject, event, handles, tempAudio )
%processAudio Summary of this function goes here
%   Accepts an audioplayer object



%First, pause audio. Same code from the pausebutton callback, used to
%update the location in the audio track
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded
    
    handles.audioPosition = playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause'); %Pauses the file, update handle variable
    guidata(hObject, handles); %Updates handle data 
    
end %Check if no audio file has been opened


if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded

    
%---EXTRACT----------------------------------------------------------------
    tempData = tempAudio.UserData;
    tempSampleRate = tempAudio.SampleRate;
    
%---CHANGE SPEED-----------------------------------------------------------



if (( get(handles.speedUp, 'Value') == 1))
   tempSampleRate = 2 * handles.originalSampleRate(handles.trackPlaying);
end

if (( get(handles.speedUp, 'Value') == 0))
   tempSampleRate = handles.originalSampleRate(handles.trackPlaying);

end
    
%---CROP-------------------------------------------------------------------

if (handles.startTime(handles.trackPlaying) ~= -1)
    tempData( 1 : round(handles.startTime(handles.trackPlaying) * tempSampleRate) + 1, :) = []; %Crop beginning
    
    tempData(round(handles.endTime(handles.trackPlaying) * tempSampleRate) : end, :) = [];
    
    
end
    
    
%---VOICE REMOVAL----------------------------------------------------------

    %get toggle state
    voiceToggle=get(handles.voiceRemovalOption,'Value');

    %isolate mono left and right
    left=tempData(:,1);
    right=tempData(:,2);

    %check if toggled on
    if voiceToggle==1;
        %update the current track to the track with removed voice
        tempData = left - right; 
        
    else
        %play without voice removal if not toggled on
        tempData = tempData;
    end


    %PROBLEM: When using a wav file that wasn't in the doc example, sometimes
    %get 'index exceeds matrix dimensions' error

    
%----MONO/STEREO

    if ( get(handles.monoStereoMenu, 'Value') == 1 ) % Checks if audio is mono
        tempData = tempData(:,1); %Make mono audio   
    end
    
%---DELAY

delayToggle=get(handles.delayOptionButton,'Value');

if (delayToggle == 1)
    %Pause the song and update the audio position
    handles.audioPosition=playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause');
    %Update handle data
    guidata(hObject,handles);

    %get current track data
    delayData1 = tempData;

    %make an identical track that has time delay
    delayData2=delayData1;
    %set delay amount (N/fs seconds)
    N=10000;  

    %make delayed track
    for n=N+1:length(delayData1)
        delayData2(n)=delayData1(n)+delayData1(n-N);
    end

    tempData = delayData2;
end         
       

%---VOLUME-----------------------------------------------------------------
    volumePosition=get(handles.volumeSlider,'Value');
    minVolume=get(handles.volumeSlider,'Min');
    maxVolume=get(handles.volumeSlider,'Max');
    volume=volumePosition;
    
    %change the volume of the track
    tempData = volume * tempData;
    
%---REVERSE----------------------------------------------------------------
    
if ( get(handles.reverseOptionButton, 'Value') == 1)
    tempData = flipud(tempData);
end

  
%---CREATE NEW AUDIOPLAYER-------------------------------------------------
    processedAudio = audioplayer(tempData, tempSampleRate);
    processedAudio.UserData = tempAudio.UserData;
    
end %Check if no audio file has been opened
