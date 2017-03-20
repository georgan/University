function varargout = experimList(varargin)
% EXPERIMLIST M-file for experimList.fig
%      EXPERIMLIST, by itself, creates a new EXPERIMLIST or raises the existing
%      singleton*.
%
%      H = EXPERIMLIST returns the handle to a new EXPERIMLIST or the handle to
%      the existing singleton*.
%
%      EXPERIMLIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPERIMLIST.M with the given input arguments.
%
%      EXPERIMLIST('Property','Value',...) creates a new EXPERIMLIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before experimList_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to experimList_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help experimList

% Last Modified by GUIDE v2.5 10-Feb-2014 19:19:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @experimList_OpeningFcn, ...
                   'gui_OutputFcn',  @experimList_OutputFcn, ...
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


% --- Executes just before experimList is made visible.
function experimList_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to experimList (see VARARGIN)

% Choose default command line output for experimList
handles.output = hObject;

% varargin{1}   folder

if isempty(varargin)
    varargin{1} = 'Subject';
end

a = load(fullfile(varargin{1}, 'completed'), 'completed');
if isempty(a)
    error('No structure found.');
end
a = a.completed;

children = get(handles.uipanel1, 'Children');
if length(children) ~= size(a, 1)
    error('Number of experiments on the list is not equal to the stored number...');
end

l = length(a);
for i = 1:l
%     display(get(children(l-i+1), 'String'));
    if sum(a(i,:)) == 3*length(a(i,:))
        set(children(l-i+1), 'Enable', 'off')
    end
end

if length(varargin) == 2
    i = varargin{2};
else
    i = l;
    while i > 0 && strcmp(get(children(i), 'Enable'), 'off')
        i = i-1;
    end
end

if i <= 0
    msgbox(sprintf('Thanks for your participation!\n\n\n The whole experiment was completed successfully!'));
    close(handles.output);
    return
end

set(children(i), 'Value', 1);
uicontrol(children(i));

i = 1;                          % choose one of possible orders
order = load('ExperimentOrders', ['order' num2str(i)]);
order = eval(['order.order' num2str(i)]);
setappdata(handles.output, 'order', order);
setappdata(handles.output, 'folder', varargin{1});
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes experimList wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = experimList_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;
% saveas(handles.output, mfilename, 'fig');

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

i = 1;
while ~get(eval(['handles.radiobutton' num2str(i)]), 'Value')
    i = i+1;
end

order = getappdata(handles.output, 'order');
d.experiment = order{i}; d.index = i;
experimParameters(d, getappdata(handles.output, 'folder'));
close(handles.output);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% display('Saving and Terminating...');
close(handles.output);


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
