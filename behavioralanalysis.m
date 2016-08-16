% analyze behaviral data of participant run

clear all;close all;clc
load('RivalryExp'); %load the design matrix

runnum          =  2;
buttons         ={'1','2','3','4'};
result          =zeros(16,4);%four columns:1,face;2,house;3,word;4,mixture
condorder = condorder(runnum,:);
load(['run' num2str(runnum) '.mat'])
for i = 1: numel(keybuttons) %how many trial
    %first get the condition at this key press
    TrialNum = floor(floor(keytimes(i))/4) - 4; %substract the first 4 blank trials
    if condorder(TrialNum) ~=0
        switch keybuttons{i}
            case buttons(1)
                result(condorder(TrialNum),1)=result(condorder(TrialNum),1)+1;
            case buttons(2)
                result(condorder(TrialNum),2)=result(condorder(TrialNum),2)+1;
            case buttons(3)
                result(condorder(TrialNum),3)=result(condorder(TrialNum),3)+1;
            case buttons(4)
                result(condorder(TrialNum),4)=result(condorder(TrialNum),4)+1;
        end
    end
end

%Show result
fprintf('\n');
fprintf('for F, H condition, participant chose left eye F in %i out of 7 trials\n',result(1,1));
fprintf('for H, F condition, participant chose left eye H in %i out of 7 trials\n',result(2,2));
fprintf('for O, H condition, participant chose left eye O in %i out of 7 trials\n',result(3,3));
fprintf('for H, O condition, participant chose left eye H in %i out of 7 trials\n',result(4,2));