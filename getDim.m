directory = uigetdir;
files = dir (strcat(directory,'\*.nii.gz'));
L = length (files);

x = ones(1,L);
y = ones(1,L);
z = ones(1,L);

for i=1:L
    file = strcat(directory,'\',files(i).name);
    image = load_nii(file);
    s=size(image.img);
    x(i)= s(1);
    y(i)= s(2);
    z(i)= s(3);
end

disp(mean(x))
disp(mean(y))
disp(mean(z))