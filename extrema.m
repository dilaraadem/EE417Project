function [extremaCoor] = extrema(DoG_a, DoG_b, DoG_c)

maskConst = 3;
row = size(DoG_a,1);
col = size(DoG_a,2);

sortArray = zeros(26,1);
extremaCoor = zeros(1,3);

    for i = maskConst:row
        for j = maskConst:col
            
            window1 = DoG_a((i-maskConst+1:i),(j-maskConst+1:j));
            window2 = DoG_b((i-maskConst+1:i),(j-maskConst+1:j));
            window3 = DoG_c((i-maskConst+1:i),(j-maskConst+1:j));
           
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
            end                                         % 1.column x, 2.column y olcak!!!

        end
    end

end


