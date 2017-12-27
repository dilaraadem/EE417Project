clc;
clear all;
close all;

I=imread('dataset/img3.jpg');
%I=imresize(I,0.2);
I=double(rgb2gray(I));
k=sqrt(2);
sigma=1.6;
I1=imgaussfilt(I,sigma);
I2=imgaussfilt(I,k*sigma);
I3=imgaussfilt(I,k^2*sigma);
I4=imgaussfilt(I,k^3*sigma);
Ihalf=imresize(I,0.5);
Ihalf1=imgaussfilt(Ihalf,k^2*sigma);
Ihalf2=imgaussfilt(Ihalf,k^3*sigma);
Ihalf3=imgaussfilt(Ihalf,k^4*sigma);
Ihalf4=imgaussfilt(Ihalf,k^5*sigma);
Iquarter=imresize(Ihalf,0.5);
Iquarter1=imgaussfilt(Iquarter,k^4*sigma);
Iquarter2=imgaussfilt(Iquarter,k^5*sigma);
Iquarter3=imgaussfilt(Iquarter,k^6*sigma);
Iquarter4=imgaussfilt(Iquarter,k^7*sigma);

DoG1=I1-I2;
DoG2=I2-I3;
DoG3=I3-I4;
DoGHalf1=Ihalf1-Ihalf2;
DoGHalf2=Ihalf2-Ihalf3;
DoGHalf3=Ihalf3-Ihalf4;
DoGQ1=Iquarter1-Iquarter2;
DoGQ2=Iquarter2-Iquarter3;
DoGQ3=Iquarter3-Iquarter4;

DoG(1).im=DoG1;
DoG(2).im=DoG2;
DoG(3).im=DoG3;
DoG(4).im=DoGHalf1;
DoG(5).im=DoGHalf2;
DoG(6).im=DoGHalf3;
DoG(7).im=DoGQ1;
DoG(8).im=DoGQ2;
DoG(9).im=DoGQ3;

extremaCoor = extrema(DoG);
% figure;imshow(uint8(I));hold on ;plot(extremaCoor(2:end,2),extremaCoor(2:end,1),'*');

%Bunlar esas keypointslerimiz
keypointsFull = interpolatedDoG(DoG,extremaCoor);
discardedKeypointsFull = discard2(keypointsFull, DoG);
% figure;imshow(uint8(I));hold on ;plot(discardedKeypointsFull(2:end,2),discardedKeypointsFull(2:end,1),'*');
%figure;imshow(uint8(Ihalf));hold on ;plot(discardedKeypointsHalf(2:end,2),discardedKeypointsHalf(2:end,1),'*');
%figure;imshow(uint8(Iquarter));hold on ;plot(discardedKeypointsQ(2:end,2),discardedKeypointsQ(2:end,1),'*');

orientedExtrema=KeypointOrientation(DoG,discardedKeypointsFull,16); 



