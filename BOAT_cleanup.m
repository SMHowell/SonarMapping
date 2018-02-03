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
