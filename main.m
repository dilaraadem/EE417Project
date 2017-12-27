clc;
clear all;
close all;

I=imread('dataset/img3.jpg');
feat=SIFT(I);

feat2=SIFT(imrotate(I,10));
size1=size(feat(:,:));
size2=size(feat2(:,:));
match=0;
for i=1:min(size1(2),size2(2))
    
    if corr(feat(:,i),feat2(:,i))>0.7
       
        match=match+1;
        
    end
    
end