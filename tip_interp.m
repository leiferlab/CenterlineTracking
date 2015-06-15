clear all;

imFolder = 'C:\Users\linder\Documents\Data\PanNeuronal Behav\20150611\Worm8\Raw Images';
images=dir([imFolder filesep '*.jpeg']);
%numframes = length(images);
numframes = 500;
load('C:\Users\linder\Documents\Data\PanNeuronal Behav\20150611\Worm8\20150420_tips.mat')

framesclicked = 1:5:numframes;

framestot = 1:numframes;

framestot(framesclicked) = [];
frames_nc = framestot;

totframes = 1:numframes;



inttips1(:,1) = interp1(framesclicked, tip1(:,1), frames_nc);
inttips1(:,2) = interp1(framesclicked, tip1(:,2), frames_nc);

inttips2(:,1) = interp1(framesclicked, tip2(:,1), frames_nc);
inttips2(:,2) = interp1(framesclicked, tip2(:,2), frames_nc);


alltips1 = zeros(numframes,2);
alltips2 = zeros(numframes,2);

alltips1(framesclicked,:) = tip1;
alltips1(frames_nc,:) = inttips1;

alltips2(framesclicked,:) = tip2;
alltips2(frames_nc,:) = inttips2;
% 
% for i =4500: 5739
%    I = im2double(imread(images(i).name));
%    % I = I-background;
%     figure(1); imshow(I);
%     hold on;
%     plot(alltips1(i,2),alltips1(i,1), 'og', 'MarkerFaceColor', 'g');
%     plot(alltips2(i,2),alltips2(i,1), 'or', 'MarkerFaceColor', 'r');
%     hold off;
%      M(i-4499) = getframe;
%     
% end
