function [extremaC] = extrema(DoG)

maskConst = 3;
sortArray = zeros(26,1);

for k=1:3
    extremaCoor = zeros(1,2);
    if(k==1) %full
    row = size(DoG(1).im,1);
    col = size(DoG(1).im,2);
    elseif (k==2) %half
    row = size(DoG(4).im,1);
    col = size(DoG(4).im,2);
    elseif (k==3) %quarter
    row = size(DoG(7).im,1);
    col = size(DoG(7).im,2);
    end
    for i = maskConst:row
        for j = maskConst:col
            
            window1 = DoG(1).im((i-maskConst+1:i),(j-maskConst+1:j));
            window2 = DoG(2).im((i-maskConst+1:i),(j-maskConst+1:j));
            window3 = DoG(3).im((i-maskConst+1:i),(j-maskConst+1:j));
         
            middleVal = window2(2,2);
            
            rowCoor = i-maskConst+2;
            colCoor = j-maskConst+2;
            
            sortArray = window1(:);
            sortArray(10:12,1) = window2(1,:);
            sortArray(13,1) = window2(2,1);
            sortArray(14,1) = window2(2,3);
            sortArray(15:17,1) = window2(3,:);
            sortArray(18:26,1) = window3(:);
            
            sortArray = sort(sortArray);
           
            if (middleVal > sortArray(end)) || (middleVal < sortArray(1))
                  extremaCoor(end+1,1) = rowCoor;      % keypoitsCoor adinda dinamik matrix yarattim cunku kac point olcagini bilmiyoruz 
                  extremaCoor(end,2) = colCoor;      % prealloction ile de row*col olarak cikiyor. O da cok buyuk. Row sayisi kac point olcagini vericek
                  %extremaCoor(end,3)=k;
            end                                         % 1.column x, 2.column y olcak!!!
%             extremaCoor(i).coor=extremaCoor;
%             extremaCoor(i).octave=k;
        end
    end
    extremaC(k).coor=extremaCoor;
end
end

