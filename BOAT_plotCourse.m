function varargout = BOAT_plotCourse(varargin)
% BOAT_PLOTCOURSE MATLAB code for BOAT_plotCourse.fig
%      BOAT_PLOTCOURSE, by itself, creates a new BOAT_PLOTCOURSE or raises the existing
%      singleton*.
%
%      H = BOAT_PLOTCOURSE returns the handle to a new BOAT_PLOTCOURSE or the handle to
%      the existing singleton*.
%
%      BOAT_PLOTCOURSE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOAT_PLOTCOURSE.M with the given input arguments.
%
%      BOAT_PLOTCOURSE('Property','Value',...) creates a new BOAT_PLOTCOURSE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BOAT_plotCourse_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BOAT_plotCourse_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BOAT_plotCourse

% Last Modified by GUIDE v2.5 23-Oct-2015 04:53:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @BOAT_plotCourse_OpeningFcn, ...
    'gui_OutputFcn',  @BOAT_plotCourse_OutputFcn, ...
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


% --- Executes just before BOAT_plotCourse is made visible.
function BOAT_plotCourse_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BOAT_plotCourse (see VARARGIN)

% Choose default command line output for BOAT_plotCourse
handles.output = hObject;

%% Initialize variables
handles.x = []; % mouse click locations
handles.y = [];

%% Setup mouse listener
set(gcf, 'WindowButtonDownFcn', @getMousePositionOnImage);
axes(handles.setCourseAxes);
set(handles.setCourseAxes,'xlim',[0 1],'ylim',[0 1]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BOAT_plotCourse wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = BOAT_plotCourse_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
targetChain = [handles.x' handles.y'];

targetChain(:,1) = (targetChain(:,1)-min(targetChain(:,1)))/max(targetChain(:,1)-min(targetChain(:,1)));
targetChain(:,2) = (targetChain(:,2)-min(targetChain(:,2)))/max(targetChain(:,2)-min(targetChain(:,2)));
save test_track targetChain

function getMousePositionOnImage(src, event)
% for getting dartapoints
handles = guidata(src);
cursorPoint = get(handles.setCourseAxes, 'CurrentPoint');
curX = cursorPoint(1,1);
curY = cursorPoint(1,2);

xLimits = get(handles.setCourseAxes, 'xlim');
yLimits = get(handles.setCourseAxes, 'ylim');

handles.x(end+1) = curX;
handles.y(end+1) = curY;

if (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
    hold(handles.setCourseAxes,'on');
    if length(handles.x)>1
        plot(handles.x(end-1:end),handles.y(end-1:end),'k');
    end
    scatter(curX,curY,48,'k','filled')
    hold(handles.setCourseAxes,'off');
end

disp([num2str(curX) ' ' num2str(curY)])
guidata(src, handles);
