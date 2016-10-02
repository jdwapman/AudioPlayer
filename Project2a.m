% Audio Project
% Jonathan Wapman
% Kalie Bonomo
% Anastasia Ptak


function varargout = Project2a(varargin)
% PROJECT2A MATLAB code for Project2a.fig
%      PROJECT2A, by itself, creates a new PROJECT2A or raises the existing
%      singleton*.
%
%      H = PROJECT2A returns the handle to a new PROJECT2A or the handle to
%      the existing singleton*.
%
%      PROJECT2A('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT2A.M with the given input arguments.
%
%      PROJECT2A('Property','Value',...) creates a new PROJECT2A or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Project2a_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Project2a_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Project2a

% Last Modified by GUIDE v2.5 13-Mar-2016 15:29:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Project2a_OpeningFcn, ...
                   'gui_OutputFcn',  @Project2a_OutputFcn, ...
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


%----------------------------------------------------------------
%               HOW TO WORK WITH AUDIO

% Audio samples are stored in handles.soundFile{1:6} as audioplayer objects.
% The audioplayer object's sample rate can be found by typing
% [objectname].SampleRate, and it's data can be found by typing
% [objectname].UserData.

% The currently playing track is stored in handles.currentTrack

% To edit the data in the audioplayer object, extract the sample
% rate and the data using the method shown above. Edit the data as desired,
% and then make a new audioplayer object using the sample rate and the new
% data. In order to make changes non-destructive, attach the original data
% to [newObjectName].UserData.

% To change audio effects during playback, pause the file like this:
%handles.audioPosition = playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause')
%handles.audioPosition stores the current location in the file. Once you
%have set handles.currentTrack to be your new file, resume the track by
%running the command:
% playFile(handles, handles.currentTrack, handles.audioPosition, 'Play')
%Aside from a slight jump in playback when playing and pausing, the
%transition should be smooth and can happen during playback

%If the song is paused while changing effects, you can use
%handles.songPlaying to determine whether to resume playback after
%modifying the audio file. 1 = TRUE and 0 = FALSE


%----------------------------------------------------------------



% --- Executes just before Project2a is made visible.
function Project2a_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Project2a (see VARARGIN)

% Choose default command line output for Project2a
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Project2a wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%----------------------------

clc %Clear command window for new run of project

%Turn button 1 back on
set(handles.audio1, 'Value', 0)

% Set up array storing whether a song is loaded in each audio button
handles.songLoaded(1:9) = 0;
handles.songPlaying = 0; %Keeps track of whether a song is playing. 1 = TRUE, 0 = FALSE

%Ignore custom start/stop times
handles.startTime(1:9) = -1;
handles.endTime(1:9) = -1;

handles.spedUp=0;
% After changing a handles variable, must save it to the handles structure
% using guidata()
guidata(hObject, handles); %Updates handles structure




% --- Outputs from this function are returned to the command line.
function varargout = Project2a_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function timeBar_Callback(hObject, eventdata, handles)
% hObject    handle to timeBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% When dragged, pause music and update position

% First, check to see whether a song has been loaded. If no song has been
% loaded, return the slider to the beginning position and exit the function
if (strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 1) %Checks if a song has been loaded. If 1, no song has been loaded
         %since name of audio button will be 'No File Loaded' if no song is loaded yet
    set(handles.timeBar, 'Value', 0) %Return to original position if attempting to move progress bar with no song loaded
    return % Exit function
end
 
% If the function passes the check for whether an audio file is loaded, first
% pause the file. Then, update the handles variable "audioPosition"
playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause'); %Pause playback when position changed
totalTime = handles.currentTrack.TotalSamples / handles.currentTrack.SampleRate; %Calculate total runtime of audio
handles.audioPosition = totalTime * get(handles.timeBar, 'Value'); %Update the audio track's position based on value of time bar
guidata(hObject, handles); %Updates handle data

% Check if the bar has been dragged to the very end. If it has, end the
% playback
if ( get(handles.timeBar, 'Value') == 1 )
    handles.songPlaying = 0;
end

guidata(hObject, handles); %Updates handle data 

%Update labels. This code also appears in the updateSlider function
%Calculate time into the song
totalTime = handles.currentTrack.TotalSamples / handles.currentTrack.SampleRate; %In seconds
currentTime = totalTime * get(handles.timeBar, 'Value');

[hours, minutes, seconds] = hoursMinsSecs(currentTime);
    
timeElapsedString = strcat(sprintf('%02.0f', hours), ':', sprintf('%02.0f', minutes), ':', sprintf('%02.0f', seconds));
set(handles.timeElapsed, 'String', timeElapsedString)


%Calculate time left in the song
[hoursLeft, minutesLeft, secondsLeft] = hoursMinsSecs(totalTime - currentTime);

timeLeftString = strcat('-', sprintf('%02.0f', hoursLeft), ':', sprintf('%02.0f', minutesLeft), ':', sprintf('%02.0f', secondsLeft));
set(handles.timeLeft, 'String', timeLeftString)

%If the song was playing
if (handles.songPlaying == 1)
    playFile(handles, handles.currentTrack, handles.audioPosition, 'Play')
end

% --- Executes during object creation, after setting all properties.
function timeBar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
        
end


% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of playButton
set(handles.playButton, 'Value', 0)

% Check if audio is at the end of the track
if (get(handles.timeBar, 'Value') > 0.99)
    return
end

% Check if a song is already playing
if (handles.songPlaying == 1)
    return
end

if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded. 0 = File has been loaded
    
    %Process audio filters
    handles.currentTrack = processAudio(hObject, eventdata, handles, handles.currentTrack);

    handles.songPlaying = 1; %Since play button has been pressed, audio is now playing
    guidata(hObject, handles); %Updates handle data 
    playFile(handles, handles.currentTrack, handles.audioPosition, 'Play') %Plays the new file
    
end %Check if no audio file has been opened



% --- Executes on button press in pauseButton.
function pauseButton_Callback(hObject, eventdata, handles)
% hObject    handle to pauseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pauseButton

% Hint: get(hObject,'Value') returns toggle state of playButton
set(handles.pauseButton, 'Value', 0)

if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded, and if it has then...
    
    handles.audioPosition = playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause'); %Pauses the file, update handle variable
    handles.songPlaying = 0; %Song has been paused, so update songPlaying variable
    guidata(hObject, handles); %Updates handle data 
    
end %Check if no audio file has been opened




% --- Executes on selection change in monoStereoMenu.
function monoStereoMenu_Callback(hObject, eventdata, handles)
% hObject    handle to monoStereoMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns monoStereoMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from monoStereoMenu

%First, pause audio. Same code from the pausebutton callback, used to
%update the location in the audio track
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded
    
    handles.audioPosition = playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause'); %Pauses the file, update handle variable
    guidata(hObject, handles); %Updates handle data 
    
end %Check if no audio file has been opened


%Resume playing the audio
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded

 
    handles.currentTrack = processAudio(hObject, eventdata, handles, handles.currentTrack);
    guidata(hObject, handles); %Updates handle data
    
    %If the audio was previously playing, resume the audio
    if (handles.songPlaying == 1)
        playFile(handles, handles.currentTrack, handles.audioPosition, 'Play') %Plays the file
    end
end %Check if no audio file has been opened




% --- Executes during object creation, after setting all properties.
function monoStereoMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monoStereoMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in audio1.
function audio1_Callback(hObject, eventdata, handles)
% hObject    handle to audio1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of audio1

changeButtonColor(hObject, handles) %Deselect all other buttons

changeAudio(hObject, eventdata, handles, 1); %Change audio


% --- Executes on button press in audio2.
function audio2_Callback(hObject, eventdata, handles)
% hObject    handle to audio2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of audio2

changeButtonColor(hObject, handles) %Deselect all other buttons

changeAudio(hObject, eventdata, handles, 2); %Change audio


% --- Executes on button press in audio3.
function audio3_Callback(hObject, eventdata, handles)
% hObject    handle to audio3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of audio3
changeButtonColor(hObject, handles) %Deselect all other buttons

changeAudio(hObject, eventdata, handles, 3); %Change audio


% --- Executes on button press in audio4.
function audio4_Callback(hObject, eventdata, handles)
% hObject    handle to audio4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of audio4

changeButtonColor(hObject, handles) %Deselect all other buttons

changeAudio(hObject, eventdata, handles, 4); %Change audio




% --- Executes on button press in audio5.
function audio5_Callback(hObject, eventdata, handles)
% hObject    handle to audio5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of audio5

changeButtonColor(hObject, handles) %Deselect all other buttons

changeAudio(hObject, eventdata, handles, 5); %Change audio




% --- Executes on button press in audio6.
function audio6_Callback(hObject, eventdata, handles)
% hObject    handle to audio6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of audio6

changeButtonColor(hObject, handles) %Deselect all other buttons

changeAudio(hObject, eventdata, handles, 6); %Change audio



% --- Executes on button press in audio7.
function audio7_Callback(hObject, eventdata, handles)
% hObject    handle to audio7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of audio7

changeButtonColor(hObject, handles) %Deselect all other buttons

changeAudio(hObject, eventdata, handles, 7); %Change audio


% --- Executes on button press in audio8.
function audio8_Callback(hObject, eventdata, handles)
% hObject    handle to audio8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of audio8

changeButtonColor(hObject, handles) %Deselect all other buttons

changeAudio(hObject, eventdata, handles, 8); %Change audio


% --- Executes on button press in audio9.
function audio9_Callback(hObject, eventdata, handles)
% hObject    handle to audio9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of audio9

changeButtonColor(hObject, handles) %Deselect all other buttons

changeAudio(hObject, eventdata, handles, 9); %Change audio


% --- Executes on button press in load1.
function load1_Callback(hObject, eventdata, handles)
% hObject    handle to load1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadFile(hObject, eventdata, handles, 1);

changeButtonColor(hObject, handles); %Deselect all other buttons



% --- Executes on button press in load2.
function load2_Callback(hObject, eventdata, handles)
% hObject    handle to load2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadFile(hObject, eventdata, handles, 2);

changeButtonColor(hObject, handles); %Deselect all other buttons




% --- Executes on button press in load3.
function load3_Callback(hObject, eventdata, handles)
% hObject    handle to load3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadFile(hObject, eventdata, handles, 3);

changeButtonColor(hObject, handles); %Deselect all other buttons


% --- Executes on button press in load4.
function load4_Callback(hObject, eventdata, handles)
% hObject    handle to load4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadFile(hObject, eventdata, handles, 4);

changeButtonColor(hObject, handles); %Deselect all other buttons


% --- Executes on button press in load5.
function load5_Callback(hObject, eventdata, handles)
% hObject    handle to load5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadFile(hObject, eventdata, handles, 5);

changeButtonColor(hObject, handles); %Deselect all other buttons



% --- Executes on button press in load6.
function load6_Callback(hObject, eventdata, handles)
% hObject    handle to load6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadFile(hObject, eventdata, handles, 6);

changeButtonColor(hObject, handles); %Deselect all other buttons


% --- Executes on button press in load7.
function load7_Callback(hObject, eventdata, handles)
% hObject    handle to load7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadFile(hObject, eventdata, handles, 7);

changeButtonColor(hObject, handles); %Deselect all other buttons


% --- Executes on button press in load8.
function load8_Callback(hObject, eventdata, handles)
% hObject    handle to load8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadFile(hObject, eventdata, handles, 8);

changeButtonColor(hObject, handles); %Deselect all other buttons


% --- Executes on button press in load9.
function load9_Callback(hObject, eventdata, handles)
% hObject    handle to load9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadFile(hObject, eventdata, handles, 9);

changeButtonColor(hObject, handles); %Deselect all other buttons


% --- Executes on button press in voiceRemovalOption.
function voiceRemovalOption_Callback(hObject, eventdata, handles)
% hObject    handle to voiceRemovalOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of voiceRemovalOption

%First, pause audio. Same code from the pausebutton callback, used to
%update the location in the audio track
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded
    
    handles.audioPosition = playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause'); %Pauses the file, update handle variable
    guidata(hObject, handles); %Updates handle data 
    
end %Check if no audio file has been opened

%Resume playing the audio
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded

    handles.currentTrack = processAudio(hObject, eventdata, handles, handles.currentTrack);
    guidata(hObject, handles); %Updates handle data
    
    %If the audio was previously playing, resume the audio
    if (handles.songPlaying == 1)
        playFile(handles, handles.currentTrack, handles.audioPosition, 'Play') %Plays the file
    end
    
end %Check if no audio file has been opened


 

% --- Executes on button press in reverseOptionButton.
function reverseOptionButton_Callback(hObject, eventdata, handles)
% hObject    handle to reverseOptionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of reverseOptionButton

%First, pause audio. Same code from the pausebutton callback, used to
%update the location in the audio track
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded
    
    handles.audioPosition = playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause'); %Pauses the file, update handle variable
    guidata(hObject, handles); %Updates handle data 
    
end %Check if no audio file has been opened

%Resume playing the audio
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded

    handles.currentTrack = processAudio(hObject, eventdata, handles, handles.currentTrack);
    guidata(hObject, handles); %Updates handle data
    
    %If the audio was previously playing, resume the audio
    if (handles.songPlaying == 1)
        playFile(handles, handles.currentTrack, handles.audioPosition, 'Play') %Plays the file
    end
    
end %Check if no audio file has been opened





% --- Executes on button press in delayOptionButton.
function delayOptionButton_Callback(hObject, eventdata, handles)
% hObject    handle to delayOptionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of delayOptionButton
% delayToggle=get(hObject,'Value');

%First, pause audio. Same code from the pausebutton callback, used to
%update the location in the audio track
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded
    
    handles.audioPosition = playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause'); %Pauses the file, update handle variable
    guidata(hObject, handles); %Updates handle data 
    
end %Check if no audio file has been opened

%Resume playing the audio
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded

    handles.currentTrack = processAudio(hObject, eventdata, handles, handles.currentTrack);
    guidata(hObject, handles); %Updates handle data
    
    %If the audio was previously playing, resume the audio
    if (handles.songPlaying == 1)
        playFile(handles, handles.currentTrack, handles.audioPosition, 'Play') %Plays the file
    end
    
end %Check if no audio file has been opened
        

 
% --- Executes on slider movement.
function volumeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to volumeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%First, pause audio. Same code from the pausebutton callback, used to
%update the location in the audio track
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded
    
    handles.audioPosition = playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause'); %Pauses the file, update handle variable
    guidata(hObject, handles); %Updates handle data 
    
end %Check if no audio file has been opened

%Resume playing the audio
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded

    handles.currentTrack = processAudio(hObject, eventdata, handles, handles.currentTrack);
    guidata(hObject, handles); %Updates handle data
    
    %If the audio was previously playing, resume the audio
    if (handles.songPlaying == 1)
        playFile(handles, handles.currentTrack, handles.audioPosition, 'Play') %Plays the file
    end
    
end %Check if no audio file has been opened




% --- Executes during object creation, after setting all properties.
function volumeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volumeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end






function editSpeedInput_Callback(hObject, eventdata, handles)
% hObject    handle to editSpeedInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSpeedInput as text
%        str2double(get(hObject,'String')) returns contents of editSpeedInput as a double

%The sampling frequency fs tells us how much time goes between each sample (T=1/fs).  
%If we play the song with more or less time between samples than was originally there when recorded,

%Pause the song and update the audio position
handles.audioPosition=playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause');
%Update handle data
guidata(hObject,handles);

%returns the user input for speed selection as double
speedValue=str2double(get(hObject,'String'))

%get current track data
speedData=handles.currentTrack.UserData;
fs=handles.currentTrack.SampleRate;


%change speed of the track
handles.currentTrack=audioplayer(speedData,fs*speedValue);


%check if song was playing when the reverse button was pressed
if(handles.songPlaying==1)
    %continue to play the song if it was playing previously
    playFile(handles, handles.currentTrack, handles.audioPosition, 'Play')
end

%save original track
handles.currentTrack.UserData=speedData;
handles.currentTrack.SampleRate=fs;
%update handles
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function editSpeedInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSpeedInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function startTimeButton_Callback(hObject, eventdata, handles)
% hObject    handle to startTimeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calculate new start time
if (handles.startTime == -1) %If the start time has not already 
    startTime = length(handles.currentTrack.UserData) / handles.currentTrack.SampleRate * get(handles.timeBar, 'Value');
    changeTime = startTime;
else
    changeTime = ((handles.endTime(handles.trackPlaying) - handles.startTime(handles.trackPlaying) ) * get(handles.timeBar, 'Value'));
    startTime = changeTime + handles.startTime(handles.trackPlaying);
end

set(handles.startTimeOption, 'String', sprintf('%.2f', changeTime));

function endTimeButton_Callback(hObject, eventdata, handles)
% hObject    handle to startTimeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calculate new end time
if (handles.endTime == -1) %If the start time has not already 
    endTime = length(handles.currentTrack.UserData) / handles.currentTrack.SampleRate * get(handles.timeBar, 'Value');
    changeTime = endTime;
else
    changeTime = ((handles.endTime(handles.trackPlaying) - handles.startTime(handles.trackPlaying) ) * get(handles.timeBar, 'Value')); 
    endTime = handles.endTime(handles.trackPlaying) - changeTime;
end

set(handles.endTimeOption, 'String', sprintf('%.2f', changeTime));



function startTimeOption_Callback(hObject, eventdata, handles)
% hObject    handle to startTimeOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % Hints: get(hObject,'String') returns contents of startTimeOption as text
% %        str2double(get(hObject,'String')) returns contents of startTimeOption as a double
% 
% %get contents of text (start time)

startString = get(handles.startTimeOption, 'String');
startTime = str2num(startString);

%Error Check
if (startTime < 0)
    startTime = 0;
end

startString = sprintf('%.0f', startTime);
set(handles.startTimeOption, 'String', startString)





% --- Executes during object creation, after setting all properties.
function startTimeOption_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startTimeOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endTimeOption_Callback(hObject, eventdata, handles)
% hObject    handle to endTimeOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endTimeOption as text


if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded
    
    endString = get(handles.endTimeOption, 'String');
    endTime = str2num(endString);

    songLength = handles.currentTrack.TotalSamples / handles.currentTrack.SampleRate; %In seconds

    %Error Check
    if (endTime < 0)
        endTime = songLength;
    end

    if (endTime > songLength)
        endTime = songLength;
    end

    endString = sprintf('%.0f', endTime);
    set(handles.endTimeOption, 'String', endString)

end



% --- Executes during object creation, after setting all properties.
function endTimeOption_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endTimeOption (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in cropButton.
function cropButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%update saved track to be the current track
%handles.soundFile{}=handles.currentTrack
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded
    
    %Pauses file
    playFile(handles, handles.currentTrack, 0, 'Pause');

    % Extract data
    soundData = handles.currentTrack.UserData;
    fs = handles.currentTrack.SampleRate;
    
    %Get new start and stop times
    startString = get(handles.startTimeOption, 'String');
    endString = get(handles.endTimeOption, 'String');
    
    %Start Time
    if ( strcmp( startString, '(In Seconds)' ) == 0 ) %If a value for cropping has been chosen in the text box          
        startTime = str2num(startString);      
    else %If no value has been entered
        startTime = 0;      
    end
    
    %End Time
    if ( strcmp( endString, '(In Seconds)' ) == 0 ) %If a value for cropping has been chosen
        endTime = str2num(endString);
    else %If no value has been entered
        endTime = length(handles.currentTrack.UserData) / handles.currentTrack.SampleRate; % Total length of song    
    end
    
    %Reset UI
    set(handles.startTimeOption, 'String', '(In Seconds)')
    set(handles.endTimeOption, 'String', '(In Seconds)')
    
    %If end time is smaller than the start time, ignore the changes
    
    %Save start and end times, for processing later
    if (startTime < endTime)
        handles.startTime(handles.trackPlaying) = startTime;
        handles.endTime(handles.trackPlaying) = endTime;
    end
    
    % Update handles data
    guidata(hObject,handles);

    %Switch to the new cropped audio track
    changeAudio(hObject, eventdata, handles, handles.trackPlaying);
    
    
end

function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded

    %Reset stop and start points
    handles.startTime(handles.trackPlaying) = -1;
    handles.endTime(handles.trackPlaying) = -1;

    % Update handles data
    guidata(hObject,handles);

    % Change audio
    changeAudio(hObject, eventdata, handles, handles.trackPlaying);

end



function speedValue_Callback(hObject, eventdata, handles)
% hObject    handle to speedValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speedValue as text
%        str2double(get(hObject,'String')) returns contents of speedValue as a double

% %Pause the song and update the audio position
% handles.audioPosition=playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause');
% %Update handle data
% guidata(hObject,handles);
% 
% %returns the user input for speed selection as text
% get(hObject,'String');
% %turn this text into double so we can use it 
% speedValue=str2double(get(hObject,'String'));
% 
% %get current track data
% speedData=handles.currentTrack.UserData;
% fs=handles.currentTrack.SampleRate;
% 
% %change speed of the track
% handles.currentTrack=audioplayer(speedData,fs/speedValue);
% 
% %keep original track
% handles.currentTrack.UserData=speedData;
% %update handles
% guidata(hObject,handles);
% 
% %check if song was playing when the reverse button was pressed
% if(handles.songPlaying==1)
%     %continue to play the song if it was playing previously
%     playFile(handles, handles.currentTrack, handles.audioPosition, 'Play')
% end

%First, pause audio. Same code from the pausebutton callback, used to
%update the location in the audio track
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded
    
    handles.audioPosition = playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause'); %Pauses the file, update handle variable
    guidata(hObject, handles); %Updates handle data 
    
end %Check if no audio file has been opened

%Resume playing the audio
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded

    handles.currentTrack = processAudio(hObject, eventdata, handles, handles.currentTrack);
    guidata(hObject, handles); %Updates handle data
    
    %If the audio was previously playing, resume the audio
    if (handles.songPlaying == 1)
        playFile(handles, handles.currentTrack, handles.audioPosition, 'Play') %Plays the file
    end
    
end %Check if no audio file has been opened



% --- Executes during object creation, after setting all properties.
function speedValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speedValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%get value for tone
tone=get(hObject,'Value');

%Pause the song and update the audio position
handles.audioPosition=playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause');
%Update handle data
guidata(hObject,handles);

%get current track data
toneDataOriginal=handles.currentTrack.UserData;
fs=handles.currentTrack.SampleRate;

%make editable track
toneTrack=toneDataOriginal;

for n=2:length(toneDataOriginal)
    toneTrack(n,1)=tone*toneTrack(n-1,1)+toneDataOriginal(n,1); % left
    toneTrack(n,2)=tone*toneTrack(n-1,2)+toneDataOriginal(n,2); % right
end


%update the current track to the reversed track
handles.currentTrack=audioplayer(toneTrack,fs);
%save original track
handles.currentTrack.UserData=toneDataOriginal;
%update handles
guidata(hObject,handles);

%check if song was playing when the reverse button was pressed
if(handles.songPlaying==1)
    %continue to play the song if it was playing previously
    playFile(handles, handles.currentTrack, handles.audioPosition, 'Play')
end




% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in C4.
function C4_Callback(hObject, eventdata, handles)
% hObject    handle to C4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 261.63; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 261.63; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 261.63; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end
    
    
    % --- Executes on button press in D4.
function D4_Callback(hObject, eventdata, handles)
% hObject    handle to D4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 293.66; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 293.66; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 293.66; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end

% --- Executes on button press in E4.
function E4_Callback(hObject, eventdata, handles)
% hObject    handle to E4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 329.63; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 329.63; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 329.63; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end


% --- Executes on button press in F4.
function F4_Callback(hObject, eventdata, handles)
% hObject    handle to F4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 349.23; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 349.23; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 349.23; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end


% --- Executes on button press in G4.
function G4_Callback(hObject, eventdata, handles)
% hObject    handle to G4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 392.00; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 392.00; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 392.00; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end


% --- Executes on button press in A4.
function A4_Callback(hObject, eventdata, handles)
% hObject    handle to A4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 440.00; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 440.00; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 440.00; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end


% --- Executes on button press in B4.
function B4_Callback(hObject, eventdata, handles)
% hObject    handle to B4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 493.88; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 493.88; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 493.88; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end


% --- Executes on button press in C5.
function C5_Callback(hObject, eventdata, handles)
% hObject    handle to C5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 523.25; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 523.25; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 523.25; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end

% --- Executes on button press in D5.
function D5_Callback(hObject, eventdata, handles)
% hObject    handle to D5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 587.33; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 587.33; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 587.33; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end


% --- Executes on button press in E5.
function E5_Callback(hObject, eventdata, handles)
% hObject    handle to E5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 659.25; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 659.25; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 659.25; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end


% --- Executes on button press in F5.
function F5_Callback(hObject, eventdata, handles)
% hObject    handle to F5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 698.46; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 698.46; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 698.46; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end


% --- Executes on button press in G5.
function G5_Callback(hObject, eventdata, handles)
% hObject    handle to G5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 783.99; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 783.99; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 783.99; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end


% --- Executes on button press in A5.
function A5_Callback(hObject, eventdata, handles)
% hObject    handle to A5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 880.00; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 880.00; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 880.00; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end


% --- Executes on button press in B5.
function B5_Callback(hObject, eventdata, handles)
% hObject    handle to B5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 987.77; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 987.77; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 987.77; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end

% --- Executes on button press in C6.
function C6_Callback(hObject, eventdata, handles)
% hObject    handle to C6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 1046.5; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 1046.5; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 1046.5; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end

% --- Executes on button press in Db4.
function Db4_Callback(hObject, eventdata, handles)
% hObject    handle to Db4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 277.18; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 277.18; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 277.18; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end

% --- Executes on button press in Eb4.
function Eb4_Callback(hObject, eventdata, handles)
% hObject    handle to Eb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 311.13; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 311.13; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 311.13; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end 


% --- Executes on button press in Gb4.
function Gb4_Callback(hObject, eventdata, handles)
% hObject    handle to Gb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 369.99; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 369.99; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 369.99; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end

% --- Executes on button press in Ab4.
function Ab4_Callback(hObject, eventdata, handles)
% hObject    handle to Ab4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 415.30; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 415.30; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 415.30; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end

% --- Executes on button press in Bb4.
function Bb4_Callback(hObject, eventdata, handles)
% hObject    handle to Bb4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 466.16; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 466.16; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 466.16; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end

% --- Executes on button press in Db5.
function Db5_Callback(hObject, eventdata, handles)
% hObject    handle to Db5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 554.37; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 554.37; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 554.37; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end

% --- Executes on button press in Eb5.
function Eb5_Callback(hObject, eventdata, handles)
% hObject    handle to Eb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 622.25; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 622.25; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 622.25; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end

% --- Executes on button press in Gb5.
function Gb5_Callback(hObject, eventdata, handles)
% hObject    handle to Gb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 739.99; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 739.99; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 739.99; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end

% --- Executes on button press in Ab5.
function Ab5_Callback(hObject, eventdata, handles)
% hObject    handle to Ab5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 830.61; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 830.61; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 830.61; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end

% --- Executes on button press in Bb5.
function Bb5_Callback(hObject, eventdata, handles)
% hObject    handle to Bb5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.sinebutton,'Value') == 1);
fs = 44100; % Hz
t = 0:1/fs:0.4; % seconds
f = 932.33; % Hz
y = sin(2.*pi.*f.*t);
sound(y,fs,16);
else if (get(handles.squarewave,'Value') == 1);
    fs = 44100; % Hz
    t = 0:1/fs:0.4; % seconds
    f = 932.33; % Hz
    y = square(2.*pi.*f.*t);
    sound(y,fs,16);
    else (get(handles.sawtoothwave,'Value') == 1);
        fs = 44100; % Hz
        t = 0:1/fs:0.4; % seconds
        f = 932.33; % Hz
        y = sawtooth(2.*pi.*f.*t);
        sound(y,fs,16);
    end
end


% --- Executes on button press in sinebutton.
function sinebutton_Callback(hObject, eventdata, handles)
% hObject    handle to sinebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sinebutton


% --- Executes on button press in squarewave.
function squarewave_Callback(hObject, eventdata, handles)
% hObject    handle to squarewave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of squarewave


% --- Executes on button press in sawtoothwave.
function sawtoothwave_Callback(hObject, eventdata, handles)
% hObject    handle to sawtoothwave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sawtoothwave


% --- Executes on button press in Gb.
function Gb_Callback(hObject, eventdata, handles)
% hObject    handle to Gb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in speedUp.
function speedUp_Callback(hObject, eventdata, handles)
% hObject    handle to speedUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of speedUp
handles.speedUpToggle=get(hObject,'Value');

if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0; %Checks if a song has been loaded
    
    handles.audioPosition = playFile(handles, handles.currentTrack, handles.audioPosition, 'Pause'); %Pauses the file, update handle variable
    guidata(hObject, handles); %Updates handle data 
    
end %Check if no audio file has been opened

    

%Resume playing the audio
if strcmp(get(handles.audioName, 'String'), 'No File Loaded') == 0 %Checks if a song has been loaded

    handles.currentTrack = processAudio(hObject, eventdata, handles, handles.currentTrack);
    guidata(hObject, handles); %Updates handle data
    
    %If the audio was previously playing, resume the audio
    if (handles.songPlaying == 1)
        playFile(handles, handles.currentTrack, handles.audioPosition, 'Play') %Plays the file
    end
    
    
end %Check if no audio file has been opened
        

 
