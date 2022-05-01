


% imds=imageDatastore('E:\git\maskRCNN\testLabel\', ...
%     'FileExtensions','.gz','ReadFcn', @(x)readLabel(x));

imds= readLabel('E:\git\maskRCNN\labelsTr\case_00173.nii.gz');
function ds = readLabel(label)
    label= load_nii(label);
    image=label.img;
    [xSize,ySize,zSize] = size(image);
    counter=int16(1);
    
    masks={};
    for z = 53:78
        mask=[];
        left = logical(image(1:(xSize/2),:,z)==1);
        right = logical(image((1+(xSize/2):xSize),:,z)==1);

        [xCoordinate,yCoordinate,boxWidth,boxHeight] = getCoordinates(left);
        if boxWidth  ~= 0 && boxHeight ~= 0 
            mask(1:(xSize/2),:,1)=left;
            mask((1+(xSize/2):xSize),:,1)=0;
        end

        [xCoordinate,yCoordinate,boxWidth,boxHeight] = getCoordinates(right);
        if boxWidth  ~= 0 && boxHeight ~= 0 
            [x,y,z]=size(mask);
            if(z==0 || x==0)
                mask((1+(xSize/2):xSize),:,1)=right;
                mask(1:(xSize/2),:,1)=0;
%                 mask(:,:,2)=0;
            else
                mask(1:(xSize/2),:,2)=0;
                mask((1+(xSize/2):xSize),:,2)=right;
            end
        else
%             mask(:,:,2)=0;
        end
        try
            masks(counter,1)={logical(mask==1)};
        catch exception
            
            display (z);
        end
        counter = counter+1;
    end
    ds=arrayDatastore(masks,"ReadSize",1,"OutputType","same");
end