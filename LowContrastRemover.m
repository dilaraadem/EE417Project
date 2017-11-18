function keypointsResult = LowContrastRemover(keypointsMat,Image,threshold)

for i=1:length(keypointsMat(1,:))
        
        
    if Image(keypointsMat(1,i),keypointsMat(2,i))>threshold
       keypointsResult=insert(keypointsResult(1,:),i);
       keypointsResult=insert(keypointsResult(2,:),keypointsMat(2,i));
         
    end



end