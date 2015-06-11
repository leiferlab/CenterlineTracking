
imFolder = 'C:\Users\linder\Documents\Data\PanNeuronal Behav\20150610\Raw Images';
images=dir([imFolder filesep '*.jpeg']);
numframes = length(images);

frames = 1:40:numframes;

bg = im2double(imread(images(1).name));
for i =1:length(frames)
    Im = im2double(imread(images(frames(i)).name));
    
    bg = bg+Im;
    
end

background = bg./length(frames);