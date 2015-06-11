function [good_tips] = goodTips(P, tips)

tips = fliplr(tips);

tipDist = pdist2(tips, [P(1,:); P(end, :)]);
[num1, tipIdx1] = min(tipDist(:,1));
[num2, tipIdx2] = min(tipDist(:,2));
tip1 = tips(tipIdx1(1),:);
tip2 = tips(tipIdx2(1), :);

good_tips = [tip1; tip2];

