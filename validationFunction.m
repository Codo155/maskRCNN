function dice_results= validationFunction(net,labelDirectory,ctDirectory)
    ctFiles = dir(strcat(ctDirectory,'\*.nii.gz'));
    counter=int16(1);
    masks={};
    dice_results=[];
    
    for i=1:length (ctFiles)
        try
            labelFile = strcat(labelDirectory,'\',ctFiles(i).name);
            labelImage = logical(load_nii(labelFile).img==1);
            
            ctFile=strcat(ctDirectory,'\',ctFiles(i).name);
            ctImage = gpuArray(load_nii(ctFile).img);
    
        catch 
            continue;
        end  
        
        labelImageIndex =find( sum(labelImage,[1,2])>0);
        % spy(labelImage(:,:,z)) to check
       
        if(length(labelImageIndex)<=0)
            continue;
        end
 
        for z=1:length(labelImageIndex)
            index=labelImageIndex(z);
            img=ctImage(:,:,index);
            img=uint8(img*255);
            rgb= cat(3,img,img,img);
    
            for t=1:10
                result=NaN;
                treshold= 0.1*t;
                try
                    [masks,labels,~] = segmentObjects(net,rgb,Threshold=treshold);
                catch 
                    disp('exception');
                end
                mask_result= any(masks,3);
                if all(size(mask_result)>0) 
                    result = dice(labelImage(:,:,index),mask_result);
                end
                if ~isnan(result) && all(size(labels) >0)
                    dice_results(counter,t)=result;
                end
            end
            counter = counter +1;
        end     
    end
    dice_results=dice_results;
end

