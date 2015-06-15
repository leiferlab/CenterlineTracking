clear all;

clear all;

imFolder = 'C:\Users\linder\Documents\Data\PanNeuronal Behav\20150611\Worm8\Raw Images';
images=dir([imFolder filesep '*.jpeg']);
numframes = length(images);
 %load('C:\Users\linder\Documents\Data\PanNeuronal Behav\20150420\20150420_tips.mat');
% load('C:\Users\linder\Documents\Data\PanNeuronal Behav\20141212\PNworm3\20141212pn3tips.mat')
% % % % 
% % % % 
    %startframe = length(tip2(:,2));
%startframe = length(tip2(:,1));
startframe = 1;
framesclicked = 1:5:numframes;



for iFrame = startframe:length(framesclicked)
    
   
    I = im2double(imread(images(framesclicked(iFrame)).name));
   % I = I-background;
    figure(1); imshow(I)
    title(['Frame', num2str(framesclicked(iFrame))]);
    [y,x] = getpts;
    close
    tip1(iFrame,:) = [x(1) y(1)];
    tip2(iFrame,:) = [x(2) y(2)];
    
    save('20150420_tips.mat', 'tip1', 'tip2');
    
end