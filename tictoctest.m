% x=niftiread("E:\git\maskRCNN\testImg\case_00173.nii");
% directory = uigetdir;

ctds = imageDatastore("E:\git\maskRCNN\testImg\case_00173.nii.gz", ...
    'FileExtensions','.gz','ReadFcn',@ct);

blocks= block('E:\git\maskRCNN\testImg\case_00173.nii.gz');

lables = imageDatastore("E:\git\maskRCNN\labelsTr\case_00173.nii.gz", ...
    'FileExtensions','.gz','ReadFcn',@ct);

ds= combine(ctds,blocks,lables);

trainClassNames = {'kidney'};
numClasses = length(trainClassNames);
imageSizeTrain = [512 512 3];

net = maskrcnn("resnet50-coco",trainClassNames,InputSize=imageSizeTrain);
options = trainingOptions("sgdm", ...
    InitialLearnRate=0.001, ...
    LearnRateSchedule="piecewise", ...
    LearnRateDropPeriod=1, ...
    LearnRateDropFactor=0.95, ...
    Plot="none", ...
    Momentum=0.9, ...
    MaxEpochs=10, ...
    MiniBatchSize=2, ...
    BatchNormalizationStatistics="moving", ...
    ResetInputNormalization=false, ...
    ExecutionEnvironment="gpu", ...
    VerboseFrequency=50);

doTraining = true;
if doTraining
    [net,info] = trainMaskRCNN(ds,net,options,FreezeSubNetwork="backbone");
    modelDateTime = string(datetime("now",Format="yyyy-MM-dd-HH-mm-ss"));
    save("trainedMaskRCNN-"+modelDateTime+".mat","net");
end

function blockds = block(data)
    filename = strsplit(data,'\');
    labelFolder= uigetdir;
    labelPath= strcat(labelFolder,'\',char(filename{end}));
    label =load_nii(labelPath);
    ct=load_nii(data);
    image=ct.img;
    [xSize,ySize,zSize] = size(image);
    box=cell(zSize,2);
    for z = 1:zSize
        boxes=[];
        cat={};
        i = squeeze(label.img(1:(xSize/2),:,z))==1;
        [xCoordinate,yCoordinate,boxWidth,boxHeight] = getCoordinates(i);

        if boxWidth  ~= 0 && boxHeight ~= 0 
            boxes(1,:)=[xCoordinate yCoordinate boxWidth boxHeight];
        end

        i = squeeze(label.img((1+(xSize/2):xSize),:,z))==1;
        [xCoordinate,yCoordinate,boxWidth,boxHeight] = getCoordinates(i);
        if boxWidth  ~= 0 && boxHeight ~= 0 
            [x,~]=size(boxes);
            if(x==0)
                boxes(1,:)=  [ xCoordinate yCoordinate boxWidth boxHeight];
            else
                boxes(2,:)= [ xCoordinate yCoordinate boxWidth boxHeight];
            end
        end
        [x,~]=size(boxes);
        if(x==1)
            box{z,1}=boxes;
            cat{1}='kidney';
        elseif(x==2)
            box{z,1}=boxes;
            cat=cell(2,1);
            cat{1}='kidney';
            cat{2}='kidney';
        elseif(x==0)
            cat={};
        end
        box{z,2}=cat;
    end
    table = cell2table(box,'VariableNames',{'Boxes','Labels'});
    blockds= boxLabelDatastore(table);
end

function ds = ct(data)
    ct=load_nii(data);
    image=ct.img;
    [~,~,zSize] = size(image);
    for z = 1:zSize        
        ds{z,:,:,1}=image(:,:,z);
        ds{z,:,:,2}=0;
        ds{z,:,:,3}=0;
    end
end
