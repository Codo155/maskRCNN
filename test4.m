net=load('trainedMaskRCNN-2022-04-29-18-26-40.mat');
net=net.net;
ctImage= load_nii('E:\git\maskRCNN\labelsTr\case_00173.nii.gz');
image = ctImage.img;
[xSize,ySize,zSize] = size(image);

for z=50:zSize

    [masks,labels,scores,boxes] = segmentObjects(net,image(:,:,z),Threshold=0.01);
    [x,y]=size(labels);
    if x>0
        display(z);
    end
end

dlimage = dlarray(image(:,:,55),"SSCB");
outputFeatures = forward(net,dlimage);
