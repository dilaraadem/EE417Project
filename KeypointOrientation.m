function [features,keypoints]=KeypointOrientation(I,keypoints,windowSize,octave)

[row,col]=size(I);
points=[];
features=[];
weight = fspecial('gaussian',windowSize,1.5*octave);

for i=2:size(keypoints,1)
    rowCoor = keypoints(i,1);
    colCoor = keypoints(i,2);
    if colCoor > windowSize && rowCoor >windowSize && rowCoor+windowSize<row && colCoor+windowSize<col
        points=I(((rowCoor-(windowSize/2)+1):(rowCoor+windowSize/2)),(colCoor-(windowSize/2)+1):(colCoor+windowSize/2));
        %points=imgaussfilt(points,octave*1.5);
        [dy,dx]=gradient(double(points));
        M=sqrt(dy.^2 + dx.^2);%magnitude
        theta=rad2deg(atan2(dy,dx)); %yön
        %M = imgaussfilt(M,octave*1.5);
        
        theta=(floor(theta/10)*10 + 360);
        theta=mod(theta,360)/10 +1;
        %imshow(points); hold on; quiver(dy,dx);
        arr=Histogrammer(theta,M,36,weight);
        theta=theta(:);
        
        elements=unique(theta,'stable');
        
        freq=arr*100/max(arr);
        
        for k=1:36
            if round(freq(k)) == 100
                keypoints(i,3)=k;
            elseif freq(k)>=80 && freq(k)<100
                keypoints(end+1,1)=rowCoor;
                keypoints(end,2)=colCoor;
                keypoints(end,3)=k;
            end
        end
        
    else
        keypoints(i,:) = -1;
        %features(:,i) = -1;
    end
end

keypoints((keypoints(:,1) == -1),:) =[];
%weight2=fspecial('gaussian',windowSize,windowSize/2);

for i=2:size(keypoints,1)
    
    gaussWeight = getGaussWeights(windowSize, windowSize/2);
    
    rowCoor = keypoints(i,1);
    colCoor = keypoints(i,2);
    
    %points=I(((rowCoor-windowSize/2+1):(rowCoor+windowSize/2)),(colCoor-windowSize/2+1):(colCoor+windowSize/2));
    
    [dy,dx]=gradient(I);
    mag_des=sqrt(dy.^2 + dx.^2);
    
    theta2 = (atan2(dy,dx));
    
    v = [rowCoor, colCoor]';
    c = [size(mag_des,1)/2, size(mag_des,2)/2]';
    
    rotAngle = keypoints(i,3)*10;   %360 - rotAngle dene olmazsa!!
    
    %Rotated magitude and orientation
    rotMag = imrotate(mag_des,rotAngle);
    rotOrient = imrotate(theta2,rotAngle);
    
    rot_Mat = [cosd(rotAngle) -sind(rotAngle); sind(rotAngle) cosd(rotAngle)];
    
    temp_v = rot_Mat*(v-c);
    rot_v = temp_v+c;
    
    difmat = [(size(rotMag,1) - size(mag_des,1))/2, (size(rotMag,2) - size(mag_des,2))/2]';
    rot_v2 = rot_v + difmat;
    
    %Rotated row and col
    rotRow = rot_v2(1);
    rotCol = rot_v2(2);
    
    kptDescriptor = zeros(128,1);
    %weight2 = imrotate(weight2,keypoints(i,3)*10);
    %weight2 = imresize(weight2,[16 16]);
    %%[prow,pcol]=size(points);
    %%binNum=1;
    %points=imrotate(points,keypoints(i,3)*10);
    
    %%the window is 16 x 16 pixels in the keypoint level%%
    for x = 0:windowSize-1
        for y = 0:windowSize-1
            
            %first identify subregion I am in
            subregAxisX = floor(x/4);
            
            subregAxisY = floor(y/4);
            
            
            yCoord = rotRow + y - windowSize/2;
            xCoord = rotCol + x - windowSize/2;
            yCoord = round(yCoord);
            xCoord = round(xCoord);
            %get the magnitude
            if(yCoord>0&&xCoord>0&&yCoord<=size(rotMag,1) && xCoord<=size(rotMag,2))
                
                magn = rotMag(yCoord,xCoord);
                
                
                %multiply the magnitude by gaussian weight
                magn = magn*gaussWeight(y+1,x+1);
                
                orientation = rotOrient(yCoord,xCoord);
                orientation = orientation + pi;
                %calculate the respective bucket
                
                bucket = (orientation)*(180/pi);
                bucket = ceil(bucket/45);
                
                kptDescriptor((subregAxisY*4+subregAxisX)*8 + bucket) = kptDescriptor((subregAxisY*4+subregAxisX)*8 + bucket) + magn;
            end
        end
    end
    
    %normalize the vector
    sqKptDescriptor = kptDescriptor.^2;
    sumSqKptDescriptor = sum(sqKptDescriptor);
    dem = sqrt(sumSqKptDescriptor);
    kptDescriptor = kptDescriptor./dem;
    
    %threshold
    kptDescriptor(find(kptDescriptor>0.2))=0.2;
    
    
    
    %Renormalizing again, as stated in 6.1 of [1]
    sqKptDescriptor = kptDescriptor.^2;
    sumSqKptDescriptor = sum(sqKptDescriptor);
    dem = sqrt(sumSqKptDescriptor);
    kptDescriptor = kptDescriptor./dem;
    
    
    features(:,i)=kptDescriptor;
    
end


    function getGaussWeights = getGaussWeights(windowSize, sigma)
        index = fspecial('Gaussian', [windowSize windowSize], sigma);
        index = index.*(1/max(max(index)));
        getGaussWeights = index;
    end




end









%         for k=1:4:prow-3 %%feature vector is being created
%             for p=1:4:pcol-3
%
%                 miniPoint=points(k:k+3,p:p+3);
%                 weight2_win = weight2(k:k+3,p:p+3);
%
%
%                 %theta2=mod((mod(rad2deg(atan2(dy,dx)),360) - keypoints(i,3)*10),360); %Orientation invariant KONTROL ET!!
%
%                 %theta2_SIL = mod((mod(rad2deg(atan2(dy,dx)),360) - keypoints(i,3)*10),360);
%                 %theta2_orientation = keypoints(i,3)*10;
%
%                 theta2=floor(theta2/45)+1;
%                 arr=Histogrammer(theta2,magtheta,8,weight2_win);
%
%                 descriptor(binNum:(binNum +7))=arr;
%                 descriptor=normr(descriptor);
%
%
%                 binNum=binNum+8;
%             end
%         end
%         %Bu kýsma bir daha bak!!
%         %original paperda 1-d var oraya bak!!!
%         %descriptor=normr(descriptor);
%         for t=1:128
%             if descriptor(t)>0.2
%                 descriptor(t)=0.2;
%                 descriptor=normr(descriptor);
%             end
%         end
%
%         features(:,i)=descriptor;
% end
