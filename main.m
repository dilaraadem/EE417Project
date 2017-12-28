clc;
clear all;
close all;

tic
I=imread('dataset/img3.jpg');
I_comp = imread('dataset/img5.jpg');

[feature1,loc1]=SIFT(I);
[feature2,loc2]=SIFT(I_comp);

%Row Col ters basilmasi gerek!!

temp=loc1(:,2);
loc1(:,2)=loc1(:,1);
loc1(:,1)=temp;

temp=loc2(:,2);
loc2(:,2)=loc2(:,1);
loc2(:,1)=temp;

pairs = matchFeatures(feature1',feature2');

%figure;imshow(uint8(I));hold on;

pairs = matchFeatures(feature1',feature2','Method','Exhaustive','unique',10);

matchedLoc1 = loc1(pairs(:,1),:);
matchedLoc2 = loc2(pairs(:,2),:);

figure;
showMatchedFeatures(I,I_comp,matchedLoc1,matchedLoc2,'montage');
    

toc











% size1=size(feat(:,:));
% size2=size(feat2(:,:));
% % match=0;
% % for i=1:min(size1(2),size2(2))
% %     
% %     if corr(feat(:,i),feat2(:,i))>0.7
% %        
% %         match=match+1;
% %         
% %     end
% %     
% end

%    plot(loc1(pairs(:,1),2),loc1(pairs(:,1),1),'y','LineStyle','none','Marker','*','MarkerSize',10);
% 
%     figure;imshow(I_comp);hold on; plot(loc2(pairs(:,2),2),loc2(pairs(:,2),1),'y','LineStyle','none','Marker','*','MarkerSize',10);