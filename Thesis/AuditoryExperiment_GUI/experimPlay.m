function varargout = experimPlay(varargin)
% EXPERIMPLAY M-file for experimPlay.fig
%      EXPERIMPLAY, by itself, creates a new EXPERIMPLAY or raises the existing
%      singleton*.
%
%      H = EXPERIMPLAY returns the handle to a new EXPERIMPLAY or the handle to
%      the existing singleton*.
%
%      EXPERIMPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPERIMPLAY.M with the given input arguments.
%
%      EXPERIMPLAY('Property','Value',...) creates a new EXPERIMPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before experimPlay_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to experimPlay_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help experimPlay

% Last Modified by GUIDE v2.5 10-Mar-2014 21:49:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @experimPlay_OpeningFcn, ...
                   'gui_OutputFcn',  @experimPlay_OutputFcn, ...
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


% --- Executes just before experimPlay is made visible.
function experimPlay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to experimPlay (see VARARGIN)

% Choose default command line output for experimPlay
handles.output = hObject;
% if length(varargin) < 3
%     error('Not enough input arguments.');
% end

% data.signal = varargin{1};
% data.tonesNumber = varargin{2};
% data.time = varargin{3};
if length(varargin) < 1
    data.testing = 0;
    data.task = 'Peripheral';
    data.experiment = 'TonesOnNoise';
    [s fs tonesNum t] = makeTrainSamples(data.task, data.experiment, 'Left', [.25 .01]);
    data.signal = s;
    data.tonesNumber = tonesNum;
    data.t = t;
    data.fs = fs;
    setappdata(handles.output, 'data', data);
else
    setappdata(handles.output, 'data', getappdata(varargin{1}, 'data'));
    setappdata(handles.output, 'handle', varargin{1});
%     setappdata(handles.output, 'newfigure', getappdata(varargin{1}, 'newfigure'));
end
% checkmousepress(hObject, eventdata, handles);
% set(hObject, 'ButtonDownFcn', {@buttonFcn, handles});
% set(handles.pushbutton1, 'ButtonDownFcn', {@buttonFcn, handles});

% f = figure('Visible', 'off');
% maximize(f);
% s = get(f, 'Position');
% close(f);
% size = get(0, 'ScreenSize');
% set(hObject, 'Units', 'normalized');
% set(hObject, 'Position', size);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes experimPlay wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = experimPlay_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;% fr = get(handle(handles.output), 'Java');
jframe = get(handle(handles.output), 'Javaframe');
jframe.setMaximized(true);
uicontrol(handles.pushbutton1);
data = getappdata(handles.output, 'data');
h = Instructions(data.task, data.experiment);
setappdata(handles.output, 'newfigure', h);
% size = get(0, 'ScreenSize');
% jframe.setSize(size);
% jframe.setFullScreenWindow();
% saveas(handles.output, mfilename, 'fig');


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global startTime
global TimeMoments
global player

set(handles.text1, 'Visible', 'off');
% set(hObject, 'Enable', 'inactive');
guidata(handles.output, handles);
set(hObject, 'Callback', {@SpaceCallback, handles});
data = getappdata(handles.output, 'data');
pause(.5);
player = audioplayer(data.signal, data.fs);

TimeMoments = [];
play(player); startTime = tic;
guidata(handles.output, handles);

set(player, 'StopFcn', {@TimerStopFcn, handles});


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TimeMoments

def = 250;      % default tone duration in ms
userTonesNumber = str2num(get(handles.edit1, 'String'));
data = getappdata(handles.output, 'data');
prevhandle = getappdata(handles.output, 'handle');

if data.testing
    file = [fullfile(data.folder, 'testing') '.txt'];
else
    file = [fullfile(data.folder, 'training') '.txt'];
end

display('===============================================================')

if strcmp(data.task, 'Primary') || strcmp(data.task, 'Dual')
    dlmwrite(file, [data.experiment ' ' data.task ' ' datestr(fix(clock))], 'delimiter', '', '-append');

    if ~isempty(userTonesNumber)
        % store ....
        dlmwrite(file,[data.tonesNumber userTonesNumber], '-append');
        if ~data.testing
            display(['You counted ' num2str(userTonesNumber)  ' tones out of ' num2str(data.tonesNumber(1)) '.']);
        end
        
        sc = userTonesNumber;
        lowthresh = .8*data.tonesNumber(1);
        upthresh = data.tonesNumber(1)+1;
        
        if strcmp(data.task, 'Dual')
            dlmwrite(file, [length(data.t) data.t], '-append');
            dlmwrite(file, [length(TimeMoments) TimeMoments], '-append');
            perf = checkdualperformance(data.t, TimeMoments);
            if perf < 2
                lowthresh = Inf;
            end
            if ~data.testing
                makeadisplay(data.t, TimeMoments);
            end
        end
        
        
        % attention!!! you must check whether they were trained at the
        % appropriate tone duration or not
        if data.tonesDur > def
            lowthresh = Inf;
        end
        
        validTerm = getappdata(prevhandle, 'ValidTermination');
        if data.testing
            validTerm.number = validTerm.number+1;
            validTerm.(data.task) = 1;
            setappdata(prevhandle, 'ValidTermination', validTerm);
        end
        newf = getappdata(handles.output, 'newfigure');
        if ishandle(newf), close(newf); end
        set(prevhandle, 'Visible', 'on');
%         close(handles.output);
        delete(handles.output);
        
    else
        set(handles.edit1, 'String', '');
        uicontrol(handles.edit1);
        return
    end
    
else
    dlmwrite(file, [data.experiment ' ' data.task ' ' datestr(fix(clock))], 'delimiter', '', '-append');

    lowthresh = length(data.t)-2;
    upthresh = length(data.t)+1;
    sc = length(TimeMoments);
    perf = checkdualperformance(data.t, TimeMoments);
    if perf < lowthresh
        lowthresh = Inf;
    end
    dlmwrite(file, [length(data.t) data.t], '-append');
    dlmwrite(file, [length(TimeMoments) TimeMoments], '-append');
    if ~data.testing
    makeadisplay(data.t, TimeMoments);
    end

    validTerm = getappdata(prevhandle, 'ValidTermination');
    if data.testing
        validTerm.number = validTerm.number+1;
        validTerm.(data.task) = 1;
        setappdata(prevhandle, 'ValidTermination', validTerm);
    end
    newf = getappdata(handles.output, 'newfigure');
    if ishandle(newf), close(newf); end
    set(prevhandle, 'Visible', 'on');
%     close(handles.output);
    delete(handles.output);
end


if ~data.testing
    score = getappdata(prevhandle, 'score');% score.(data.task)
    if sc > lowthresh && upthresh > sc
        score.(data.task) = score.(data.task)+1;
    else
        score.(data.task) = 0;
    end%, score.(data.task), '!'
    setappdata(prevhandle, 'score', score);
    
    enable = getappdata(prevhandle, 'enable');
    enable.(data.task) = score.(data.task) > 1;
    setappdata(prevhandle, 'enable', enable);
    if enable.(data.task) && ~validTerm.(data.task) % there is a problem here
        msgbox(['You can now take the ' data.task ' test!']);
    end
end

% --- Executes on key press with focus on edit1 and none of its controls.
function edit1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

set(handles.pushbutton2, 'Enable', 'on');


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function SpaceCallback(hObject, eventdata, handles)
global startTime
global TimeMoments

t = toc(startTime);
TimeMoments = [TimeMoments t];


function TimerStopFcn(hObject, eventdata, handles)
global startTime
global TimeMoments

pause(1);
set(handles.pushbutton1, 'Enable', 'inactive');

data = getappdata(handles.output, 'data');
% display(num2str(data.t+.5));
% display(num2str(TimeMoments));
if strcmp(data.task, 'Primary') || strcmp(data.task, 'Dual')
    set(handles.text2, 'Visible', 'on');
    set(handles.edit1, 'Visible', 'on');
    uicontrol(handles.edit1);
    set(handles.pushbutton2, 'Visible', 'on');
else
    set(handles.pushbutton2, 'Visible', 'on', 'Enable', 'on');
    uicontrol(handles.pushbutton2);
end
guidata(handles.output, handles);



function makeadisplay(data, udata)

display('Targets appeared at...');
display(num2str(data));
display('Button pressed at...');
display(num2str(udata));



function perf = checkdualperformance(t, TimeMoments)

perf = 0;
gap = 1.3;

for i = 1:length(TimeMoments)
    a = find(TimeMoments(i)-t < gap & TimeMoments(i)-t > 0);
    perf = perf + ~isempty(a);
end


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global player

if isobject(player)
    stop(player)
end

prevhandle = getappdata(handles.output, 'handle');
close(prevhandle);

h = getappdata(handles.output, 'newfigure');
if ishandle(h)
    close(h);
end

delete(hObject);
