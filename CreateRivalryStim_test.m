% Create test stimulus for binocular rivalry experiment,basically we
% present the stimulus for 8 sec so you can clearly see the binocular
% difference
clear all;%close all;clc

%% add functions repository
addpath(genpath(pwd));

load('RivalryExp.mat');
clear frameorder fixorder fixcolor;

%only change the stimulus presentation for testing purpose
onoff           = [8 0]; % 1s-ON/1s-OFF design
timeUnit        = 0.2;%duration for one time unit
onoffFrameNum   = onoff/timeUnit;
nruns           = 14;
blankTrialNum   = [5 4]; %[A B] where 
                            % A:blank trials in the run
                            % B:blank trials at the beginning and the end  

frameorder = makeFrameOrder(stimorder,onoffFrameNum(1),onoffFrameNum(2));
expcondorder = makeFrameOrder(condorder,onoffFrameNum(1),onoffFrameNum(2));


% 02/23/2016, by RZ
% we add 4 trials blank at the very begining and the very end for both frame
% and fixation order
% for stim frame
blankframe = zeros(nruns,20*blankTrialNum(2)); % 20 frames/trial, we want to 4 trials blank
frameorder = horzcat(blankframe,frameorder,blankframe);
expcondorder = horzcat(blankframe,expcondorder,blankframe);


%% Create fixation task
for rn = 1 : nruns
    [fixorder(rn,:), fixcolor] = CreateFixationTask_LDT(size(frameorder,2));
end

%% Save it out
desc = ' img is the image stack \n stimorder gives the order of the stimulus for each run \n frameorder gives image number in each trial \n fixorder gives order of fixation luminance \n fixcolor gives levels of fixation luminance \n expcondorder gives order of experiment conditions every frame \n condorder gives order of experiment conditions in every trial'
save RivalryExptest img desc stimorder frameorder fixorder fixcolor expcondorder condorder


return


