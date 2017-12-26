function [keypoints]=KeypointOrientation(I,keypoints,windowSize)
 
 
[row,col]=size(I);
points=[];

for i=2:size(keypoints,1)
    
rowCoor = keypoints(i,1);
colCoor = keypoints(i,2);
if colCoor > windowSize && rowCoor >windowSize && rowCoor+windowSize<row && colCoor+windowSize<col
points=I(((rowCoor-windowSize/2+1):(rowCoor+windowSize/2)),(colCoor-windowSize/2+1):(colCoor+windowSize/2));
points=imgaussfilt(points,1.6*1.5);
[dy,dx]=gradient(double(points));
M=sqrt(dy.^2 + dx.^2);%magnitude
theta=atan2(dy,dx)*180/pi; %yön

theta=(floor(theta/10)*10 + 360);
theta=mod(theta,360);
%imshow(points); hold on; quiver(dy,dx);
theta=theta(:);

elements=unique(theta,'stable');


freq=[];
for k=1:size(elements)


freq(k)=sum( theta(:) == elements(k));%compute frequency of each element

end
freq=freq*100/max(freq);

for k=1:size(elements)
    if freq(k)==100
    keypoints(i,3)=elements(k)/10;
    elseif freq(k)>=80 && freq(k)<100
    keypoints(end+1,1)=rowCoor;
    keypoints(end,2)=colCoor;
    keypoints(end,3)=elements(k)/10;
    end
    
end


              
%                [prow,pcol]=size(points);
%                 for k=1:4:prow-3 %%feature vector is being created
%                     for p=1:4:pcol-3
%                        miniPoint=points(k:k+3,p:p+3);
%                        [dy,dx]=gradient(miniPoint);
%                        magtheta=sqrt(dy.^2 + dx.^2);
%                        theta2=atan2(dy,dx)*180/2*pi;
%                        
%                        theta2=theta2-keypoints(i,3)*10;
%                        theta2=mod(theta2,360);
%                        theta2=floor(theta2/45)+1;
%                       
%                        
%                     end               
%                 end


end
end
end