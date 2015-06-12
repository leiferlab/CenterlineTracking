clear all
imFolder = 'C:\Users\linder\Documents\Data\PanNeuronal Behav\20150420';
images=dir([imFolder filesep '*.jpeg']);

I1 = im2double(imread(images(1).name));
load('C:\Users\linder\Documents\Data\PanNeuronal Behav\20150420\background20150420.mat')

load('C:\Users\linder\Documents\Data\PanNeuronal Behav\20150420\20150420_alltips.mat');

frames = 1:length(alltips1(:,1));
figure(1), imshow(I1)
[y,x] = getpts;
close
I = I1;
I1 = I1 - background;
I1 = I1(:,:,1);
P = [x(:) y(:)];
%%
O(:,1)=interp([P(:,1)],10);
O(:,2)=interp([P(:,2)],10);
nPoints = 102;

dis=[0;cumsum(sqrt(sum((O(2:end,:)-O(1:end-1,:)).^2,2)))];

K(:,1) = interp1(dis,O(:,1),linspace(0,dis(end),nPoints));
K(:,2) = interp1(dis,O(:,2),linspace(0,dis(end),nPoints));
P = K;




CL = SnakeWithTips(alltips1(1,:), alltips2(1,:), P, I1);
centerline(:,:,1) = CL;

imshow(I);
    hold on;
    plot(centerline(:,2,1), centerline(:,1, 1), '-g')
    plot(centerline(1,2,1), centerline(1,1,1), 'og')
    plot(centerline(100,2,1), centerline(100,1,1), 'og')
    hold off;
    saveas(gcf, num2str(1), 'jpeg');
    save('20150420_CL.mat', 'centerline');
    %M(1) = getframe;


%%
for iFrame = 2:length(alltips1(:,1)-2)
    Il = im2double(imread(images(iFrame).name));
    Imb = Il - background;
    I = Imb(:,:,1);
    
    
    centerline(:,:,iFrame) = SnakeWithTips(alltips1(iFrame,:), alltips2(iFrame,:), CL, I);
    CL = centerline(:,:,iFrame);
    
    imshow(Il);
    title(['Frame', num2str(iFrame)]);
    hold on;
    plot(centerline(:,2,iFrame), centerline(:,1, iFrame), '-g')
    plot(centerline(1,2,iFrame), centerline(1,1,iFrame), 'og')
    plot(centerline(100,2,iFrame), centerline(100,1,iFrame), 'og')
    hold off;
    saveas(gcf, num2str(iFrame), 'jpeg');
    save('20150420_CL.mat', 'centerline');
   % M(iFrame) = getframe;
end
  % movie2avi(M, 'GFPwormfin.avi');
