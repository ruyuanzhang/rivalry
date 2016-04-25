function [leftEyeImg,rightEyeImg]  = ExpCondMatrix(condition)


%let's mark, 1,blank;2,face;3,house;4,word;5,face+house
%the matrix for three condition can be presented as
% conditionMatrix=[
%      2     3; % F,H
%      3     2; % H,F
%      4     3; % W,H
%      3     4; % H,W
%      2     4; % F,W
%      4     2; % W,F
%      5     5; % F+H,F+H
%      5     1; % F+H, no stim
%      1     5; % no stim, F+H
%      2     1; % F, no stim
%      1     2; % no stim, F
%      2     2; % no stim, H
%      3     1; % H, no stim
%      1     3; % no stim, H
%      3     3; % H,H
%      ];
%  
%  
 %for testing purpose, you can set all condition as F,H, then you can test
 %your binocular presentation.
 
 conditionMatrix=repmat([2 3],15,1);

 
 
 
 
 
 
 
condNum = conditionMatrix(condition,:);
leftEyeImg = condNum(1);
rightEyeImg =condNum(2); 
 
 
 
 