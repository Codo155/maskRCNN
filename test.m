V = niftiread('F:\OneDrive\Dokumente\FH\MasterThesis\Data\segdata\KiTS\imagesTr\case_00005.nii.gz');
vmax = max(V,[],'all');
vmin = min(V,[],'all');
va_prime=(V-vmin)./(vmax-vmin);
dim=size(va_prime);
volshow(V);

X= 400;
Y= 250;
Z= 250;

frontal = va_prime(:,:,Z);
satigal = reshape(va_prime(X,:,:),[dim(2) dim(3)]);
hori = reshape(va_prime(:,Y,:),[dim(1) dim(3)]);


figure;
subplot(2,2,1); imshow(imrotate(frontal,-90)); title('Frontal');
subplot(2,2,2); imshow(imrotate(satigal,-90)); title('Sagittal');
subplot(2,2,3); imshow(imrotate(hori,-90)); title('Horizontal');