function [keypoints]=KeypointOrientation(I,keypoints)
 
 
[row,col]=size(I);
points=zeros(8,8);

for i=2:size(keypoints,1)
    
rowCoor = keypoints(i,1);
colCoor = keypoints(i,2);
if colCoor > 8 && rowCoor >8 && rowCoor+8<row && colCoor+8<col
points=I(((rowCoor-4):(rowCoor+4)),(colCoor-4):(colCoor+4));
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


end
end
end