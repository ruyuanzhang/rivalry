%% analyze data immediately
% This script is to analyze behavioral results of a subject.
clear all;close all;clc



taskrun=[2 3 4];
filenames=matchfiles('*YX_run*');


%% ===============Experiment description================================
% 1. During rivalry experiment, a participant completes 12 experiment runs.
% The number 1,3,4,6,7,9,10,12 are task runs. Run 2,5,8,11 are fixation
% runs, we don't need to analyze fixation run data.
% 2. In a task run, there are 76 stimulus trials. We have total 16 stimuli 
%   conditions. 
% 3. There are four choices for each conditions.Participants should respond
% to stimuli by pressing one of four buttons, 'b','y','g','r'.
% 4. So basically we should generate a 16*4 result matrix and a 8*76 keybutton
% press matrix for all trials

% All order of stimulus conditios was in 'condorder' variable after you
% read in 'RivalryExp.mat'. condorder is a 14*81 matrix,


%% ==================first, let's analyze the results=======================

load('RivalryExp.mat'); %load the experimental design file
addpath(genpath(pwd)); % add this whole folder to matlab path

buttons         ={'b','y','g','r'}; % Here are the four button mark
result          =zeros(16,4);%four columns:1,face;2,house;3,car;4,mixture
keysPress       =zeros(8,81);


for run=taskrun% we loop across 8 task runs
    
%All order of stimulus conditios was in 'condorder' variable after you
%read in 'RivalryExp.mat'. condorder is a 14*81 matrix. Row refers for
%different runs. Here, we only consider row 1,3,4,6,7,9,10,12. Column are
%all trials in a run. There are 76 stimulus trial and 5 blank trials.We
%only need to analyze 76 stimulus trials. You will see number 1 to 16,
%which stands for stimulus condition number in this trial

    
    cond = condorder(run,:);
    
    load(filenames{run});% load behavioral data of this run
    
%The two key variables are 'timeframes' and 'timekeys'.
%'timeframes' records the onset time of all stimulus frames. There is 16s
%blank at beginning, then every trial lasts 4s (1s stimulus + 3s blank) and
%16s blank at end. So a run lasts 16+81*4+16=356s. We set 0.2s per frame.
%So total are 356*5=1780 frames.
    
    
% found the frame number of trial onset.
    onset = 81:20:1780-80+1; %82 items, onset time for the first frame of all trials and first frame of 16s blank in the end
    onset = timeframes(onset);
    
% sometimes participants might press multiple button at the same time. so
% we first expand multiple key inpress.
    timekeysB = {};
    for p=1:size(timekeys,1)
        if iscell(timekeys{p,2})
            for pp=1:length(timekeys{p,2})
                timekeysB{end+1,1} = timekeys{p,1};
                timekeysB{end,2} = timekeys{p,2}{pp};
            end
        else
            timekeysB(end+1,:) = timekeys(p,:);
        end
    end
    times = cell2mat(timekeysB(:,1));% convert all times to a matrix
    
    
    % loop each trial
    for trial = 1: numel(onset)-1 %how many trial,the onset(end) is the first frame of blank in the end
        if cond(trial) ~=0 % we discard blank trials
            
            % get the key press index
            ind=find((times>=onset(trial))&(times<onset(trial+1))); 
            
            keys = cell2mat(timekeysB(ind,2)); %key press in this trial
            keys=keys(keys~='t'); %remove trigger key 't'
            
            if numel(unique(keys))==1
                key=unique(keys); %only one button is pressed
            else % more than 1 buton are pressed
                count=[];
                uniqkeys=unique(keys);
                for k=1:numel(uniqkeys)
                    count(k)=sum(keys==uniqkeys(k));
                end
                [~, I]=max(count);
                key = uniqkeys(I);
            end
            
            
            %first get the condition at this key press
            if ~isempty(key)
                switch key
                    case buttons(1)
                        result(cond(trial),1)=result(cond(trial),1)+1;
                        keysPress(run,trial)=1;
                    case buttons(2)
                        result(cond(trial),2)=result(cond(trial),2)+1;
                        keysPress(run,trial)=2;
                    case buttons(3)
                        result(cond(trial),3)=result(cond(trial),3)+1;
                        keysPress(run,trial)=3;
                    case buttons(4)
                        result(cond(trial),4)=result(cond(trial),4)+1;
                        keysPress(run,trial)=4;
                end
            end
        end
    end
end


% Compute the errobar using binominal distribution. Don't need to touch
% this part
totalTrial_riv=numel(taskrun)*7;
totalTrial_sig=numel(taskrun)*3;
subjnum       =1; %how many subject you average

result_error=zeros(16,4);
result_error(1:7,:)=sqrt(totalTrial_riv*result(1:7,:)/totalTrial_riv.*(1-result(1:7,:)/totalTrial_riv)/subjnum); %sqrt(kpq/n)
result_error(8:16,:)=sqrt(totalTrial_sig*result(8:16,:)/totalTrial_sig.*(1-result(8:16,:)/totalTrial_sig)/subjnum); %sqrt(kpq/n)

%% now we create the figures below
%% ==================Second, make a figure visualize the results===========
%% plot the result of first four conditions
close all;
H=figure;
%set(H,'Position',[435 133 1092 907]); % make a bigger figure
data = [result(1,1)  result(2,2) result(3,3) result(4,2);result(1,2)  result(2,1) result(3,2) result(4,3)];
error = [result_error(1,1)  result_error(2,2) result_error(3,3) result_error(4,2);result_error(1,2)  result_error(2,1) result_error(3,2) result_error(4,3)];

% illustrate eye balance
ax(1)=subplot(3,1,1);
mybar([],data,error);hold on;
myplot(0:4,numel(taskrun)*7*ones(numel(0:4),1),'--k'); hold on;
ylabel('# of Choices');
xlabel('Conditions');
set(gca,'XTick',1:4);
set(gca,'XTickLabel',{'F,H','H,F','C,H','H,C'});
ele=get(gca,'Child');
l=legend(ele([5,4,1]),{'LeftEye','RightEye','TotalTrial#'});

%
ax(2)=subplot(3,1,2);
mybar([],result(1:7,:)',result_error(1:7,:)');hold on;
myplot(0:7,numel(taskrun)*7*ones(numel(0:7),1),'--k'); hold on;
%myplot(8:12,27*ones(numel(8:12),1),'--k'); hold on;
ylabel('# of Choices');
xlabel('Conditions');
ele=get(gca,'Child');
set(gca,'XTick',1:7);
set(gca,'XTickLabel',{'F,H','H,F','C,H','H,C','F+H,blank','blank,F+H','F+H,F+H'});
l=legend(ele([9:-1:6,1]),{'Face','House','Car','Mixture','TotalTrial#'});


%%
ax(3)=subplot(3,1,3);
mybar([],result(8:end,:)',result_error(8:end,:)');hold on;
myplot(0:9,numel(taskrun)*3*ones(numel(0:9),1),'--k'); hold on;
ylabel('# of Choices');
xlabel('Conditions');
ele=get(gca,'Child');
set(gca,'XTick',1:9);
set(gca,'XTickLabel',{
    'F,blank','blank,F','F,F',...
    'H,blank','blank,H','H,H',...
    'Car,blank','blank,Car','Car,Car'});
l=legend(ele([9:-1:6,1]),{'Face','House','Car','Mixture','TotalTrial#'});


%% adjust figure
%figrmwhitespace(ax,3,1);

