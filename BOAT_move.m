function [] = BOAT_move(motorStruct)
%% motor control system for UHGS BOAT system
% Howell - 10/22/15

m.listen  = hex2dec('0AA'); % Start command; Pololu website
m.lores_f = hex2dec('0E1'); % Set Target Low Resolution Forward
m.lores_r = hex2dec('0E0'); % Set Target Low Resolution Reverse

motorStruct.target = floor((motorStruct.target-0.5)*4080/16); % map to -127:127
motorStruct.target(motorStruct.target<-127) = -127; % scale to tested limites
motorStruct.target(motorStruct.target> 127) =  127;

if motorStruct.target<0
    fwrite(motorStruct.motor,[m.listen, motorStruct.device,...
        BOAT_clearMSB(m.lores_r),abs(motorStruct.target)]);
elseif motorStruct.target >= 0
    fwrite(motorStruct.motor,[m.listen, motorStruct.device,...
        BOAT_clearMSB(m.lores_f),abs(motorStruct.target)]);
end

end