function [ keypoints ] = interpolatedDoG( DoG_a, DoG_b, DoG_c, extrema, octave )

    % Outputlar offset, extremaInter di!!!!
    % m row, n col
    gradient = zeros(3,1);
    hessian = zeros(3,3);
    
    offset = zeros(1,3);
    extremaInter = 0;
    
    keypoints = zeros(1,7); %s,i,j,sigma,row,col,extremaInter
    
    extrema(:,3) = 2;
    
    for a = 2:size(extrema,1)
        
        i = extrema(a,1);
        j = extrema(a,2);
        s = extrema(a,3);
        
        cond = 0;
        
        while(true)
            
            gradient(1,1) = (DoG_c(i,j) - DoG_a(i,j))/2;
            gradient(2,1) = (DoG_b(i+1,j) - DoG_b(i-1,j))/2;
            gradient(3,1) = (DoG_b(i,j+1) - DoG_b(i,j-1))/2;
            
            hessian(1,1) = DoG_c(i,j) + DoG_a(i,j) - 2*DoG_b(i,j);
            hessian(2,2) = DoG_b(i+1,j) + DoG_b(i-1,j) - 2*DoG_b(i,j);
            hessian(3,3) = DoG_b(i,j+1) + DoG_b(i,j-1) - 2*DoG_b(i,j);
            hessian(1,2) = (DoG_c(i+1,j) - DoG_c(i-1,j) - DoG_a(i+1,j) + DoG_a(i-1,j))/4;
            hessian(1,3) = (DoG_c(i,j+1) - DoG_c(i,j-1) - DoG_a(i,j+1) + DoG_a(i,j-1))/4;
            hessian(2,1) = (DoG_c(i+1,j) - DoG_c(i-1,j) - DoG_a(i+1,j) + DoG_a(i-1,j))/4;
            hessian(2,3) = (DoG_b(i+1,j+1) - DoG_b(i+1,j-1) - DoG_b(i-1,j+1) + DoG_b(i-1,j-1))/4;
            hessian(3,1) = (DoG_c(i,j+1) - DoG_c(i,j-1) - DoG_a(i,j+1) + DoG_a(i,j-1))/4;
            hessian(3,2) = (DoG_b(i+1,j+1) - DoG_b(i+1,j-1) - DoG_b(i-1,j+1) + DoG_b(i-1,j-1))/4;
            
            %offset(end+1,:) = -((inv(hessian))*gradient).';
            
            %extremaInter(end+1) = DoG_b(i,j) - (0.5)*gradient.' * inv(hessian)*gradient;
            
            offset = -((inv(hessian))*gradient).';
            extremaInter = DoG_b(i,j) - (0.5)*gradient.' * inv(hessian)*gradient;
            
            
                if (octave == 1)
                    sigma = 1.6 * 2^((offset(1,1)+s)/4);
                    newRow = 0.5*(offset(1,2)+i);
                    newCol = 0.5*(offset(1,3)+j);
                elseif (octave == 2)
                    sigma = 2 * 1.6 * 2^((offset(1,1)+s)/4);
                    newRow = (offset(1,2)+i);
                    newCol = (offset(1,3)+j);
                elseif (octave == 3)
                    sigma = 4 * 1.6 * 2^((offset(1,1)+s)/4);
                    newRow = 2*(offset(1,2)+i);
                    newCol = 2*(offset(1,3)+j);
                end
                
                extrema(a,1) = i + offset(1,2);
                extrema(a,2) = j + offset(1,3);
                extrema(a,3) = s + offset(1,1);
                
                cond = cond +1;
                
                if (max(offset) < 0.6 || cond == 5)
                    break;
                end
        end
        
        if (max(offset) < 0.6)
            keypoints(end+1,1) = extrema(a,3);
            keypoints(end,2) = extrema(a,1);
            keypoints(end,3) = extrema(a,2);
            keypoints(end,4) = sigma;
            keypoints(end,5) = newRow;
            keypoints(end,6) = newCol;
            keypoints(end,7) = extremaInter;
        end
            
    end
    
end

