clear; figure(1); clf; set(gcf,'color','w'); 
axis([-0.5 0.5 -0.5 0.5 -3 3]); box on; hold on;

x = [-2; -2;  2; 2];
y = [-2;  2; -3; 3];
z = [ 0;  0;  0; 0];

[X, Y] = meshgrid(linspace(-0.5,0.5,100),linspace(-0.5,0.5,100));
Z     = zeros(size(X));
tic
for i=1:1000000
   
   [x_, y_, z_] = BOATClient;
   
   x(end+1,1) = x_;
   y(end+1,1) = y_;
   z(end+1,1) = z_;
   
   Z = griddata(x,y,z,X,Y);
   if(i>1)
    delete(h);
   end
   h = surf(X,Y,Z,'linestyle','none'); material('dull'); shading interp;
   drawnow;
   toc
   
   
end