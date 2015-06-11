function [centerline] = initialSnake(imFolder, iImage, background)

    I = iImage;
    figure(100), imshow(I)
    [y,x] = getpts;
    close
    P = [x(:) y(:)];
  
    O(:,1)=interp([P(:,1)],10);
    O(:,2)=interp([P(:,2)],10);
    nPoints = 102;

    dis=[0;cumsum(sqrt(sum((O(2:end,:)-O(1:end-1,:)).^2,2)))];

    K(:,1) = interp1(dis,O(:,1),linspace(0,dis(end),nPoints));
    K(:,2) = interp1(dis,O(:,2),linspace(0,dis(end),nPoints));
    P = K;

    I1 = I(:,:,1) - background(:,:,1); 
    CL = SnakeWithTips([P(1,1) P(1,2)],[P(end,1) P(end,2)], P, I1);
    centerline = CL;

end

