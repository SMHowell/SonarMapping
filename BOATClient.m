function [x y z] = BOATClient

% tcpipClient = tcpip('168.105.83.210',55000,'NetworkRole','Client');
tcpipClient = tcpip('128.171.158.59',55000,'NetworkRole','Client');

% first get size of incoing arrays
set(tcpipClient,'InputBufferSize',24);
fopen(tcpipClient);
rawData = fread(tcpipClient,3,'double');
fclose(tcpipClient);

x = rawData(1);
y = rawData(2);
z = rawData(3);

end