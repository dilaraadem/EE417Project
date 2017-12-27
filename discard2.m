function [ dkeypts ] = discard2(keypointStr, DoGG)

    thresContrast = 0.03;
    eigenRatio = 10;

    dkeypts=struct;    
for k=1:9
    discardedKeypoints = zeros(1,2);
    DoG=DoGG(k).im;
    if(k<=3)
    octave=1;
    elseif(k<=6 && k>3)
    octave=2;
    else
    octave=3;
    end
    keypoints=keypointStr(octave).keypoints; 
    for i=1:size(keypoints,2)
        rowCoor = max(round(keypoints(i).i),2); %i
        colCoor = max(round(keypoints(i).j),2); %j
        value = mat2gray(keypoints(i).extremaInter); %extremainter
        
        if (abs(value) > thresContrast)
            
            % x ve y directionlari image processing'de ters! sorun cikarir
            % mi bilmiyorum. Edge detection yaptigimiz icin fark etmiyor
            % olmasi gerek
            
            fxx = DoG(rowCoor-1,colCoor) + DoG(rowCoor+1,colCoor) - 2*DoG(rowCoor,colCoor);
            fyy = DoG(rowCoor,colCoor-1) + DoG(rowCoor,colCoor+1) - 2*DoG(rowCoor,colCoor);
            fxy = DoG(rowCoor-1,colCoor-1) + DoG(rowCoor+1,colCoor+1) - DoG(rowCoor-1,colCoor+1) - DoG(rowCoor+1,colCoor-1);
            
            trace = fxx + fyy;
            deter = fxx*fyy - fxy*fxy;
            
            curvature = (trace^2)/deter;
            thresCurv = ((eigenRatio+1)^2)/eigenRatio;
            
            if (curvature < thresCurv)
                discardedKeypoints(end+1,1) = rowCoor;
                discardedKeypoints(end,2) = colCoor;
            end
        end
    end

 dkeypts(k).dkpts=discardedKeypoints;
end
end

