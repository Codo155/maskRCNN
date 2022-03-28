label = load_nii('E:\git\maskRCNN\labelsTr\case_00209.nii.gz');
% label.img = permute(label.img(1:256,:,:),[3,2,1]);
% label.img = permute(label.img(:,:,:),[3,2,1]);
image= label.img;
i = squeeze(image(:,1:256,72))==1;
       
[rows, columns] = size(i);
parfor row = 1 : rows
    % Make measurements of all lines of 1's.
    props = regionprops(i(row,: ), 'Area');
    % Extract all the lengths into a vector and then put into a cell.
    R{row} = [props.Area];
    R{row}= sum(R{row}) 
end
sumR = cellfun(@sum,R);
boxWidth=max(sumR); % 78
maxW = find(sumR==boxWidth); % line 160

for  counter =1 : length(maxW)
    rowOfIntrest=i(maxW(counter),:);
    xCoordinate(counter)= find(rowOfIntrest~=0,1,'first');
end
xCoordinate=min(xCoordinate);
yCoordinate= find(sumR~=0,1,'first');
boxHeight= find(sumR~=0,1,'last')- yCoordinate;


boxLabel = label;
newImage=getBoxLabel(i,xCoordinate, yCoordinate, boxHeight,boxWidth);
boxLabel.img(:,1:256,72) =newImage(:,1:256) ;


ct = load_nii('E:\git\maskRCNN\imagesTr\case_00209.nii.gz');

idx1 = find(label.img==1);
idx2= find(boxLabel.img==1);

% ct.img(idx1) = label.img(idx1);
label.img(idx2) = boxLabel.img(idx2);
option.setviewpoint = [48 218 72];
option.setvalue.idx = find(label.img);
option.setvalue.val = label.img(find(label.img));
option.setcolorindex = 3;

view_nii(ct,option);

function boxLabelImage=getBoxLabel(img, xCoordinate, yCoordinate, boxHeight,boxWidth)
    img(:,:) = 0;
     % upper horizotal line
      img(yCoordinate,(xCoordinate:xCoordinate + boxWidth))=1;
%     
%     % lower horizontal line
      img(yCoordinate+boxWidth,(xCoordinate:xCoordinate + boxWidth))=1;
% 
%     % left vertical line
      img((yCoordinate:yCoordinate + boxWidth),xCoordinate)=1;
%     
%     % right vertical line
      hello = yCoordinate + boxWidth;
      disp(hello);
      img((yCoordinate:hello),xCoordinate+boxWidth)=1;
      boxLabelImage=img;
end
