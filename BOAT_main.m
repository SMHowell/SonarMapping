%% MAIN LOOP for UHGS BOAT system
% Howell - 10/22/15
warning off

%% Open serial and initialize variables
BOAT_initialize;

%% Transit

disp('Transiting for 15 seconds')
x.target = targetChain(1,1); % x position to move to
y.target = targetChain(1,2); % y position to move to
BOAT_move(x);
BOAT_move(y);
pause(10);      % Allow to reach destination

%% Main loop
for t = 2:length(targetChain)
    nt = ceil(sqrt(diff(targetChain(t-1:t,1)).^2+diff(0.75*targetChain(t-1:t,2)).^2)/0.1);
    
    % get targets
    xChain=linspace(targetChain(t-1,1),targetChain(t,1),nt+1);
    yChain=linspace(targetChain(t-1,2),targetChain(t,2),nt+1);
    for i=1:nt
        disp([num2str(xChain) ', ' num2str(yChain)])
        
        %% move
        x.target = xChain(i+1); % x position to move to
        y.target = yChain(i+1); % y position to move to
        BOAT_move(x);
        BOAT_move(y);
        pause(2);
        
        % Record and grid, filter out bad returns (about 1.3 m)
        range = BOAT_ping(s); % get depth
        if range>1225 && (x.target~=targetChain(1,1)&&y.target~=targetChain(1,2))
            lonLog(end+1)     = x.target*x.size+10;
            latLog(end+1)     = y.target*y.size+10;
            range(range>1225) = depthLog(end);
            depthLog(end+1)   = range;
        else
            lonLog(end+1)   = x.target*x.size+10;
            latLog(end+1)   = y.target*y.size+10;
            depthLog(end+1) = range;
        end
        
        F      = scatteredInterpolant(lonLog,latLog,depthLog);
        DEPTH  = F(LON,LAT)/10;
        
        % Ensure enoguh data exists for plotting
        
        % Plot
        % smooth data
        figure(1);
        f = 1/10^2*ones(10);
        D = filter2(f,DEPTH,'valid');
        D(D>1229) = 1229;
        delete(h); % remove old figure to save memory, pad bad filter
        h = surf(fliplr(LON(5:end-5,5:end-5)),...
            flipud(LAT(5:end-5,5:end-5)),...
            D,'linestyle','none');
        drawnow % Force render
        
        figure(2)
        % Setup figure
        figure(2); 
        plot(xChain(i:i+1),0.75*yChain(i:i+1),'w','linewidth',2)
        
    end
end
%% Stop devices, close serial ports
BOAT_cleanup

