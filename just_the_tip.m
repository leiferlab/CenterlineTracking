function [tips, numtips, Icirc1, tipidx, realnumtips] = just_the_tip(I1, I5, P)
   


    Icirc1 = tip_filter(I1, .13);
    Icirc5 = tip_filter(I5, .13);
    %Find coordinates of centroids of continous areas
    stats1 = regionprops(Icirc1, 'Centroid');
    stats5 = regionprops(Icirc5, 'Centroid');
    Ptip = [P(1,:); P(100,:)];
    
    
    for i = 1:numel(stats1)
        tips(i, :) = stats1(i).Centroid;
    end
    
     for i = 1:numel(stats5)
        tips5(i, :) = stats5(i).Centroid;
    end
    
    tips = fliplr(tips);
    tips5 = fliplr(tips5);
    realnumtips = numel(stats1);
    
    if numel(stats1) >= 2 && numel(stats5) ~= 1
       numtips = numel(stats1);
        D = pdist2(tips, Ptip);
       [ num, tipidx] = min(D);
        tip1 = tips(tipidx(1), :);
        tip2 = tips(tipidx(2), :);
  
    else
        numtips = 1;
        
        if numel(stats1) >= 2
            W = pdist2(Ptip, tips5);
            [ num, tipidx] = min(W);
            
        else
          W = pdist2(Ptip, tips);
           [ num, tipidx] = min(W);  
        end
        hid_tip = tricky_tip(P,I1, tipidx);
        
        
        if tipidx == 1 && numel(stats1) >= 2
            V = pdist2(tips, Ptip(1,:));
            [num, tipidx2] = min(V);
            tip1 = tips(tipidx2, :);
            
            tip2 = hid_tip;
        elseif tipidx == 2 && numel(stats1) >= 2
            V = pdist2(tips, Ptip(2,:));
            [num, tipidx2] = min(V);
            tip2 = tips(tipidx2, :);
            
            tip1 = hid_tip;
            
            
        elseif tipidx ==1 
            tip2 = hid_tip;
            
            tip1 = tips(1,:);
        elseif tipidx ==2
            tip2 = tips(1, :);
            
            tip1 = hid_tip;
        end
    end
     
   tips = [tip1; tip2];     
end  
        
        
        
        
        
        
    