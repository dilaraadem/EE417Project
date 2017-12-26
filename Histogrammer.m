function [arr]= Histogrammer(theta,magnitude,binNum)

[row,col]=size(theta);
arr=zeros(1,binNum);


for i=1:row
    
    for j=1:col
        
   arr(1,theta(i,j))=arr(1,theta(i,j))+magnitude(i,j);
        
        
    end
    
end
    


















end