label = load_nii('E:\git\maskRCNN\labelsTr\case_00209.nii.gz');
z=73;
image= label.img;


i = squeeze(image(1:256,:,z))==1;
[xCoordinate,yCoordinate,boxWidth,boxHeight] = getCoordinates(i);

boxLabel = label;
newImage=getBoxLabel(i,xCoordinate, yCoordinate, boxHeight,boxWidth);
boxLabel.img(1:256,:,z) =newImage(1:256,:) ;

i = squeeze(image(257:512,:,z))==1;
[xCoordinate,yCoordinate,boxWidth,boxHeight] = getCoordinates(i);
newImage=getBoxLabel(i,xCoordinate, yCoordinate, boxHeight,boxWidth);
boxLabel.img(257:512,:,z) =newImage(:,:) ;

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





