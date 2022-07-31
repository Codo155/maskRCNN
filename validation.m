tic
ctDirectory = uigetdir("",'Please select the folder with the CT images.');

labelDirectory = uigetdir("",'Please select the folder with the labels.');

netWorkDirectory= uigetdir("",'Please select the folder with the networks.');


modelNames = dir(strcat(netWorkDirectory,'\*.mat'));
    

for modelIndex=1:length (modelNames)

    modelFile = strcat(netWorkDirectory,'\',modelNames(modelIndex).name);
    iteration= split(modelFile,"_");
    iteration= char(iteration(4));
    net=load(modelFile);
    net=net.net;

    result = validationFunction(net,labelDirectory,ctDirectory);
    csv_Name= strcat(netWorkDirectory,"\result_",iteration,".csv");
    writematrix(result,csv_Name) 
end

toc

% tic
% ctDirectory = uigetdir("",'Please select the folder with the CT images.');
% 
% labelDirectory = uigetdir("",'Please select the folder with the labels.');
% 
% 
% 
% ctFiles = dir(strcat(labelDirectory,'\*.nii.gz'));
% net=load('E:\git\maskRCNN\checkpoints\01\trainedMaskRCNN-2022-07-22-06-21-02.mat');
% net=net.net;
% 
% counter=int16(1);
% masks={};
% dice_results=[];
% 
% % dice_results(counter,1:10)=1:10;
% % counter = counter +1;
% for i=1:length (labelDirectory)
%     try
%         labelFile = strcat(labelDirectory,'\',ctFiles(i).name);
%         labelImage = logical(load_nii(labelFile).img==1);
%         
%         ctFile=strcat(ctDirectory,'\',ctFiles(i).name);
%         ctImage = gpuArray(load_nii(ctFile).img);   
% %         ctImage = load_nii(ctFile).img;
% 
%     catch exception
%         continue;
%     end
% 
%     labelImageIndex=[];
%     [xSlices,ySlices,zSlices] = size(labelImage);
%     
%     labelImageIndex =find(sum(labelImage,[1,2])>0);
%     % spy(labelImage(:,:,z)) to check
%    
%     if(length(labelImageIndex)<=0)
%         continue;
%     end
% 
%     
%     for z=1:length(labelImageIndex)
%         index=labelImageIndex(z);
%         img=ctImage(:,:,index);
%         rgb= cat(3,img,img,img);
% 
%         for t=1:10
%             result=NaN;
%             treshold= 0.1*t;
%             [masks,labels,scores,boxes] = segmentObjects(net,rgb,Threshold=treshold);
%             mask_result= any(masks,3);
%             if all(size(mask_result)>0) 
%                 result = dice(logical(labelImage(:,:,index)),mask_result);
%             end
%             if ~isnan(result) && all(size(labels) >0)
%                 dice_results(counter,t)=result;
%             end
%         end
%         counter = counter +1;
%     end
%     
% end
% toc
