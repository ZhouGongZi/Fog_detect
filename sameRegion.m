function Result=sameRegion(Im,x,y,reg_maxdist)
% using the seed growing algorithm 

Result = zeros(size(Im)); 
% at first, "Result" is all zeros; they are not modified yet
Im_sizes = size(Im);
seg_mean = Im(x,y); 
seg_size = 1; 
ele_wait=0;
% make the neg_list large enough to hold all the points
point_queue = zeros(50000,3); 
pixdist=0;

allinall = size(Im, 1) * size(Im, 2);
while(pixdist<reg_maxdist && seg_size<allinall)
    % first push all the points into a queue
    x_next = x; 
    y_next = y+1; 
    % if the next point is within the bound
    if((x_next>=1)&&(y_next>=1)&&(x_next<=Im_sizes(1))&&(y_next<=Im_sizes(2))&&(Result(x_next,y_next)==0)) 
        % first, set them to one to indicate they are "pushed in"
        Result(x_next,y_next)=1;
        ele_wait = ele_wait+1;
        point_queue(ele_wait,:) = [x_next y_next Im(x_next,y_next)];    
    end
        
    x_next = x; 
    y_next = y-1;  
    % if the next point is within the bound
    if((x_next>=1)&&(y_next>=1)&&(x_next<=Im_sizes(1))&&(y_next<=Im_sizes(2))&&(Result(x_next,y_next)==0)) 
        % first, set them to one to indicate they are "pushed in"
        Result(x_next,y_next)=1;
        ele_wait = ele_wait+1;
        point_queue(ele_wait,:) = [x_next y_next Im(x_next,y_next)];     
    end
    
    x_next = x+1; 
    y_next = y;   
    % if the next point is within the bound
    if((x_next>=1)&&(y_next>=1)&&(x_next<=Im_sizes(1))&&(y_next<=Im_sizes(2))&&(Result(x_next,y_next)==0)) 
        % first, set them to one to indicate they are "pushed in"
        Result(x_next,y_next)=1;
        ele_wait = ele_wait+1;
        point_queue(ele_wait,:) = [x_next y_next Im(x_next,y_next)]; 

    end
    
    x_next = x-1; 
    y_next = y;  
    % if the next point is within the bound
    if((x_next>=1)&&(y_next>=1)&&(x_next<=Im_sizes(1))&&(y_next<=Im_sizes(2))&&(Result(x_next,y_next)==0)) 
        % first, set them to one to indicate they are "pushed in"
        Result(x_next,y_next)=1;    
        ele_wait = ele_wait+1;
        point_queue(ele_wait,:) = [x_next y_next Im(x_next,y_next)];   
    end
         
    dist = abs(point_queue(1:ele_wait,3)-seg_mean);
    
    % take the point with the most similar value into it 
    [pixdist, good] = min(dist);
    
    seg_size=seg_size+1;
    seg_mean= (seg_mean*seg_size + point_queue(good,3))/(seg_size+1);
    
    % let that one to be 2, means "in" the segment
    x = point_queue(good,1); 
    y = point_queue(good,2);
    Result(x,y)=2; 
    
    % just like "pop" in STL, overwrites the "good" element with the last
    point_queue(good,:)=point_queue(ele_wait,:); 
    
    % one of them done
    ele_wait=ele_wait-1;
end
% so finally there are 2 numbers one is 1 the other is 2
% 1 represents the not qualified at last; 2 is qualified ones
Result = (Result == 2);
end







