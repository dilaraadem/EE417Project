function [ discardedExtrema ] = discard(extrema, DoG)

    thresContrast = 0.85;
    eigenRatio = 10;
    
    discardedExtrema = zeros(1,2);

    for i=2:size(extrema,1)
        rowCoor = extrema(i,1);
        colCoor = extrema(i,2);
        
        if (abs(DoG(rowCoor,colCoor)) > thresContrast)
            
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
                discardedExtrema(end+1,1) = rowCoor;
                discardedExtrema(end,2) = colCoor;
            end
        end
    end
end


