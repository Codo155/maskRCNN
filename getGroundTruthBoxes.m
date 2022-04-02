% directory = uigetdir;
% files = dir (strcat(directory,'\*.nii.gz'));
% 

label = load_nii('E:\git\maskRCNN\labelsTr\case_00209.nii.gz');
% label.img = permute(label.img(1:256,:,:),[3,2,1]);
% label.img = permute(label.img(:,:,:),[3,2,1]);

image= label.img;
boxLabel = label;
[xDim,yDim,zDim]=size(image);
for z=1:zDim
        i = squeeze(image(1:(xDim/2),:,z))==1;
        [xCoordinate,yCoordinate,boxWidth,boxHeight] = getCoordinates(i);
        if boxWidth  ~= 0 && boxHeight ~= 0 
            newImage=getBoxLabel(i,xCoordinate, yCoordinate, boxHeight,boxWidth);
            boxLabel.img(1:(xDim/2),:,z) =newImage(1:256,:) ;
        end

        i = squeeze(image((1+(xDim/2):xDim),:,z))==1;
        [xCoordinate,yCoordinate,boxWidth,boxHeight] = getCoordinates(i);
        if boxWidth  ~= 0 && boxHeight ~= 0 
            newImage=getBoxLabel(i,xCoordinate, yCoordinate, boxHeight,boxWidth);
            boxLabel.img((1+(xDim/2):xDim),:,z) =newImage(:,:) ;
        end

end

ct = load_nii('E:\git\maskRCNN\imagesTr\case_00209.nii.gz');

idx1 = find(label.img==1);
idx2= find(boxLabel.img==1);

ct.img(idx1) = label.img(idx1);
label.img(idx2) = boxLabel.img(idx2);
option.setviewpoint = [48 218 z];
option.setvalue.idx = find(label.img);
option.setvalue.val = label.img(find(label.img));
option.setcolorindex = 3;

view_nii(ct,option);