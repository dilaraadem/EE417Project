function [keypoints]=KeypointOrientation(I,keypoints,windowSize,octave)
 
 
[row,col]=size(I);
points=[];
features=[];
for i=2:size(keypoints,1)
    
rowCoor = keypoints(i,1);
colCoor = keypoints(i,2);
if colCoor > windowSize && rowCoor >windowSize && rowCoor+windowSize<row && colCoor+windowSize<col
points=I(((rowCoor-windowSize/2+1):(rowCoor+windowSize/2)),(colCoor-windowSize/2+1):(colCoor+windowSize/2));
points=imgaussfilt(points,octave*1.5);
[dy,dx]=gradient(double(points));
M=sqrt(dy.^2 + dx.^2);%magnitude
theta=atan2(dy,dx)*180/pi; %yön

theta=(floor(theta/10)*10 + 360);
theta=mod(theta,360)/10 +1;
%imshow(points); hold on; quiver(dy,dx);
arr=Histogrammer(theta,M,36);
theta=theta(:);

elements=unique(theta,'stable');
% 
% 
% freq=[];
% for k=1:size(elements)
% 
% 
% freq(k)=sum( theta(:) == elements(k));%compute frequency of each element
% 
% end
freq=arr*100/max(arr);

for k=1:35
    if freq(k)==100
    keypoints(i,3)=theta(k);
    elseif freq(k)>=80 && freq(k)<100
    keypoints(end+1,1)=rowCoor;
    keypoints(end,2)=colCoor;
    keypoints(end,3)=theta(k);
    end
    
end

                descriptor=zeros(1,4*4*8);
              
               [prow,pcol]=size(points);
               binNum=1;
                gaus=imgaussfilt(points,octave*0.5);
                points=imrotate(points,keypoints(i,3)*10);
                for k=1:4:prow-3 %%feature vector is being created
                    for p=1:4:pcol-3
                        
                       miniPoint=points(k:k+3,p:p+3);
                       [dy,dx]=gradient(miniPoint);
                       magtheta=sqrt(dy.^2 + dx.^2);
                       theta2=atan2(dy,dx)*180/2*pi;
                       
                      
                       theta2=mod(theta2,360);
                       theta2=floor(theta2/45)+1;
                       arr=Histogrammer(theta2,magtheta,8);
                       
                       descriptor(binNum:(binNum +7))=arr;
                       descriptor=normr(descriptor);
                     
                           
                       binNum=binNum+8;
                      end               
                end
     for t=1:128

    if descriptor(t)>0.2
        descriptor(t)=0.2;
    end
    
    
    descriptor=normr(descriptor);
     end           
features(:,i)=descriptor;

end
end


end