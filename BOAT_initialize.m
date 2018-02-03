%% Initialize coms for UHGS BOAT system
% Howell - 10/22/15
load test_track
load BOAT_fresh_seafloor;
s.port = 'COM3';
x.port = 'COM4'; % port needs to be looked up in Windows
y.port = 'COM5'; 

x.device = 11;  % device set in JRK config utility
y.device = 5;  
x.size   = 100; % dimension in cm
y.size   = 75;

try
    s.sonar;
catch
    s.sonar = serial(s.port);
    set(s.sonar,'BaudRate',57600);
    set(s.sonar,'Terminator',13);
    fopen(s.sonar);
end

try
    x.motor;
catch
    x.motor = serial(x.port);
    set(x.motor, 'InputBufferSize', 2048);
    set(x.motor, 'BaudRate', 9600);
    set(x.motor, 'DataBits', 8);
    set(x.motor, 'Parity', 'none');
    set(x.motor, 'StopBits', 1);
    fopen(x.motor);
end

try
    y.motor;
catch
    y.motor = serial(y.port);
    set(y.motor, 'InputBufferSize', 2048);
    set(y.motor, 'BaudRate', 9600);
    set(y.motor, 'DataBits', 8);
    set(y.motor, 'Parity', 'none');
    set(y.motor, 'StopBits', 1);
    fopen(y.motor);
end
