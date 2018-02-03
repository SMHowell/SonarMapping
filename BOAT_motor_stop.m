function BOAT_motor_stop(COMobj,motorStruct)

m.listen  = hex2dec('0AA'); % Start command; Pololu website
m.stop    = hex2dec('07F'); % motor off
fwrite(COMobj, [m.listen, motorStruct.device, m.stop] );
fclose(COMobj);
delete(COMobj);

end