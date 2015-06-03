imageName = 'fog1.jpg'; 
dataDir = fullfile('..','data');
im = imread(fullfile(dataDir, imageName));
[imH, imW] = size(im);

bw_I = rgb2gray(im);
%bw_I = clearFilter(im);
BW = edge(bw_I,'canny');
imshow(BW);
[H,T,R] = hough(BW);
axis on, axis normal, hold on;
P  = houghpeaks(H,5,'threshold',0.5*max(H(:)));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');

% Find lines and plot them
lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
figure, imshow(im), hold on
max_len = 0;
max_len2 = 0;
one = 0;
xy_long = 0;
count = 0;
numOne = 0;

for k = 1:length(lines)
    
    % first filter out those that are not likely to be the 
    % two sides of the road
    if lines(k).theta < 80 && lines(k).theta > -80
        count = count + 1;
        xy = [lines(k).point1; lines(k).point2];
        
        % take control longest and second longest line segment
        len = norm(lines(k).point1 - lines(k).point2);
        
        % if the line is larger than the longest line
        if len > max_len
            numTwo = numOne;
            numOne = lines(k);
            max_len2 = max_len;
            two = one;
            xy_long2 = xy_long;     
            one = k;
            max_len = len;
            xy_long = xy;
            
        % if the line could be the second longest line
        elseif len > max_len2
            numTwo = lines(k);
            two = k;
            max_len2 = len;
            xy_long2 = xy;  
        end
    end
end

if count >=2
    % plot the two lines that are just found on the picture
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','blue');
    plot(xy_long2(:,1),xy_long2(:,2),'LineWidth',2,'Color','green');
    
    % initialize the first line data
    theta1 = numOne.theta;
    rho1 = numOne.rho;
    a1 = cos(theta1*pi/180);
    b1 = sin(theta1*pi/180);
    alpha1 = -a1/b1;
    beta1 = rho1/b1;
    
    % initiallize the second line data
    theta2 = numTwo.theta;
    rho2 = numTwo.rho;
    a2 = cos(theta2*pi/180);
    b2 = sin(theta2*pi/180);
    alpha2 = -a2/b2;
    beta2 = rho2/b2;
    
    % getting the exact coordinate of the intersection
    xI = (beta2-beta1)/(alpha1-alpha2);
    yI = alpha1 * xI + beta1; % te height of the vanishing point
    ttt = im2double(bw_I);
 
    % sky segmentation and land segmentation using 1 and 0 to represent
    segM=sameRegion(ttt,63,127,0.2);

elseif count == 1
    % if only one line found within the picture it is likely in cases such as it has a turn 
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','blue');   
end

imshow(segM);

% I decide to take 5 points, around the vanishing point.
% get rid of the largest and smallest and calculate their mean distance
vec = zeros(1, 5);
xI = floor(xI);
yI = floor(yI);
for i=yI:imH
    if segM(i-1, xI-2) ~= segM(i, xI-2)
        vec(1) = i;
        break;
    end
end

for i=yI:imH
    if segM(i-1, xI-1) ~= segM(i, xI-1)
        vec(2) = i;
        break;
    end
end

for i=yI:imH
    if segM(i-1, xI) ~= segM(i, xI)
        vec(3) = i;
        break;
    end
end

for i=yI:imH
    if segM(i-1, xI+1) ~= segM(i, xI+1)
        vec(4) = i;
        break;
    end
end

for i=yI:imH
    if segM(i-1, xI+2) ~= segM(i, xI+2)
        vec(5) = i;
        break;
    end
end

minDel = min(vec);
maxDel = max(vec);
% get the average to represent the bottom of the sky segmentation
avg = (sum(vec)-minDel-maxDel)/3;
%if avg ~= imH
fog_degree = compare(segM, yI, avg)


 




