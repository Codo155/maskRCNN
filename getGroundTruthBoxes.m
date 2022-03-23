% directory = uigetdir;
% files = dir (strcat(directory,'\*.nii.gz'));
% 

label = load_nii('E:\git\maskRCNN\labelsTr\case_00132.nii.gz');
% label.img = permute(label.img(1:256,:,:),[3,2,1]);
label.img = permute(label.img(:,:,:),[3,2,1]);

image= label.img;
for z=1:352
        i = squeeze(image(z,:,:))==1;
        [rows, columns] = size(i);
        parfor row = 1 : rows
            % Make measurements of all lines of 1's.
            props = regionprops(i(row, :), 'Area');
            % Extract all the lengths into a vector and then put into a cell.
            R{row} = [props.Area];
            R{row}= sum(R{row}) 
        end
        sumR = cell2mat(R(1,:));
        boxWidth=max(sumR);
        maxW = find(sumR==boxWidth);

        parfor counter =1 : length(maxW)
            row=gpuArray(i(maxW(counter),:));
            xCoordinate(counter)= find(row~=0,1,'first');
        end
        xCoordinate=min(xCoordinate);
        yCoordinate= find(sumR~=0,1,'first');
        boxHeight= find(sumR~=0,1,'last');
        
        

end

option.setviewpoint = [256 180 348];
view_nii(label,option);


% permute(label.img(256,:,:))