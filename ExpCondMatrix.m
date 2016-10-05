function [leftEyeImg,rightEyeImg]  = ExpCondMatrix(condition)


%let's mark, 1,blank;2,face;3,house;4,word;5,face+house
%the matrix for three condition can be presented as
conditionMatrix=[
     2     3; % F,H
     3     2; % H,F
     4     3; % C,H
     3     4; % H,C



     2     3; % F+H, no stim
     3     2; % no stim, F+H
     2     3; % F+H,F+H



     2     1; % F, no stim
     1     2; % no stim, F
     2     2; % F, F
     3     1; % H, no stim
     1     3; % no stim, H
     3     3; % H,H
     4     1; % O, no stim
     1     4; % no stim,O
     4     4; % O, O
     ];
 
 


%for testing purpose, you can set all condition as F,H, then you can test
%your binocular presentation.
 

%conditionMatrix=repmat([2 3;2 3],8,1);


condNum = conditionMatrix(condition,:);
leftEyeImg = condNum(1);
rightEyeImg =condNum(2); 
 
 
 
 