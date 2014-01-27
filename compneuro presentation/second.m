function varargout = second(varargin)
% SECOND MATLAB code for second.fig
%      SECOND, by itself, creates a new SECOND or raises the existing
%      singleton*.
%
%      H = SECOND returns the handle to a new SECOND or the handle to
%      the existing singleton*.
%
%      SECOND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SECOND.M with the given input arguments.
%
%      SECOND('Property','Value',...) creates a new SECOND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before second_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to second_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help second

% Last Modified by GUIDE v2.5 21-Feb-2013 06:48:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @second_OpeningFcn, ...
                   'gui_OutputFcn',  @second_OutputFcn, ...
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


function init_graph(handles, id)
global phis;
global s;
global w_s;
global beta;
x = [0 : 0.1 : 10];
y = [0 : 0.1 : 10];
z = zeros(length(x), length(y));
c = zeros(length(x), length(y));
for i = 1:length(x)
    for j = 1:length(y)
        phi = atan2(j, i);
        dist = sqrt(x(i) * x(i) + y(j) * y(j));
        t = dist / s;
        z(i, j) = cos((w_s + beta * s * cos(phi - phis(id))) * t) + cos(w_s * t);
        c(i, j) = z(i, j);
    end
end
if id == 1
    surf(handles.axes1, x, y, z, c);
elseif id == 2
    surf(handles.axes2, x, y, z, c);
else
    surf(handles.axes3, x, y, z, c);
end


function sum_graph(handles)
isused = [get(handles.checkbox1, 'Value') 
    get(handles.checkbox2, 'Value')
    get(handles.checkbox3, 'Value')
    get(handles.checkbox4, 'Value')
    get(handles.checkbox5, 'Value')
    get(handles.checkbox6, 'Value')];
global phis;
global s;
global w_s;
global beta;
beta = 2;                  % DEMO beta
x = [0 : 0.05 : 10];
y = [0 : 0.05 : 10];
z = zeros(length(x), length(y));
c = zeros(length(x), length(y));
for i = 1:length(x)
    for j = 1:length(y)
        
        phi = atan2(j, i);
        dist = sqrt(x(i) * x(i) + y(j) * y(j));

        % DEMO one direction
%        phi = 0;
%        dist = x(i);
        
        t = dist / s;
        z(i, j) = 1;
        for id = 1 : length(isused)
            if isused(id)
                z(i, j) = z(i, j) * (cos((w_s + beta * s * cos(phi - phis(id))) * t) + cos(w_s * t));
            end
        end
        c(i, j) = z(i, j);
    end
end
surf(handles.sumaxes, x, y, z, c);


% --- Executes just before second is made visible.
function second_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to second (see VARARGIN)

global phis;
global beta;
global w_s;
global s;
%
% FOR DEMO TRY 0, 10, 20, etc
% also 20, 40, 80 etc
%
degs = [0 60 120 180 240 300]
phis = degs / 360. * pi * 2;
beta = 2;
w_s = 15; % ???
s = 1;  % ???

init_graph(handles, 1);
init_graph(handles, 2);
init_graph(handles, 3);

sum_graph(handles);

% Choose default command line output for second
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes second wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = second_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
sum_graph(handles);
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6
