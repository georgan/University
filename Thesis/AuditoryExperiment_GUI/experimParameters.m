function varargout = experimParameters(varargin)
% EXPERIMPARAMETERS M-file for experimParameters.fig
%      EXPERIMPARAMETERS, by itself, creates a new EXPERIMPARAMETERS or raises the existing
%      singleton*.
%
%      H = EXPERIMPARAMETERS returns the handle to a new EXPERIMPARAMETERS or the handle to
%      the existing singleton*.
%
%      EXPERIMPARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPERIMPARAMETERS.M with the given input arguments.
%
%      EXPERIMPARAMETERS('Property','Value',...) creates a new EXPERIMPARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before experimParameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to experimParameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help experimParameters

% Last Modified by GUIDE v2.5 05-Mar-2014 16:03:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @experimParameters_OpeningFcn, ...
                   'gui_OutputFcn',  @experimParameters_OutputFcn, ...
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


% --- Executes just before experimParameters is made visible.
function experimParameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to experimParameters (see VARARGIN)

% Choose default command line output for experimParameters
handles.output = hObject;

N = 3;
a = load(fullfile(varargin{2}, 'completed'), 'completed');
if isempty(a)
    error('No structure found.');
end
a = a.completed;

experiment = varargin{1};
if a(experiment.index,1) == 3
    set(handles.pushbutton5, 'Enable', 'off');
end
if a(experiment.index,2) == 3
    set(handles.pushbutton6, 'Enable', 'off');
end
if a(experiment.index,3) == 3
    set(handles.pushbutton7, 'Enable', 'off');
end

set(handles.remain1, 'String', ['Remaining Trials: ' num2str(N-a(experiment.index, 1))]);
set(handles.remain2, 'String', ['Remaining Trials: ' num2str(N-a(experiment.index, 2))]);
set(handles.remain3, 'String', ['Remaining Trials: ' num2str(N-a(experiment.index, 3))]);

enable.Primary = 0;
enable.Peripheral = 0;
enable.Dual = 0;
setappdata(handles.output, 'enable', enable);

score.Primary = 0;
score.Peripheral = 0;
score.Dual = 0;
setappdata(handles.output, 'score', score);

validTerm.Primary = a(experiment.index, 1);
validTerm.Peripheral = a(experiment.index, 2);
validTerm.Dual = a(experiment.index, 3);
validTerm.number = sum(a(experiment.index,:));
setappdata(handles.output, 'ValidTermination', validTerm);

checkmousepress(hObject, eventdata, handles);

% playtarget = 1; playnontarget = 1;
defaultToneDur = 250;    % in ms
defaultGapDur = 10;
if length(varargin) < 1 % order has not been defined here
    setappdata(handles.output, 'experiment', 'TonesOnNoise');
else
    setappdata(handles.output, 'experiment', varargin{1});
    setappdata(handles.output, 'folder', varargin{2});
end

% set(handles.popupmenu2, 'String', {'Right', 'Left', 'Both'});
set(handles.popupmenu1, 'Value', 1);
% set(handles.pushbutton1, 'String', 'Help');
minDur = str2num(get(handles.toneMinDur, 'String'));
maxDur = str2num(get(handles.toneMaxDur, 'String'));
set(handles.slider1, 'Value', (defaultToneDur-minDur)/(maxDur-minDur));
set(handles.toneDur, 'String', num2str(defaultToneDur));

minDur = str2num(get(handles.gapMinDur, 'String'));
maxDur = str2num(get(handles.gapMaxDur, 'String'));
set(handles.slider2, 'Value', (defaultGapDur-minDur)/(maxDur-minDur));
set(handles.gapDur, 'String', num2str(defaultGapDur));
guidata(hObject, handles);

set(handles.pushbutton2, 'Callback', {@targetNonTargetPlay_callback, handles});
set(handles.pushbutton3, 'Callback', {@targetNonTargetPlay_callback, handles});

% the following is temporary.It will change soon...
% children = get(handles.figure1, 'Children');
% for i = 1:length(children)
%     set(children(i), 'ButtonDownFcn', {@figure1_ButtonDownFcn, handles});
% end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes experimParameters wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = experimParameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
uicontrol(handles.popupmenu1);
% saveas(handles.output, mfilename, 'fig');


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

prev = 'Primary';
contents = get(hObject, 'String');
val = get(hObject, 'Value');
% cont = get(handles.popupmenu2, 'String');
% if ~strcmp(contents{val}, prev)
    set(handles.popupmenu2, 'Value', 1);
    if strcmp(contents{val}, 'Dual')
        set(handles.popupmenu2, 'String', {'Right', 'Left'});
    else
        set(handles.popupmenu2, 'String', {'Right', 'Left', 'Both'});
    end
% end


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

val = get(hObject, 'Value');
step = get(hObject, 'Sliderstep');
val = round(val/step(1))*step(1);
minDur = str2num(get(handles.toneMinDur, 'String'));
maxDur = str2num(get(handles.toneMaxDur, 'String'));

set(hObject, 'Value', val);
set(handles.toneDur, 'String', num2str(minDur + val*(maxDur-minDur)));
guidata(handles.output, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

val = get(hObject, 'Value');
step = get(hObject, 'Sliderstep');
val = round(val/step(1))*step(1);
minDur = str2num(get(handles.gapMinDur, 'String'));
maxDur = str2num(get(handles.gapMaxDur, 'String'));

set(hObject, 'Value', val);
set(handles.gapDur, 'String', num2str(round(minDur + val*(maxDur-minDur))));
guidata(handles.output, handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tasks = get(handles.popupmenu1, 'String');
tasksVal = get(handles.popupmenu1, 'Value');
d = getappdata(handles.output, 'experiment');
h = Instructions(tasks{tasksVal}, d.experiment);
setappdata(handles.output, 'newfigure', h);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if playtarget
[s fs] = wavread('lowTone.wav');
player = audioplayer(s, fs);
% else
%     clear playsnd
% end
% playtarget = mod(playtarget+1,2);

% player = audioplayer(s, fs);
% play(player);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if playnontarget
[s fs] = wavread('highTone.wav');
soundsc(s, fs);
% else
%     clear paysnd
% end
% playnontarget = mod(playnontarget+1,2);
% player = audioplayer(s, fs);
% play(player);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tasks = get(handles.popupmenu1, 'String');
tasksVal = get(handles.popupmenu1, 'Value');

side = get(handles.popupmenu2, 'String');
sideVal = get(handles.popupmenu2, 'Value');
d = getappdata(handles.output, 'experiment');
folder = getappdata(handles.output, 'folder');

if strcmp(tasks{tasksVal}, 'Primary') || strcmp(tasks{tasksVal}, 'Dual')
    tonesDur = str2num(get(handles.toneDur, 'String'));
    gapDur = str2num(get(handles.gapDur, 'String'));
%     close(handles.output);
    [signal, fs, tonesNum, t] = makeTrainSamples(tasks{tasksVal}, d.experiment, side{sideVal}, [tonesDur gapDur]/10^3);
else
%     close(handles.output);
    [signal, fs, tonesNum, t] = makeTrainSamples(tasks{tasksVal}, d.experiment, side{sideVal});
end

s.testing = 0;
s.folder = folder;
s.task = tasks{tasksVal};
s.experiment = d.experiment;
s.signal = signal;
s.fs = fs;
s.tonesNumber = tonesNum;
s.t = t;
s.tonesDur = str2num(get(handles.toneDur, 'String'));
setappdata(handles.output, 'data', s);
set(handles.output, 'Visible', 'off');
% close(handles.output);
% experimPlay(signal, tonesNum, t); pause(.1);

experimPlay(handles.output);
% h = Instructions(tasks{tasksVal}, d.experiment);
% setappdata(handles.output, 'newfigure', h);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
testCheck(hObject, handles, 'Primary');

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

testCheck(hObject, handles, 'Peripheral');


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
testCheck(hObject, handles, 'Dual');

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

folder = getappdata(handles.output, 'folder');
d = getappdata(handles.output, 'experiment');
close(handles.output);
experimList(folder, 7-d.index+1);   % change it...


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.output);


function testCheck(hObject, handles, task)
enable = getappdata(handles.output, 'enable');

if ~enable.(task)
    caution(get(handles.output, 'Position'));
else
    a = questdlg('Are you sure, you want to continue?');
    if strcmp(a, 'Yes')
 
        
        if strcmp(task, 'Primary')
            a = strread(get(handles.(['remain' '1']), 'String'), '%s', 'delimiter', ' ');
        elseif strcmp(task, 'Peripheral')
            a = strread(get(handles.(['remain' '2']), 'String'), '%s', 'delimiter', ' ');
        else
            a = strread(get(handles.(['remain' '3']), 'String'), '%s', 'delimiter', ' ');
        end
        
        TestFolder = fullfile('TestSamples', ['Trial' a{end}]);
        
        
        d = getappdata(handles.output, 'experiment');
        s = load(fullfile(TestFolder, d.experiment), task);
        folder = getappdata(handles.output, 'folder');
        
        s = s.(task);
        data.signal = s.signal;
        data.fs = s.fs;
        data.testing = 1;
        data.folder = folder;
        data.task = task;
        data.experiment = d.experiment;
        data.t = s.t;
        data.tonesNumber = s.tonesNumber;
        data.tonesDur = 250;
        setappdata(handles.output, 'data', data);
        vterm = getappdata(handles.output, 'ValidTermination');
        set(handles.output, 'Visible', 'off');
        guidata(handles.output, handles);
        h = experimPlay(handles.output);
        uiwait(h);
        
        validTerm = getappdata(handles.output, 'ValidTermination');
        if validTerm.number > vterm.number
            load(fullfile(folder, 'completed'), 'completed');
            if strcmp(task, 'Primary')
                completed(d.index, 1) = completed(d.index, 1)+1; j = 1;
            elseif strcmp(task, 'Peripheral')
                completed(d.index, 2) = completed(d.index, 2)+1; j = 2;
            else
                completed(d.index, 3) = completed(d.index, 3)+1; j = 3;
            end
            remain = get(handles.(['remain' num2str(j)]), 'String');
            remain = strread(remain, '%s', 'delimiter', ' ');
            remain{end} = num2str(str2num(remain{end})-1);
            set(handles.(['remain' num2str(j)]), 'String', [remain{1} ' ' remain{2} ' ' remain{3}]);
            
            save(fullfile(folder, 'completed'), 'completed');
            uicontrol(handles.popupmenu1);
            if completed(d.index, j) == 3
                set(hObject, 'Enable', 'off');
            end
        end
        
        guidata(handles.output, handles);
        if validTerm.number == 9
            uiwait(msgbox(['Experiment ' num2str(d.index) ' was completed successfully!']));
            % store settings....
            load(fullfile(folder, 'completed'), 'completed');
%             completed(d.index,:) = 1;
%             save(fullfile(folder, 'completed'), 'completed');
            if sum(completed(:)) < 3*numel(completed)
                experimList(folder);
            else
                msgbox(sprintf('Thanks for your participation!\n\n\n The whole experiment was completed successfully!'),...
                    'Thank You!');
            end
            
            rmappdata(handles.output, 'ValidTermination');
            close(handles.output);
        end
    end
end


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% bb = getappdata(handles.output, 'number')


% % --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% % hObject    handle to figure1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% h = getappdata(handles.output, 'number');
% if ishandle(h) & strcmp(get(h,'Type'), 'figure')
%     figure(h)
% %     uicontrol(h);
%     beep;
% end


function targetNonTargetPlay_callback(hObject, eventdata, handles)
global player;


% display('we are here!!!');
% return
if isobject(player) && isplaying(player)
    stop(player);
else
    ch = strread(get(hObject, 'String'), '%s', 'delimiter', ' ');

    tasks = get(handles.popupmenu1, 'String');
    value = get(handles.popupmenu1, 'Value');
    d = getappdata(handles.output, 'experiment');

    if strcmp(d.experiment(end), '1')
        d.experiment = d.experiment(1:end-2);
        if strcmp(ch{2}, 'Target')
            ch{2} = 'Nontarget';
        else
            ch{2} = 'Target';
        end
    end
    
    if strcmp(tasks{value}, 'Primary')
        d.experiment = '';
    else
        tasks{value} = '';
    end
    
    [s fs] = wavread([d.experiment tasks{value} ch{2} '.wav']);
    player = audioplayer(s, fs);
    play(player);
    
end
