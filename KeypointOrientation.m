function [features]=KeypointOrientation(I,keypoints,windowSize,octave)

[row,col]=size(I);
points=[];
features=[];

for i=2:size(keypoints,1)
    rowCoor = keypoints(i,1);
    colCoor = keypoints(i,2);
    if colCoor > windowSize && rowCoor >windowSize && rowCoor+windowSize<row && colCoor+windowSize<col
        points=I(((rowCoor-windowSize/2+1):(rowCoor+windowSize/2)),(colCoor-windowSize/2+1):(colCoor+windowSize/2));
        %points=imgaussfilt(points,octave*1.5);
        weight = fspecial('gaussian',windowSize,1.5*octave);
        [dy,dx]=gradient(double(points));
        M=sqrt(dy.^2 + dx.^2);%magnitude
        theta=atan2(dy,dx)*180/pi; %y�n
        %M = imgaussfilt(M,octave*1.5);
        
        theta=(floor(theta/10)*10 + 360);
        theta=mod(theta,360)/10 +1;
        %imshow(points); hold on; quiver(dy,dx);
        arr=Histogrammer(theta,M,36,weight);
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
        
        for k=1:36
            if round(freq(k)) == 100
                keypoints(i,3)=k;
            elseif freq(k)>=80 && freq(k)<100
                keypoints(end+1,1)=rowCoor;
                keypoints(end,2)=colCoor;
                keypoints(end,3)=k;
            end
        end
        %DELETE UNORIENTED POINTS!!
        descriptor=zeros(1,4*4*8);
        weight2=fspecial('gaussian',windowSize,windowSize/1.5);
        [prow,pcol]=size(points);
        binNum=1;
        %points=imrotate(points,keypoints(i,3)*10);
        for k=1:4:prow-3 %%feature vector is being created
            for p=1:4:pcol-3
                
                miniPoint=points(k:k+3,p:p+3);
                weight2_win = weight2(k:k+3,p:p+3);
                [dy,dx]=gradient(miniPoint);
                magtheta=sqrt(dy.^2 + dx.^2);
                theta2=mod((mod(atan2(dy,dx)*180/2*pi,360) - keypoints(i,3)*10),360); %Orientation invariant KONTROL ET!!
                
                
                %theta2=mod(theta2,360);
                theta2=floor(theta2/45)+1;
                arr=Histogrammer(theta2,magtheta,8,weight2_win);
                
                descriptor(binNum:(binNum +7))=arr;
                descriptor=normr(descriptor);
                
                
                binNum=binNum+8;
            end
        end
        %Bu k�sma bir daha bak!!
        %original paperda 1-d var oraya bak!!!
        descriptor=normr(descriptor);
        for t=1:128
            if descriptor(t)>0.2
                descriptor(t)=0.2;
                descriptor=normr(descriptor);
            end
        end
        features(:,i)=descriptor;
        
    else
        keypoints(i,:) = -1;
        %features(:,i) = -1;
    end
end

end