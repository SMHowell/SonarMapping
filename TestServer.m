clear;
for i=1:1e4
    x = -0.5+rand(1);
    y = -0.5+rand(1);
    z = x.*y*10+rand(1);
    
    BOATServer(x,y,z);
end