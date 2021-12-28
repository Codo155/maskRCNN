image = load_nii('E:\git\maskRCNN\imagesTr\case_00167.nii.gz');
option.setviewpoint = [48 218 74];
%view_nii(nii);
label = load_nii('E:\git\maskRCNN\labelsTr\case_00167.nii.gz');
option.setvalue.idx = find(label.img);
option.setvalue.val = label.img(find(label.img));
option.setcolorindex = 3;

view_nii(image,option);

function dice = calculate_dice(nifti1,nifti2)
    common = (nifti1.img & nifti2.img);
    a = sum(common(:));
    b = sum(nifti1.img (:));
    c = sum(nifti2.img(:));
    dice = 2*a/(b+c);
end 