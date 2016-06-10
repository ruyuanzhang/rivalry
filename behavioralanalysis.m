% analyze behaviral data of participant run

clear all;close all;clc
load('RivalryExp'); %load the design matrix

runnum          =  4;
buttons         ={'1','2','3','4'};
result          =zeros(15,4);%four columns:1,face;2,house;3,word;4,mixture
for run=1:runnum 
    load(['run' num2str(run) '.mat'])
    for i = 1: numel(keybuttons)
        %first get the condition at this key press
        TrialNum = floor(floor(keytimes(i))/4) - 4; %substract the first 4 blank trials
        if condorder(TrialNum) ~=0
            switch keybuttons(i)
                case '1'
                    result(condorder(TrialNum),1)=result(condorder(TrialNum),1)+1;
                case '2'
                    result(condorder(TrialNum),2)=result(condorder(TrialNum),2)+1;
                case '3'
                    result(condorder(TrialNum),3)=result(condorder(TrialNum),3)+1;
                case '4'
                    result(condorder(TrialNum),4)=result(condorder(TrialNum),4)+1;
            end
        end
    end
end