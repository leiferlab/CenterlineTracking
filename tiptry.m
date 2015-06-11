function tips = tiptry(imFolder,iImage, background)
disp('Finding all candidate tips!')


% clear all
% load('background20150428.mat')
% 
% 
% imFolder = 'C:\Users\linder\Documents\Data\PanNeuronal Behav\20150428\Raw Images';
 images=dir([imFolder filesep '*.jpeg']);
gausSize = 2;
    
thresh = .06;
    
    I = im2double(imread(images(iImage).name));
    I = I(:,:,1);
    Imb = I - background(:,:,1);
    Imb = Imb(:,:,1);
    
    If = imfilter(I,fspecial('gaussian', 6*gausSize,gausSize));
    Ifmb = imfilter(Imb,fspecial('gaussian', 6*gausSize,gausSize));
    
    Ibin = im2bw(Imb,thresh);
    Ibinf = imfilter(Ibin,fspecial('gaussian', 6*3,3));
     cc = bwconncomp(Ibinf);
     stats = regionprops(cc, 'Area');
     idx = find([stats.Area]>700);
     BW = ismember(labelmatrix(cc), idx);
     
     %Create Mexican hat-esque filter, apply to image to get tips
    [X,Y] = meshgrid(-15:15, -15:15);
    circle = double((X.^2 + Y.^2)<40) - .25; %Create circular filter
    Icirc = imfilter(BW,circle);

tips = regionprops(Icirc, 'centroid');
disp('OK!');
end
 
