% trainClassNames = {'kidney'};
% numClasses = length(trainClassNames);
% imageSizeTrain = [512 512 2];
% 
% 
% ct1 =load_nii('E:\git\maskRCNN\imagesTr\case_00161.nii.gz');
% 
% [xSize,ySize,zSize] = size(ct1.img);
directory = uigetdir;

ds=fileDatastore(directory,"ReadFcn",@fcn);
preview(ds);




function ds = fcn(data)
    filename = strsplit(data,'\');
    labelFolder= uigetdir;
    labelPath= strcat(labelFolder,'\',char(filename{end}));
    label =load_nii(labelPath);
    ct=load_nii(data);
    image=ct.img;
    [xSize,ySize,zSize] = size(image);
    for z = 1:zSize
        boxes=[];
        categorical=[];

        i = squeeze(label.img(1:(xSize/2),:,z))==1;
        mask1 = i;
        mask1(1+(xSize/2):xSize,:)=0;
        [xCoordinate,yCoordinate,boxWidth,boxHeight] = getCoordinates(i);

        if boxWidth  ~= 0 && boxHeight ~= 0 
            boxes=[xCoordinate yCoordinate boxWidth boxHeight];
            categorical=['kidney'];
        end

        i = squeeze(label.img((1+(xSize/2):xSize),:,z))==1;
        mask2(1:(xSize/2),:)=0;
        mask2(1+(xSize/2):xSize,1:ySize)= i;
        [xCoordinate,yCoordinate,boxWidth,boxHeight] = getCoordinates(i);
        if boxWidth  ~= 0 && boxHeight ~= 0 
            boxes= [boxes; xCoordinate yCoordinate boxWidth boxHeight];
            categorical=[categorical;'kidney']
            ds{z,2}=boxes;
            ds{z,3}= categorical;
        end
        if z == 56
            display(z)
        end
        masks(:,:,1)=mask1;
        masks(:,:,2)=mask2;
        ds{z,4}=masks;
        ds{z,1}=image(:,:,z);
    end
end

