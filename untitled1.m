function varargout = untitled1(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled1_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled1_OutputFcn, ...
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



function untitled1_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% initialize
global music1_playing;
global music2_playing;
global music3_playing;
global now_channel;

now_channel = 0;
music1_playing = false;
music2_playing = false;
music3_playing = false;

set(handles.pushbutton_play1, 'Enable', 'off');
set(handles.pushbutton_pause1, 'Enable', 'off');
set(handles.pushbutton_play2, 'Enable', 'off');
set(handles.pushbutton_pause2, 'Enable', 'off');
set(handles.pushbutton_play3, 'Enable', 'off');
set(handles.pushbutton_pause3, 'Enable', 'off');

set(handles.axes_time1,'Xtick',[],'Ytick',[]);
set(handles.axes_fre1,'Xtick',[],'Ytick',[]);
set(handles.axes_time2,'Xtick',[],'Ytick',[]);
set(handles.axes_fre2,'Xtick',[],'Ytick',[]);
set(handles.axes_time3,'Xtick',[],'Ytick',[]);
set(handles.axes_fre3,'Xtick',[],'Ytick',[]);
set(handles.axes_getfre,'Xtick',[],'Ytick',[]);
set(handles.axes_timeplay,'Xtick',[],'Ytick',[]);
set(handles.axes_freplay,'Xtick',[],'Ytick',[]);

handles.music1 = timer;
set(handles.music1, 'ExecutionMode', 'FixedRate');
set(handles.music1, 'Period', 1);
set(handles.music1, 'TimerFcn', {@music1_play, handles});
set(handles.music1, 'TasksToExecute', 100);

handles.music2 = timer;
set(handles.music2, 'ExecutionMode', 'FixedRate');
set(handles.music2, 'Period', 1);
set(handles.music2, 'TimerFcn', {@music2_play, handles});
set(handles.music2, 'TasksToExecute', 100);

handles.music3 = timer;
set(handles.music3, 'ExecutionMode', 'FixedRate');
set(handles.music3, 'Period', 1);
set(handles.music3, 'TimerFcn', {@music3_play, handles});
set(handles.music3, 'TasksToExecute', 100);

handles.modulate = timer;
set(handles.modulate, 'ExecutionMode', 'FixedRate');
set(handles.modulate, 'Period', 1);
set(handles.modulate, 'TimerFcn', {@Modulate, handles});
set(handles.modulate, 'TasksToExecute', 100);

handles.demodulate = timer;
set(handles.demodulate, 'ExecutionMode', 'FixedRate');
set(handles.demodulate, 'Period', 1);
set(handles.demodulate, 'TimerFcn', {@DeModulate, handles});
set(handles.demodulate, 'TasksToExecute', 100);

start(handles.modulate);
start(handles.demodulate);

% Update handles structure
guidata(hObject, handles);


function music1_play(hObject, eventdata, handles)
    global music1_fsall;
    global music1_y;
    
    now1 = get(handles.slider_bar1, 'Value')+1;
    disp(now1);
    now11 = now1 + 44100;
    
    % when out of matrix
    if (now11 >= music1_fsall)
        return
    end
    
    % plot axes_time
    plot(handles.axes_time1, music1_y(now1:now11));
    set(handles.axes_time1,'Xtick',[],'Ytick',[]);

    % plot axes_fre
    Y = fft(music1_y(now1:now11));
    plot(handles.axes_fre1, abs(Y));
    set(handles.axes_fre1,'Xtick',[],'Ytick',[]);
    
    % update slider bar
    set(handles.slider_bar1, 'Value', now11);
    
    
    
function music2_play(hObject, eventdata, handles)
    global music2_fsall;
    global music2_y;
    
    now2 = get(handles.slider_bar2, 'Value')+1;
    now22 = now2 + 44100;
    
    % when out of matrix
    if (now22 >= music2_fsall)
        return
    end
    
    % plot axes_time
    plot(handles.axes_time2, music2_y(now2:now22));
    set(handles.axes_time2,'Xtick',[],'Ytick',[]);

    % plot axes_fre
    Y = fft(music2_y(now2:now22));
    plot(handles.axes_fre2, abs(Y));
    set(handles.axes_fre2,'Xtick',[],'Ytick',[]);
    
    % update slider bar
    set(handles.slider_bar2, 'Value', now22);

    
function music3_play(hObject, eventdata, handles)
    global music3_fsall;
    global music3_y;
    
    now3 = get(handles.slider_bar3, 'Value')+1;
    now33 = now3 + 44100;
    
    % when out of matrix
    if (now33 >= music3_fsall)
        return
    end
    
    % plot axes_time
    plot(handles.axes_time3, music3_y(now3:now33));
    set(handles.axes_time3,'Xtick',[],'Ytick',[]);

    % plot axes_fre
    Y = fft(music3_y(now3:now33));
    plot(handles.axes_fre3, abs(Y));
    set(handles.axes_fre3,'Xtick',[],'Ytick',[]);
    
    % update slider bar
    set(handles.slider_bar3, 'Value', now33);


    
    
function Modulate(hObject, eventdata, handles)
    global music1_fsall;
    global music1_y;
    global music1_playing;
    global music2_fsall;
    global music2_y;
    global music2_playing;
    global music3_fsall;
    global music3_y;
    global music3_playing;
    
    now1 = get(handles.slider_bar1, 'Value')+1;
    now11 = now1 + 44100;
    now2 = get(handles.slider_bar2, 'Value')+1;
    now22 = now2 + 44100;
    now3 = get(handles.slider_bar3, 'Value')+1;
    now33 = now3 + 44100;
    
    if (now11 < music1_fsall) & music1_playing
        Y1 = fft(music1_y(now1:now11));
        Y1 = Y1(22051:44100);
    else
        Y1 = zeros(1, 22050)';
    end
    
    if (now22 < music2_fsall) & music2_playing
        Y2 = fft(music2_y(now2:now22));
        Y2 = Y2(22051:44100);
    else
        Y2 = zeros(1, 22050)';
    end
    
    if (now33 < music3_fsall) & music3_playing
        Y3 = fft(music3_y(now3:now33));
        Y3 = Y3(22051:44100);
    else
        Y3 = zeros(1, 22050)';
    end
    
    global YYY;
    YYY = [Y1; zeros(1, 7950)'; Y2; zeros(1, 7950)'; Y3];
    
    % plot axes_getfre
    plot(handles.axes_getfre, abs(YYY));
    set(handles.axes_getfre,'Xtick',[],'Ytick',[]);
    
    

function DeModulate(hObject, eventdata, handles)
    global now_channel;
    global YYY;
    
   
    
    if now_channel == 1
        fre2 = YYY(1:22050);
        fre1 = fliplr(fre2')';
        now_fre = [fre1; fre2];
        now_time = real(ifft(fre2));
        sound(now_time);
        plot(handles.axes_timeplay, now_time);
        set(handles.axes_timeplay,'Xtick',[],'Ytick',[]);
        plot(handles.axes_freplay, abs(now_fre));
        set(handles.axes_freplay,'Xtick',[],'Ytick',[]);
        
    elseif now_channel == 2
        fre2 = YYY(30000:52050);
        fre1 = fliplr(fre2')';
        now_fre = [fre1; fre2];
        now_time = real(ifft(fre2));
        sound(now_time);
        plot(handles.axes_timeplay, now_time);
        set(handles.axes_timeplay,'Xtick',[],'Ytick',[]);
        plot(handles.axes_freplay, abs(now_fre));
        set(handles.axes_freplay,'Xtick',[],'Ytick',[]);
        
    elseif now_channel == 3
        fre2 = YYY(60000:82050);
        fre1 = fliplr(fre2')';
        now_fre = [fre1; fre2];
        now_time = real(ifft(fre2));
        sound(now_time);
        plot(handles.axes_timeplay, now_time);
        set(handles.axes_timeplay,'Xtick',[],'Ytick',[]);
        plot(handles.axes_freplay, abs(now_fre));
        set(handles.axes_freplay,'Xtick',[],'Ytick',[]);
        
    elseif now_channel == 0
        plot(handles.axes_timeplay, zeros(1, 10));
        set(handles.axes_timeplay,'Xtick',[],'Ytick',[]);
        plot(handles.axes_freplay, zeros(1, 10));
        set(handles.axes_freplay,'Xtick',[],'Ytick',[]);
        return
    end
    
        
        
    
    
    
    
    
    
function varargout =untitled1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function slider_bar1_Callback(hObject, eventdata, handles)




function slider_bar1_CreateFcn(hObject, eventdata, handles)





function pushbutton_play1_Callback(hObject, eventdata, handles)
    global music1_playing;
    if (music1_playing)
        disp('music1 is already palying');
    else
        music1_playing = true;
        start(handles.music1);
        guidata(hObject, handles);
    end



function pushbutton_pause1_Callback(hObject, eventdata, handles)
    global music1_playing;
    if (music1_playing)
        stop(handles.music1);
        music1_playing = false;
        guidata(hObject, handles);
    else
        disp('music1 is already pause');
    end


    
function pushbutton_choose1_Callback(hObject, eventdata, handles)
try
    [FileName,PathName] = uigetfile('.mp3','Please select a mp3 file in music_1 Document');
    [y, Fs] = audioread(strcat(PathName, FileName));
catch
    return
end

set(handles.music1_text, 'String', strcat('[now playing] ', FileName));

global music1_playing;

if (music1_playing)
    stop(handles.music1);
    music1_playing = false;
    set(handles.slider_bar1, 'Value', 0);
end

global music1_y
music1_y = y(:, 1);
y_size = size(y);

global music1_fsall
music1_fsall = y_size(1);

set(handles.pushbutton_play1, 'Enable', 'on');
set(handles.pushbutton_pause1, 'Enable', 'on');
set(handles.slider_bar1, 'Max', music1_fsall);
guidata(hObject, handles);





% --- Executes on slider movement.
function slider_bar2_Callback(hObject, eventdata, handles)
% hObject    handle to slider_bar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_bar2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_bar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function pushbutton_play2_Callback(hObject, eventdata, handles)
    global music2_playing;
    if (music2_playing)
        disp('music2 is already palying');
    else
        music2_playing = true;
        start(handles.music2);
        guidata(hObject, handles);
    end



function pushbutton_pause2_Callback(hObject, eventdata, handles)
    global music2_playing
    if (music2_playing)
        stop(handles.music2);
        music2_playing = false;
        guidata(hObject, handles);
    else
        disp('music2 is already pause');
    end



function pushbutton_choose2_Callback(hObject, eventdata, handles)
try
    [FileName,PathName] = uigetfile('.mp3','Please select a mp3 file in music_2 Document');
    [y, Fs] = audioread(strcat(PathName, FileName));
catch
    return
end


set(handles.music2_text, 'String', strcat('[now playing] ', FileName));

global music2_playing;
if (music2_playing)
    stop(handles.music2);
    music2_playing = false;
    set(handles.slider_bar2, 'Value', 0);
end

global music2_y
music2_y = y(:, 1);
y_size = size(y);

global music2_fsall
music2_fsall = y_size(1);

set(handles.pushbutton_play2, 'Enable', 'on');
set(handles.pushbutton_pause2, 'Enable', 'on');
set(handles.slider_bar2, 'Max', music2_fsall);
guidata(hObject, handles);


% --- Executes on slider movement.
function slider_bar3_Callback(hObject, eventdata, handles)
% hObject    handle to slider_bar3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_bar3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_bar3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function pushbutton_play3_Callback(hObject, eventdata, handles)
    global music3_playing;
    if (music3_playing)
        disp('music3 is already palying');
    else
        music3_playing = true;
        start(handles.music3);
        guidata(hObject, handles);
    end



function pushbutton_pause3_Callback(hObject, eventdata, handles)
    global music3_playing
    if (music3_playing)
        stop(handles.music3);
        music3_playing = false;
        guidata(hObject, handles);
    else
        disp('music3 is already pause');
    end



function pushbutton_choose3_Callback(hObject, eventdata, handles)
try
    [FileName,PathName] = uigetfile('.mp3','Please select a mp3 file in music_3 Document');
    [y, Fs] = audioread(strcat(PathName, FileName));
catch
    return
end

set(handles.music3_text, 'String', strcat('[now playing] ', FileName));

global music3_playing
if (music3_playing)
    stop(handles.music3);
    music3_playing = false;
    set(handles.slider_bar3, 'Value', 0);
end

global music3_y
music3_y = y(:, 1);
y_size = size(y);

global music3_fsall
music3_fsall = y_size(1);

set(handles.pushbutton_play3, 'Enable', 'on');
set(handles.pushbutton_pause3, 'Enable', 'on');
set(handles.slider_bar3, 'Max', music3_fsall);
guidata(hObject, handles);



function axes_time1_CreateFcn(hObject, eventdata, handles)



function pushbutton_channel1_Callback(hObject, eventdata, handles)
    global now_channel;
    now_channel = 1;
    set(handles.text_nowchannel, 'String', 'Channel 1 - 0.001KHZ');
    
    

function pushbutton_channel2_Callback(hObject, eventdata, handles)
    global now_channel;
    now_channel = 2;
    set(handles.text_nowchannel, 'String', 'Channel 2 - 30.001KHZ');



function pushbutton_channel3_Callback(hObject, eventdata, handles)
    global now_channel;
    now_channel = 3;
    set(handles.text_nowchannel, 'String', 'Channel 3 - 60.001KHZ');

    
function pushbutton_off_Callback(hObject, eventdata, handles)
    global now_channel;
    now_channel = 0;
    set(handles.text_nowchannel, 'String', 'OFF');
