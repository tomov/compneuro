function varargout = first(varargin)
% FIRST MATLAB code for first.fig
%      FIRST, by itself, creates a new FIRST or raises the existing
%      singleton*.
%
%      H = FIRST returns the handle to a new FIRST or the handle to
%      the existing singleton*.
%
%      FIRST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIRST.M with the given input arguments.
%
%      FIRST('Property','Value',...) creates a new FIRST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before first_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to first_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help first

% Last Modified by GUIDE v2.5 20-Feb-2013 00:20:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @first_OpeningFcn, ...
                   'gui_OutputFcn',  @first_OutputFcn, ...
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


% --- Executes just before first is made visible.
function first_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to first (see VARARGIN)

% MOM custom stuff

%handles.peaks = peaks(35)
%handles.membrane = membrane;
%[x, y] = meshgrid(-8:0.5:8);
%r = sqrt(x.^ 2 + y.^ 2) + eps;
%sinc = sin(r) ./ r;
%handles.sinc = sinc;
%handles.current_data = handles.peaks;
%surf(handles.current_data);

%==================================================== 

handles.t = [0 : constants.TIME_DELTA : constants.MAX_TIME];
handles.x = [0 : constants.X_DELTA : constants.MAX_X];
global which_mouse;
which_mouse = 0;
global time;
time = 0;
global current_x;
current_x = 0;
handles.w_s = constants.THETA;
handles.w_d = constants.THETA;
global speed;
speed = 0.0;
global time_frame;
time_frame = constants.TIME_FRAME;
global time_lag_coef;
time_lag_coef = constants.TIME_LAG_COEF;
global x_frame;
x_frame = 2;
handles.v_s = sin(2 * pi * handles.t * handles.w_s);
handles.phi = zeros(1, length(handles.t));
handles.v_d = sin(2 * pi * (handles.t * handles.w_s + handles.phi));
handles.v_sum = handles.v_s + handles.v_d;
set(handles.speed, 'String', sprintf('%f', speed));
set(handles.timeframe, 'String', sprintf('%f', time_frame));
set(handles.timelagcoefedit, 'String', sprintf('%f', time_lag_coef));

handles.somaplot = plot(handles.somaaxes, handles.t, handles.v_s);
handles.dendriteplot = plot(handles.dendriteaxes, handles.t, handles.v_d);
handles.sumplot = plot(handles.sumaxes, handles.t, handles.v_sum);
ddd = handles.t * handles.w_s;
[pks, locs] = findpeaks(handles.v_sum);
handles.phaseplot = scatter(handles.phaseaxes, handles.t(locs), mod(360 - (ddd(locs) - floor(ddd(locs))) * 360, 360));
handles.locationplot = plot(handles.locationaxes, handles.x, abs(cos(pi * handles.x)));
I = imread('mouse.jpg');
imshow(I, 'Parent', handles.mouseaxes);

hold(handles.somaaxes, 'on');
hold(handles.dendriteaxes, 'on');
hold(handles.sumaxes, 'on');
hold(handles.phaseaxes, 'on');
hold(handles.locationaxes, 'on');
handles.blackline = plot(handles.somaaxes, [time time], [-2 2], 'k');
handles.blackline1 = plot(handles.dendriteaxes, [time time], [-2 2], 'k');
handles.blackline2 = plot(handles.sumaxes, [time time], [-2 2], 'k');
handles.blackline3 = plot(handles.phaseaxes, [time time], [-2 2], 'k');
handles.blackline4 = plot(handles.locationaxes, [current_x current_x], [-2 2], 'k');
hold(handles.somaaxes, 'off');
hold(handles.dendriteaxes, 'off');
hold(handles.sumaxes, 'off');
hold(handles.phaseaxes, 'off');
hold(handles.locationaxes, 'off');

set(handles.somaaxes, 'XLim', [-time_frame / 2, time_frame / 2]);
set(handles.dendriteaxes, 'XLim', [-time_frame / 2, time_frame / 2]);
set(handles.sumaxes, 'XLim', [-time_frame / 2, time_frame / 2]);
set(handles.phaseaxes, 'XLim', [-time_frame / 2, time_frame / 2]);
set(handles.locationaxes, 'XLim', [-x_frame / 2, x_frame / 2]);
set(handles.somaaxes, 'YLim', [-1.15, 1.15]);
set(handles.dendriteaxes, 'YLim', [-1.15, 1.15]);
set(handles.sumaxes, 'YLim', [-2.2, 2.2]);
set(handles.locationaxes, 'YLim', [0 1]);
set(handles.phaseaxes, 'YLim', [-20 380]);

% Choose default command line output for first
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes first wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = first_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function mycallback(src, evt, handles)
global time;
global time_frame;
global time_lag_coef;
time = time + constants.TIME_DELTA * time_lag_coef;
global current_x;
global speed;
global x_frame;
current_x = current_x + speed * constants.TIME_DELTA * time_lag_coef;
set(handles.somaaxes, 'XLim', [-time_frame / 2 + time, time_frame / 2 + time]);
set(handles.dendriteaxes, 'XLim', [-time_frame / 2 + time, time_frame / 2 + time]);
set(handles.sumaxes, 'XLim', [-time_frame / 2 + time, time_frame / 2 + time]);
set(handles.phaseaxes, 'XLim', [-time_frame / 2 + time, time_frame / 2 + time]);
set(handles.locationaxes, 'XLim', [-x_frame / 2 + current_x, x_frame / 2 + current_x]);
set(handles.blackline, 'XData', [time time]);
set(handles.blackline1, 'XData', [time time]);
set(handles.blackline2, 'XData', [time time]);
set(handles.blackline3, 'XData', [time time]);
set(handles.blackline4, 'XData', [current_x current_x]);
set(handles.timetext, 'String', sprintf('time = %f', time));
set(handles.locationtext, 'String', sprintf('location = %d', current_x));
%global which_mouse;
%if (speed > 0)
%    if (which_mouse == 0)
%        I = imread('ha.jpg');
%        which_mouse = 1;
%    else
%        I = imread('mouse.jpg');
%        which_mouse = 0;
%    end
%    imshow(I, 'Parent', handles.mouseaxes);
%end

% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'timer') && isvalid(handles.timer) && strcmp(get(handles.timer, 'Running'),'on')
   stop(handles.timer);
   delete(handles.timer);
   set(handles.startbutton, 'String', 'Start');
else
   handles.timer = timer('TimerFcn',{@mycallback, handles}, 'Period', constants.TIME_DELTA, 'ExecutionMode','fixedRate');
   start(handles.timer);
   set(handles.startbutton, 'String', 'Stop');
end
guidata(hObject, handles)


function update_speed(hObject, handles)
global speed
if speed < 0
    speed = 0
end
set(handles.speed, 'String', sprintf('%f', speed));
global time;
t = time;
idx = int32(t / constants.TIME_DELTA);
if idx < 1
    idx = 1;
end
%handles.w_d = handles.w_s + speed * constants.BETA;
phase = handles.phi(idx);
remaining_times = [t : constants.TIME_DELTA : constants.MAX_TIME + constants.TIME_DELTA * 2];
handles.phi = [ handles.phi(1:idx) (phase + (remaining_times - t) * speed * constants.BETA) ];
if length(handles.phi) ~= length(handles.t)
    handles.phi = handles.phi(1 : length(handles.t));
end
handles.v_d = sin(2 * pi * (handles.t * handles.w_s + handles.phi));
%handles.v_d = [ handles.v_d(1:idx) sin([t : constants.TIME_DELTA : constants.MAX_TIME] * handles.w_d) ];
handles.v_sum = handles.v_s + handles.v_d;
set(handles.dendriteplot, 'YData', handles.v_d);
set(handles.sumplot, 'YData', handles.v_sum);
[pks, locs] = findpeaks(handles.v_sum);
set(handles.phaseplot, 'XData', handles.t(locs));
ddd = handles.t * handles.w_s;
set(handles.phaseplot, 'YData', (ddd(locs) - floor(ddd(locs))) * 360);
guidata(hObject, handles)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
global speed;
if (speed < 1e-9)
    speed = constants.SPEED_THRES;
else
    speed = speed * constants.SPEED_FACTOR;
end
update_speed(hObject, handles);
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
global speed;
if (speed <= constants.SPEED_THRES + 1e-9)
    speed = 0;
else
    speed = speed / constants.SPEED_FACTOR;
end
update_speed(hObject, handles);
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function speed_Callback(hObject, eventdata, handles)
global speed;
speed = str2num(get(handles.speed, 'String'));
update_speed(hObject, handles);
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speed as text
%        str2double(get(hObject,'String')) returns contents of speed as a double


% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function update_timeframe(hObject, handles)
global time_frame;
global time;
if time_frame < 0.01
    time_frame = 0.01
end
global x_frame;
global current_x;
set(handles.timeframe, 'String', sprintf('%f', time_frame));
set(handles.somaaxes, 'XLim', [-time_frame / 2 + time, time_frame / 2 + time]);
set(handles.dendriteaxes, 'XLim', [-time_frame / 2 + time, time_frame / 2 + time]);
set(handles.sumaxes, 'XLim', [-time_frame / 2 + time, time_frame / 2 + time]);
set(handles.phaseaxes, 'XLim', [-time_frame / 2 + time, time_frame / 2 + time]);
set(handles.locationaxes, 'XLim', [-x_frame / 2 + current_x, x_frame / 2 + current_x]);
guidata(hObject, handles)

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
global time_frame;
time_frame = time_frame + 0.5;
update_timeframe(hObject, handles);
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
global time_frame;
time_frame = time_frame - 0.5;
update_timeframe(hObject, handles);
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function timeframe_Callback(hObject, eventdata, handles)
global time_frame;
time_frame = str2num(get(handles.timeframe, 'String'));
update_timeframe(hObject, handles);
% hObject    handle to timeframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeframe as text
%        str2double(get(hObject,'String')) returns contents of timeframe as a double


% --- Executes during object creation, after setting all properties.
function timeframe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function update_timelag(hObject, handles)
global time_lag_coef
if time_lag_coef < 0.01
    time_lag_coef = 0.01
end
set(handles.timelagcoefedit, 'String', sprintf('%f', time_lag_coef));
guidata(hObject, handles)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
global time_lag_coef
time_lag_coef = time_lag_coef + 0.1;
update_timelag(hObject, handles);
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
global time_lag_coef
time_lag_coef = time_lag_coef - 0.1;
update_timelag(hObject, handles);
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function timelagcoefedit_Callback(hObject, eventdata, handles)
global time_lag_coef
time_lag_coef = str2num(get(handles.timelagcoefedit, 'String'));
update_timelag(hObject, handles);
% hObject    handle to timelagcoefedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timelagcoefedit as text
%        str2double(get(hObject,'String')) returns contents of timelagcoefedit as a double


% --- Executes during object creation, after setting all properties.
function timelagcoefedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timelagcoefedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
