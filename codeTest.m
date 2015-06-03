% code for test the function and parameter
% to see whether it is appropariate

% some code put directly into the command line
% are put here

% test of the sameRegion function 

test = bw_I;
test(find(J==0)) = 0;
imshow(test);
% see the segmentation 

% finally run the follwoing command, can see the result '-.r*'
imshow(im), hold on;
x_vv= 0:6:imW;
y_vv= yI;

x_seg = 0:6:imW;
y_seg = avg;

hold on
plot(x_vv, y_vv, '-.r*');
plot(x_seg, y_seg, '-.r*');

hold off



