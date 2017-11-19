function [keypoints]=KeypointOrientation(I,keypoints)


[row,col]=size(I);
points=zeros(16,16);
orient=zeros(2,2);
for i=2:size(keypoints,1)
    
rowCoor = keypoints(i,1);
colCoor = keypoints(i,2);
if colCoor > 8 && rowCoor >8 && rowCoor+8<row && colCoor+8<col
points=I(((rowCoor-8):(rowCoor+8)),(colCoor-8):(colCoor+8));
points=imgaussfilt(points,1.6*1.5);
    for k=2:15 % her point için 16x16 l?k window içerisindeki her noktan?n yönünü buluyor. Bunu histograma aktar?p 10 derecelik aral?klara yerle?tirmemiz laz?m.
        %Sonra oradaki peak noktas?n? bulup bu pointin orientation? bu
        %diye kaydetmemiz laz?m.
        for p=2:15
        orient(p,1)=double(sqrt(abs(points(k+1,p)-points(k-1,p))^2+(abs(points(k,p+1)-points(k,p-1))^2)));%magnitude

        orient(p,2)=double(atand(((points(k,p+1)-points(k,p-1))/((points(k+1,p)-points(k-1,p))))));%%theta direction
            if orient(p,2)<0
                orient(p,2)=360 + orient(p,2);
            end
            orient(p,2)=floor(orient(p,2)/10)*10;
            
        end
    end
 
end
mod=mode(orient(:,2));
keypoints(i,3)=mod;

end






end