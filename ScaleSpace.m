clc;
clear all;
close all;

I=imread('test.jpg');
I=imresize(I,0.2);
I=double(rgb2gray(I));
k=sqrt(2);
sigma=1.6;
I1=imgaussfilt(I,sigma);
I2=imgaussfilt(I,k*sigma);
I3=imgaussfilt(I,k^2*sigma);
I4=imgaussfilt(I,k^3*sigma);
Ihalf=imresize(I,0.5);
Ihalf1=imgaussfilt(Ihalf,sigma);
Ihalf2=imgaussfilt(Ihalf,k*sigma);
Ihalf3=imgaussfilt(Ihalf,k^2*sigma);
Ihalf4=imgaussfilt(Ihalf,k^3*sigma);
Iquarter=imresize(Ihalf,0.5);
Iquarter1=imgaussfilt(Iquarter,sigma);
Iquarter2=imgaussfilt(Iquarter,k*sigma);
Iquarter3=imgaussfilt(Iquarter,k^2*sigma);
Iquarter4=imgaussfilt(Iquarter,k^3*sigma);

DoG1=I1-I2;
DoG2=I2-I3;
DoG3=I3-I4;
DoGHalf1=Ihalf1-Ihalf2;
DoGHalf2=Ihalf2-Ihalf3;
DoGHalf3=Ihalf3-Ihalf4;
DoGQ1=Iquarter1-Iquarter2;
DoGQ2=Iquarter2-Iquarter3;
DoGQ3=Iquarter3-Iquarter4;

maskConst = 3;
row = size(DoG1,1);
col = size(DoG1,2);


keypointsX=zeros(1,2);
keypointsY=zeros(1,2);
for i = maskConst:row
    for j = maskConst:col
            
            window1 = double(DoG1((i-maskConst+1:i),(j-maskConst+1:j)));
            window2 = double(DoG2((i-maskConst+1:i),(j-maskConst+1:j)));
            window3 = double(DoG3((i-maskConst+1:i),(j-maskConst+1:j)));
           
            middleVal = window2(2,2);
            xCoord=i-maskConst+2;
            yCoord=j-maskConst+2;
            sortArray = zeros(1,26);
            sortArray = union(window1(1,:),window1(2,:));
            sortArray=union(window1(3,:),sortArray);
            sortArray=union(window2(1,:),sortArray);
            sortArray=union(window2(3,:),sortArray);
            sortArray=union(window2(2,1:2:3),sortArray);
            sortArray=union(window3(1,:),sortArray);
            sortArray=union(sortArray,window3(2,:));
            sortArray=union(window3(3,:),sortArray);
            %union sorun ç?kart?yor
            if middleVal>sortArray(end) || middleVal <sortArray(1)
                keypointsX=union(keypointsX,xCoord);
                keypointsY=union(keypointsY,yCoord);
            end

    end
end
figure;imshow(uint8(I));hold on ;plot(keypointsX-1,keypointsY,'*');




