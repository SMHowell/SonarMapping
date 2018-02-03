function BOATServer(x,y,z)
%BOATServer   3-D colored surface.
%   BOATServer(data) readies the variable data to be sent to BOATClient
%       X, Y, and Z should be 101x101 double
% howellsm 2-13-15

% Configure server
tcpipServer = tcpip('0.0.0.0',55000,'NetworkRole','Server');

% Prep [x y z]
data = [x y z];

% Send information on data to be recieved by passing data_props to client
set(tcpipServer,'OutputBufferSize',24)

fopen(tcpipServer);
fwrite(tcpipServer,data,'double');
fclose(tcpipServer);
delete(tcpipServer);
clear('tcpipServer');

end