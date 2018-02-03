function range = BOAT_ping(s)

flushinput(s.sonar);
range_str = fscanf(s.sonar,'%s',512);
while length(range_str)<5
    range_str = fscanf(s.sonar,'%s',512);
end
range = str2double(range_str(2:5));

end