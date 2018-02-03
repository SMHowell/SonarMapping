%% Input variables for UHGS BOAT system
% Howell - 10/22/15

% steps in x and y

%% Configure motor input

%% Load fresh seafloor
% This has been padded to make nice plots with a little surface roughness
load BOAT_fresh_seafloor.mat
load test_track

%% Initialize variables 
lon        = linspace(-2,118,200); % grid longitude padded to total floor size + 2
lat        = linspace(-2,93,200); % grid latitude
[LON, LAT] = meshgrid(lon,lat); % Arrays for position
 
%% Initialize bathy plot
% Read background image data
bg.img      = imread('BOAT_bg.jpg');
[bg.x,bg.z] = meshgrid(linspace(0,116,size(bg.img,1)),linspace(0,125,size(bg.img,2)));
bg.y        = zeros(size(bg.x));

% Setup figure
figure(1); 
clf;             
box on;
hold on;  
axis equal tight; 
view([163 22]); 
caxis([95 125]);  
lighting phong;
set(gcf,'color','k'), 
axis([0 116 0 91 0 126]); freezeColors
light('Position',[0 -1 0.5]); light('Position',[0 -1 0.5])
set(gca,'color','k','zdir','reverse','BoxStyle','full','xtick',[],'ytick',[],'ztick',[],...
    'xcolor','w','ycolor','w','zcolor','w');  

% image data
sh = surf(fliplr(bg.x),bg.y,bg.z);
set(sh,'cdata',bg.img,'facecolor','texturemap','edgecolor','none');
freezeColors
colormap(flipud(haxby(1024)))

% Depth plot
F      = scatteredInterpolant(lonLog,latLog,depthLog);
DEPTH  = F(LON,LAT)/10;
f      = 1/10^2*ones(10);
D      = filter2(f,DEPTH,'valid');
D(D>1226) = 1226;
h = surf(fliplr(LON(5:end-5,5:end-5)),flipud(LAT(5:end-5,5:end-5)),...
    D,'linestyle','none');
drawnow % Force render

%% initialize ship track plot
% Setup figure
figure(2); 
clf;             
box on;
hold on;  
axis equal tight; 
set(gcf,'color','k'), 
axis([-0.2 1.2 -0.2 0.75*1.2]); freezeColors
set(gca,'color','k','BoxStyle','full','xtick',[],'ytick',[],'ztick',[],...
    'xcolor','w','ycolor','w','zcolor','w');
plot(targetChain(:,1),0.75*targetChain(:,2),'y--','linewidth',2)
scatter(targetChain(:,1),0.75*targetChain(:,2),400,'wp','filled')




