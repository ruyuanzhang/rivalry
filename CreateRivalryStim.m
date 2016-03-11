% Create stimulus for binocular rivalry experiment


clear all;close all;clc

%% add functions repository
addpath(genpath('functions'));


%% set parameters
trialNum        = 55; % valid trial number withouth blank trials
blankTrialNum   = [5 4]; %[A B] where 
                            % A:blank trials in the run
                            % B:blank trials at the beginning and the end
runNum          = 12; % how many runs in total
onoff           = [1 3]; % 1s-ON/3s-OFF design

refreshRate     = 60; %how many flips for a second on this monitor
timeUnit        = 0.2;% duration of each time unit

onoffFrameNum   = onoff/timeUnit;


imageSize       = 829*570; % 300 * 300 pixels


% load the images
%let's first try two images presenation
p1 = imread('mooney-mf/mooney1m.bmp');
p2 = imread('mooney-mf/mooney1f.bmp');

%
img = [];
img(:,:,1,1) = p1;
img(:,:,2,1) = p2;
img(:,:,1,2) = p2;
img(:,:,2,2) = p1;

img=uint8(img);


%% remake the images with some random background dots 






%% Decide on the frame order
nruns               = 12;%how many runs you want 

%generate stimulus order, we need to go back this section to do some work
%
for rn = 1:nruns
    
    tmp = rem(1:trialNum,2)+1; % let's first to present single image
   
    
    % Add in blanks and Shuffle stim order to randomize conditions for the run
    %stimorder(rn,:) = Shuffle(horzcat(tmp, zeros(1,nblank)));
    % here, we need two constraints
    % 1. blanks cannnot be consecutive
    % 2. blank should not be at very beginning and very end
    % use insertBlankTrial function to deal with it
    stimorder(rn,:) = insertBlankTrial(horzcat(tmp, zeros(1,blankTrialNum(1))));
end


frameorder = makeFrameOrder(stimorder,onoffFrameNum(1),onoffFrameNum(2));

% The variable stimorder tell us the image index (into img) that will be
% shown on each trail. stimorder_cat will be a matrix with teh same
% dimensions saying the category of each of these images. This will be what
% we use to set up our glm. We do this as a loop because we have stim
% category 0
% for ii = 1:size(stimorder,1) 
%     for jj = 1:size(stimorder,2)
%         if stimorder(ii,jj) == 0
%             stimorder_cat(ii,jj) = 0;
%         else
%             stimorder_cat(ii,jj) = stimcat(stimorder(ii,jj));
%         end
%     end
% end

% 02/23/2016, by RZ
% we add 4 trials blank at the very begining and the very end for both frame
% and fixation order
% for stim frame
blankframe = zeros(nruns,20*blankTrialNum(2)); % 20 frames/trial, we want to 4 trials blank
frameorder = horzcat(blankframe,frameorder,blankframe);

%% Create fixation task
for rn = 1 : nruns
    [fixorder(rn,:), fixcolor] = CreateFixationTask_Luminance(size(frameorder,2));
end

%% Save it out
desc = ' img is the image stack \n sc denotes the contrast of each image\n sl denotes the lexicality level\n stimcat denotes the category\n stimorder gives the order of the stimulus for each run\n'
save RivalryExp img desc stimorder frameorder fixorder fixcolor

return


