function array=insert(Array,element)

array=zeros(1,length(Array) + 1);
    for i=1:length(Array)
        array(i)=Array(i);
        
    end

array(end)=element;


end

