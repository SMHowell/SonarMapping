function varargout = BOAT_command(varargin)
% BOAT_COMMAND MATLAB code for BOAT_command.fig
%      BOAT_COMMAND, by itself, creates a new BOAT_COMMAND or raises the existing
%      singleton*.
%
%      H = BOAT_COMMAND returns the handle to a new BOAT_COMMAND or the handle to
%      the existing singleton*.
%
%      BOAT_COMMAND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOAT_COMMAND.M with the given input arguments.
%
%      BOAT_COMMAND('Property','Value',...) creates a new BOAT_COMMAND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BOAT_command_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BOAT_command_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BOAT_command

% Last Modified by GUIDE v2.5 24-Oct-2015 09:52:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @BOAT_command_OpeningFcn, ...
    'gui_OutputFcn',  @BOAT_command_OutputFcn, ...
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


% --- Executes just before BOAT_command is made visible.
function BOAT_command_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BOAT_command (see VARARGIN)

% Choose default command line output for BOAT_command
handles.output = hObject;
handles.curX = []; % mouse click locations
handles.curY = [];

% background
axes(handles.commandConsoleAxes);
matlabImage = imread('BoatConsole.png');
image(matlabImage)
axis off
axis image
rotate3d off

axes(handles.surfAxes); cla;
rotate3d on
hold(handles.surfAxes,'on');
bg.img      = imread('BOAT_bg.jpg');
[bg.x,bg.z] = meshgrid(linspace(0,116,size(bg.img,1)),linspace(0,125,size(bg.img,2)));
bg.y        = zeros(size(bg.x));

axis equal;
view([-148 28]);
caxis([95 125]);
lighting phong;
axis([0 116 0 91 0 126]); freezeColors
light('Position',[0 -1 0.5]); light('Position',[0 -1 0.5])
set(gca,'zdir','reverse','xtick',[],'ytick',[],'ztick',[]);

% image data
sh = surf(handles.surfAxes,fliplr(bg.x),bg.y,bg.z);
set(sh,'cdata',bg.img,'facecolor','texturemap','edgecolor','none');
freezeColors
colormap(flipud(haxby(1024)))

load BOAT_fresh_seafloor.mat
lon        = linspace(-2,118,200); % grid longitude padded to total floor size + 2
lat        = linspace(-2,93,200); % grid latitude
[handles.LON, handles.LAT] = meshgrid(lon,lat); % Arrays for position

handles.latLog = latLog;
handles.lonLog = lonLog;
handles.depthLog = depthLog;

% Depth plot
F      = scatteredInterpolant(lonLog,latLog,depthLog);
DEPTH  = F(handles.LON,handles.LAT)/10;
f      = 1/10^2*ones(10);
D      = filter2(f,DEPTH,'valid');
D(D>1226) = 1226;
handles.h = surf(fliplr(handles.LON(5:end-5,5:end-5)),flipud(handles.LAT(5:end-5,5:end-5)),...
    D,'linestyle','none');
drawnow % Force render

load test_track.mat
handles.targetChain = targetChain;

axes(handles.courseAxes); cla;
hold(handles.courseAxes,'on');
axis equal;
axis(handles.courseAxes,[-0.2 1.2 -0.2 0.75*1.2]);
set(gca,'xtick',[],'ytick',[],'ztick',[]);
plot(targetChain(:,1),0.75*targetChain(:,2),'y--','linewidth',2)
scatter(targetChain(:,1),0.75*targetChain(:,2),400,'wp','filled')

axes(handles.commandConsoleAxes)
rotate3d off
axes(handles.courseAxes);
axes(handles.surfAxes);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BOAT_command wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BOAT_command_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startSurveyButton.
function startSurveyButton_Callback(hObject, eventdata, handles)
% hObject    handle to startSurveyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = handles.h;
axes(handles.surfAxes);
cla; rotate3d on;

axes(handles.surfAxes); cla;
rotate3d on
hold(handles.surfAxes,'on');
bg.img      = imread('BOAT_bg.jpg');
[bg.x,bg.z] = meshgrid(linspace(0,116,size(bg.img,1)),linspace(0,125,size(bg.img,2)));
bg.y        = zeros(size(bg.x));

axis equal;
view([-148 28]);
caxis([95 125]);
lighting phong;
axis([0 116 0 91 0 126]); freezeColors
light('Position',[0 -1 0.5]); light('Position',[0 -1 0.5])
set(gca,'zdir','reverse','xtick',[],'ytick',[],'ztick',[]);

% image data
sh = surf(handles.surfAxes,fliplr(bg.x),bg.y,bg.z);
set(sh,'cdata',bg.img,'facecolor','texturemap','edgecolor','none');
freezeColors
colormap(flipud(haxby(1024)))

load BOAT_fresh_seafloor.mat
lon        = linspace(-2,118,200); % grid longitude padded to total floor size + 2
lat        = linspace(-2,93,200); % grid latitude
[handles.LON, handles.LAT] = meshgrid(lon,lat); % Arrays for position

handles.latLog = latLog;
handles.lonLog = lonLog;
handles.depthLog = depthLog;

% Depth plot
F      = scatteredInterpolant(lonLog,latLog,depthLog);
DEPTH  = F(handles.LON,handles.LAT)/10;
f      = 1/10^2*ones(10);
D      = filter2(f,DEPTH,'valid');
D(D>1226) = 1226;
handles.h = surf(fliplr(handles.LON(5:end-5,5:end-5)),flipud(handles.LAT(5:end-5,5:end-5)),...
    D,'linestyle','none');
drawnow % Force render

load test_track.mat
handles.targetChain = targetChain;

axes(handles.courseAxes); cla;
hold(handles.courseAxes,'on');
axis equal;
axis(handles.courseAxes,[-0.2 1.2 -0.2 0.75*1.2]);
set(gca,'xtick',[],'ytick',[],'ztick',[]);
plot(targetChain(:,1),0.75*targetChain(:,2),'y--','linewidth',2)
scatter(targetChain(:,1),0.75*targetChain(:,2),400,'wp','filled')

% Update handles structure
guidata(hObject, handles);


targetChain = handles.targetChain;
latLog = handles.latLog;
lonLog = handles.lonLog;
depthLog = handles.depthLog;
LON = handles.LON;
LAT = handles.LAT;

BOAT_initialize

axes(handles.commandConsoleAxes)
rotate3d off

axes(handles.courseAxes);
axes(handles.surfAxes);

x.target = targetChain(1,1); % x position to move to
y.target = targetChain(1,2); % y position to move to
BOAT_move(x);
BOAT_move(y);
pause(10);      % Allow to reach destination
lasplot = [x.target, y.target];
plot_counter = 0; % dont plot every measurement
%% Main loop
for t = 2:length(targetChain)
    % background
    res = 0.025;
    nt = ceil(sqrt(diff(targetChain(t-1:t,1)).^2+diff(0.75*targetChain(t-1:t,2)).^2)/res);
    
    % get targets
    xChain=linspace(targetChain(t-1,1),targetChain(t,1),nt+1);
    yChain=linspace(targetChain(t-1,2),targetChain(t,2),nt+1);
    
    for i=1:nt
        plot_counter = plot_counter+1;
        %% move
        x.target = xChain(i+1); % x position to move to
        y.target = yChain(i+1); % y position to move to
        BOAT_move(x);
        BOAT_move(y);
        pause(0.33);
        
        % Record and grid, filter out bad returns (about 1.3 m)
        range = BOAT_ping(s); % get depth
        if range>1225 && (x.target~=targetChain(1,1)&&y.target~=targetChain(1,2))
            lonLog(end+1)     = x.target*x.size+10;
            latLog(end+1)     = y.target*y.size+10;
            range(range>1225) = depthLog(end);
            depthLog(end+1)   = range;
        else
            lonLog(end+1)   = x.target*100+10;
            latLog(end+1)   = y.target*75+10;
            depthLog(end+1) = range;
        end
        
        F      = scatteredInterpolant(lonLog,latLog,depthLog);
        DEPTH  = F(LON,LAT)/10;
        
        % Ensure enoguh data exists for plotting
        
        % Plot
        if mod(plot_counter,(floor(1/res)/10))
            % smooth data
            axes(handles.courseAxes)
           plot(xChain(i:i+1),yChain(i:i+1)*0.75,'w','linewidth',2);

            drawnow % Force render
            
            axes(handles.surfAxes)
            rotate3d on
            f = 1/10^2*ones(10);
            D = filter2(f,DEPTH,'valid');
            D(D>1229) = 1229;
            delete(handles.h); % remove old figure to save memory, pad bad filter
            handles.h = surf(fliplr(LON(5:end-5,5:end-5)),...
                flipud(LAT(5:end-5,5:end-5)),...
                D,'linestyle','none');
            drawnow % Force render
        end
    end
end

%% tear down coms for UHGS BOAT system
% Howell - 10/22/15

m.listen  = hex2dec('0AA'); % Start command; Pololu website
m.stop    = hex2dec('07F'); % device off
fwrite(x.motor, [m.listen, x.device, m.stop] );
fwrite(y.motor, [m.listen, y.device, m.stop] );

fclose(s.sonar);
fclose(x.motor);
delete(y.motor);

clear s x y

guidata(hObject, handles);


% --- Executes on button press in abandonShipButton.
function abandonShipButton_Callback(hObject, eventdata, handles)
% hObject    handle to abandonShipButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = instrfind;
fclose(a(:));
delete(a(:));
clear a;

% --- Executes on button press in abandonShipButton.
function RANDUM_Callback(hObject, eventdata, handles)
% hObject    handle to abandonShipButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.surfAxes);
cla; rotate3d on;

BOAT_initialize

targetChain = rand(16,2);
targetChain(:,1) = (targetChain(:,1)-min(targetChain(:,1)))/max(targetChain(:,1)-min(targetChain(:,1)));
targetChain(:,2) = (targetChain(:,2)-min(targetChain(:,2)))/max(targetChain(:,2)-min(targetChain(:,2)));
handles.targetChain = targetChain;
h = handles.h;
% hObject    handle to startSurveyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.surfAxes); cla;
rotate3d on
hold(handles.surfAxes,'on');
bg.img      = imread('BOAT_bg.jpg');
[bg.x,bg.z] = meshgrid(linspace(0,116,size(bg.img,1)),linspace(0,125,size(bg.img,2)));
bg.y        = zeros(size(bg.x));

axis equal;
view([-148 28]);
caxis([95 125]);
lighting phong;
axis([0 116 0 91 0 126]); freezeColors
light('Position',[0 -1 0.5]); light('Position',[0 -1 0.5])
set(gca,'zdir','reverse','xtick',[],'ytick',[],'ztick',[]);

% image data
sh = surf(handles.surfAxes,fliplr(bg.x),bg.y,bg.z);
set(sh,'cdata',bg.img,'facecolor','texturemap','edgecolor','none');
freezeColors
colormap(flipud(haxby(1024)))

load BOAT_fresh_seafloor.mat
lon        = linspace(-2,118,200); % grid longitude padded to total floor size + 2
lat        = linspace(-2,93,200); % grid latitude
[handles.LON, handles.LAT] = meshgrid(lon,lat); % Arrays for position

handles.latLog = latLog;
handles.lonLog = lonLog;
handles.depthLog = depthLog;

% Depth plot
F      = scatteredInterpolant(lonLog,latLog,depthLog);
DEPTH  = F(handles.LON,handles.LAT)/10;
f      = 1/10^2*ones(10);
D      = filter2(f,DEPTH,'valid');
D(D>1226) = 1226;
handles.h = surf(fliplr(handles.LON(5:end-5,5:end-5)),flipud(handles.LAT(5:end-5,5:end-5)),...
    D,'linestyle','none');
drawnow % Force render

axes(handles.courseAxes); cla;
hold(handles.courseAxes,'on');
axis equal;
axis(handles.courseAxes,[-0.2 1.2 -0.2 0.75*1.2]);
set(gca,'xtick',[],'ytick',[],'ztick',[]);
plot(targetChain(:,1),0.75*targetChain(:,2),'y--','linewidth',2)
scatter(targetChain(:,1),0.75*targetChain(:,2),400,'wp','filled')

latLog = handles.latLog;
lonLog = handles.lonLog;
depthLog = handles.depthLog;
LON = handles.LON;
LAT = handles.LAT;

axes(handles.commandConsoleAxes)
rotate3d off

axes(handles.courseAxes);
axes(handles.surfAxes);

x.target = targetChain(1,1); % x position to move to
y.target = targetChain(1,2); % y position to move to
BOAT_move(x);
BOAT_move(y);
pause(10);      % Allow to reach destination

plot_counter = 0; % dont plot every measurement
%% Main loop
for t = 2:length(targetChain)
    % background
    res = 0.025;
    nt = ceil(sqrt(diff(targetChain(t-1:t,1)).^2+diff(0.75*targetChain(t-1:t,2)).^2)/res);
    
    % get targets
    xChain=linspace(targetChain(t-1,1),targetChain(t,1),nt+1);
    yChain=linspace(targetChain(t-1,2),targetChain(t,2),nt+1);
    
    for i=1:nt
        plot_counter = plot_counter+1;
        %% move
        x.target = xChain(i+1); % x position to move to
        y.target = yChain(i+1); % y position to move to
        BOAT_move(x);
        BOAT_move(y);
        pause(0.33);
        
        % Record and grid, filter out bad returns (about 1.3 m)
        range = BOAT_ping(s); % get depth
        if range>1225 && (x.target~=targetChain(1,1)&&y.target~=targetChain(1,2))
            lonLog(end+1)     = x.target*x.size+10;
            latLog(end+1)     = y.target*y.size+10;
            range(range>1225) = depthLog(end);
            depthLog(end+1)   = range;
        else
            lonLog(end+1)   = x.target*100+10;
            latLog(end+1)   = y.target*75+10;
            depthLog(end+1) = range;
        end
        
        F      = scatteredInterpolant(lonLog,latLog,depthLog);
        DEPTH  = F(LON,LAT)/10;
        
        % Ensure enoguh data exists for plotting
        
        % Plot
        if mod(plot_counter,(floor(1/res)/10))
            % smooth data
            axes(handles.courseAxes)
            plot(xChain(i:i+1),yChain(i:i+1)*0.75,'w','linewidth',2);

            drawnow % Force render
            
            axes(handles.surfAxes)
            rotate3d on
            f = 1/10^2*ones(10);
            D = filter2(f,DEPTH,'valid');
            D(D>1229) = 1229;
            delete(handles.h); % remove old figure to save memory, pad bad filter
            handles.h = surf(fliplr(LON(5:end-5,5:end-5)),...
                flipud(LAT(5:end-5,5:end-5)),...
                D,'linestyle','none');
            drawnow % Force render
        end
    end
end


% --- Executes on button press in abandonShipButton.
function playButton_Callback(hObject, eventdata, handles)
% hObject    handle to abandonShipButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.surfAxes);
cla; rotate3d on;
BOAT_initialize

targetChain = zeros(length(handles.curX),2);
targetChain(:,1) = handles.curX(:);
targetChain(:,2) = handles.curY(:);


targetChain(:,1) = (targetChain(:,1)-min(targetChain(:,1)))/max(targetChain(:,1)-min(targetChain(:,1)));
targetChain(:,2) = (targetChain(:,2)-min(targetChain(:,2)))/max(targetChain(:,2)-min(targetChain(:,2)));

handles.targetChain = targetChain;
h = handles.h;
% hObject    handle to startSurveyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.surfAxes); cla;
rotate3d on
hold(handles.surfAxes,'on');
bg.img      = imread('BOAT_bg.jpg');
[bg.x,bg.z] = meshgrid(linspace(0,116,size(bg.img,1)),linspace(0,125,size(bg.img,2)));
bg.y        = zeros(size(bg.x));

axis equal;
view([-148 28]);
caxis([95 125]);
lighting phong;
axis([0 116 0 91 0 126]); freezeColors
light('Position',[0 -1 0.5]); light('Position',[0 -1 0.5])
set(gca,'zdir','reverse','xtick',[],'ytick',[],'ztick',[]);

% image data
sh = surf(handles.surfAxes,fliplr(bg.x),bg.y,bg.z);
set(sh,'cdata',bg.img,'facecolor','texturemap','edgecolor','none');
freezeColors
colormap(flipud(haxby(1024)))

load BOAT_fresh_seafloor.mat
lon        = linspace(-2,118,200); % grid longitude padded to total floor size + 2
lat        = linspace(-2,93,200); % grid latitude
[handles.LON, handles.LAT] = meshgrid(lon,lat); % Arrays for position

handles.latLog = latLog;
handles.lonLog = lonLog;
handles.depthLog = depthLog;

% Depth plot
F      = scatteredInterpolant(lonLog,latLog,depthLog);
DEPTH  = F(handles.LON,handles.LAT)/10;
f      = 1/10^2*ones(10);
D      = filter2(f,DEPTH,'valid');
D(D>1226) = 1226;
handles.h = surf(fliplr(handles.LON(5:end-5,5:end-5)),flipud(handles.LAT(5:end-5,5:end-5)),...
    D,'linestyle','none');
drawnow % Force render

axes(handles.courseAxes); cla;
hold(handles.courseAxes,'on');
axis equal;
axis(handles.courseAxes,[-0.2 1.2 -0.2 0.75*1.2]);
set(gca,'xtick',[],'ytick',[],'ztick',[]);
plot(targetChain(:,1),0.75*targetChain(:,2),'y--','linewidth',2)
scatter(targetChain(:,1),0.75*targetChain(:,2),400,'wp','filled')

latLog = handles.latLog;
lonLog = handles.lonLog;
depthLog = handles.depthLog;
LON = handles.LON;
LAT = handles.LAT;

axes(handles.commandConsoleAxes)
rotate3d off

axes(handles.courseAxes);
axes(handles.surfAxes);

x.target = targetChain(1,1); % x position to move to
y.target = targetChain(1,2); % y position to move to
BOAT_move(x);
BOAT_move(y);
pause(10);      % Allow to reach destination

lasplot = [x.target, y.target];
plot_counter = 0; % dont plot every measurement
%% Main loop
for t = 2:length(targetChain)
    % background
    res = 0.025;
    nt = ceil(sqrt(diff(targetChain(t-1:t,1)).^2+diff(0.75*targetChain(t-1:t,2)).^2)/res);
    
    % get targets
    xChain=linspace(targetChain(t-1,1),targetChain(t,1),nt+1);
    yChain=linspace(targetChain(t-1,2),targetChain(t,2),nt+1);
    
    for i=1:nt
        plot_counter = plot_counter+1;
        %% move
        x.target = xChain(i+1); % x position to move to
        y.target = yChain(i+1); % y position to move to
        BOAT_move(x);
        BOAT_move(y);
        pause(0.33);
        
        % Record and grid, filter out bad returns (about 1.3 m)
        range = BOAT_ping(s); % get depth
        if range>1225 && (x.target~=targetChain(1,1)&&y.target~=targetChain(1,2))
            lonLog(end+1)     = x.target*x.size+10;
            latLog(end+1)     = y.target*y.size+10;
            range(range>1225) = depthLog(end);
            depthLog(end+1)   = range;
        else
            lonLog(end+1)   = x.target*100+10;
            latLog(end+1)   = y.target*75+10;
            depthLog(end+1) = range;
        end
        
        F      = scatteredInterpolant(lonLog,latLog,depthLog);
        DEPTH  = F(LON,LAT)/10;
        
        % Ensure enoguh data exists for plotting
        
        % Plot
        if mod(plot_counter,(floor(1/res)/10))
            % smooth data
            axes(handles.courseAxes)
           plot(xChain(i:i+1),yChain(i:i+1)*0.75,'w','linewidth',2);

            drawnow % Force render
            
            axes(handles.surfAxes)
            rotate3d on
            f = 1/10^2*ones(10);
            D = filter2(f,DEPTH,'valid');
            D(D>1229) = 1229;
            delete(handles.h); % remove old figure to save memory, pad bad filter
            handles.h = surf(fliplr(LON(5:end-5,5:end-5)),...
                flipud(LAT(5:end-5,5:end-5)),...
                D,'linestyle','none');
            drawnow % Force render
        end
    end
end


%% tear down coms for UHGS BOAT system
% Howell - 10/22/15

m.listen  = hex2dec('0AA'); % Start command; Pololu website
m.stop    = hex2dec('07F'); % device off
fwrite(x.motor, [m.listen, x.device, m.stop] );
fwrite(y.motor, [m.listen, y.device, m.stop] );

fclose(s.sonar);
fclose(x.motor);
delete(y.motor);

clear s x y


guidata(hObject, handles);

% --- Executes on button press in recordButton.
function recordButton_Callback(hObject, eventdata, handles)
axes(handles.surfAxes); rotate3d off;


axes(handles.courseAxes);cla;rotate3d off;
set(gcf, 'WindowButtonDownFcn', @getMousePositionOnImage);

handles.curX = [];
handles.curY = [];
hold(handles.courseAxes,'on');
axis equal;
axis(handles.courseAxes,[-0.2 1.2 -0.2 0.75*1.2]);
set(gca,'xtick',[],'ytick',[],'ztick',[]);

guidata(hObject, handles);

a = instrfind;
fclose(a(:));
delete(a(:));

function getMousePositionOnImage(src, event)
% for getting dartapoints

handles = guidata(src);
cursorPoint = get(handles.courseAxes, 'CurrentPoint');
curx = cursorPoint(1,1);
cury = cursorPoint(1,2);

xLimits = get(handles.courseAxes, 'xlim');
yLimits = get(handles.courseAxes, 'ylim');

handles.curX(end+1) = curx;
handles.curY(end+1) = cury;

if (curx > min(xLimits) && curx < max(xLimits) && cury > min(yLimits) && cury < max(yLimits))
    hold(handles.courseAxes,'on');
    if length(handles.curX)>1
        plot(handles.curX(end-1:end),handles.curY(end-1:end),'w','linewidth',2);
    end
    scatter(curx,cury,400,'wp','filled');
    hold(handles.courseAxes,'off');
end
guidata(src, handles);
