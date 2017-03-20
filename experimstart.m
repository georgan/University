function varargout = experimstart(varargin)
% EXPERIMSTART M-file for experimstart.fig
%      EXPERIMSTART, by itself, creates a new EXPERIMSTART or raises the existing
%      singleton*.
%
%      H = EXPERIMSTART returns the handle to a new EXPERIMSTART or the handle to
%      the existing singleton*.
%
%      EXPERIMSTART('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPERIMSTART.M with the given input arguments.
%
%      EXPERIMSTART('Property','Value',...) creates a new EXPERIMSTART or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before experimstart_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to experimstart_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help experimstart

% Last Modified by GUIDE v2.5 10-Mar-2014 17:57:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @experimstart_OpeningFcn, ...
                   'gui_OutputFcn',  @experimstart_OutputFcn, ...
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


% --- Executes just before experimstart is made visible.
function experimstart_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to experimstart (see VARARGIN)

% Choose default command line output for experimstart
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
if isdir('Subject')
    intro;
    close(handles.figure1);
end

% UIWAIT makes experimstart wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = experimstart_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

% get(hObject), isobject(hObject)

if ishandle(hObject)
varargout{1} = handles.output;
uicontrol(handles.pushbutton1);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

intro;
close(handles.output);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.output);
