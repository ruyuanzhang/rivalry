% Create stimulus for binocular rivalry experiment from fLoc stimuli
clear all;close all;clc;
load('RivalryExp.mat');    

%% 

% add functions repository
addpath(genpath(pwd));
% set image parameters
conditions      =[7 9]; % [a b] where
                            %a conditions need double trials 
                            %b conditions need singal trials 
                            %total a+b conditions                            
nTrial          =[7 3]; % [a b] where
                            %a trials for double trial conditions in a run
                            %b trials for singal trial conditiosn in a run
                            %total a+b conditions
trialNum        = conditions*nTrial'; % OK. We need these many stimulus trials in a run
effectiveSize   = 184;
imageSize       = round(sqrt(2)*effectiveSize); %  pixels
%imageSize       = 720;
bgColor         = 127;
contrastRatio   = 0.5; 
%contrast ratio for face stimuli for adjusting the relative contrast strengh of face and house.
%contrastRatio for house is 1-contrastRatio


%let's read in face, house stimuli.
load('fLocStim.mat');
%faceHouseimg = zeros(imageSize,imageSize,size(face,3));


%%

faceimg=img(:,:,1:19,2);
houseimg=img(:,:,1:19,3);
carimg=img(:,:,1:19,4);
clear img;

viewimages(faceimg);colormap(gray);caxis([0 254]);
viewimages(houseimg);colormap(gray);caxis([0 254]);
viewimages(carimg);colormap(gray);caxis([0 254]);

%create 76 pics
faceimg=repmat(faceimg,[1,1,4]);
houseimg=repmat(houseimg,[1 1 4]);
%faceHouseimg=repmat(faceHouseimg,[1 1 4]);
carimg=repmat(carimg,[1 1 4]);
%We also need blank images with gray background
blankimg    = bgColor*2*0.5*ones(imageSize,imageSize,trialNum);
clear tmp images faces houses;% clear some redundency 


% Now we create a big matrix to include these five categories
img = zeros(imageSize,imageSize,trialNum,5);
img (:,:,:,1) = blankimg;
img (:,:,:,2) = faceimg;
img (:,:,:,3) = houseimg;
img (:,:,:,4) = carimg;%we already set pixel values before
img (:,:,:,5) = blankimg;
img = uint8(img);

%save('RivalryExp'); % Save the data;

% %% --------- create presentation sequence
% % to quickly change some parameters for piloting purpose, I redundantly
% % repeat some variable.
% 
% %add functions repository
% addpath(genpath(pwd));
% %Decide on the frame order
% % some parameters
% onoff           = [1 3]; % 1s-ON/3s-OFF design
% 
% nruns           = 14; %how many runs you want                             
% timeUnit        = 0.2;% duration of each time unit
% onoffFrameNum   = int8(onoff/timeUnit);
% conditions      = [7 9]; % [a b] where
%                             %a conditions need double trials 
%                             %b conditions need singal trials 
%                             %total a+b conditions  
% nTrial          = [7 3]; % [a b] where
%                             %a trials for double trial conditions in a run
%                             %b trials for singal trial conditiosn in a run
%                             %total a+b conditions
% blankTrialNum   = [5 4]; %[A B] where 
%                             % A:blank trials in the run
%                             % B:blank trials at the beginning and the end                        
%                            
% %generate stimulus order, we need to go back this section to do some work
% 
% for rn = 1:nruns
%     tmp1 = rem(1:nTrial(1)*conditions(1),conditions(1))+1; 
%     tmp2 = rem(1:nTrial(2)*conditions(2),conditions(2))+1+conditions(1);
%     tmp_cond = horzcat(tmp1,tmp2);
%     tmp_stim  = 1:(nTrial*conditions');
% 
%     % Add in blanks and Shuffle stim order to randomize conditions for the run
%     %stimorder(rn,:) = Shuffle(horzcat(tmp, zeros(1,nblank)));
%     % here, we need two constraints
%     % 1. blanks cannnot be consecutive
%     % 2. blank should not be at very beginning and very end
%     % use insertBlankTrial function to deal with it
%     
%     [tmp_cond, index]=Shuffle(tmp_cond);
%     stimorder(rn,:) = Shuffle(insertBlankTrial(tmp_stim, blankTrialNum(1)));
%     condorder(rn,:) = insertel(tmp_cond,zeros(1,blankTrialNum(1)),find(stimorder(rn,:)==0));
% end
% frameorder = makeFrameOrder(stimorder,onoffFrameNum(1),onoffFrameNum(2));
% expcondorder = makeFrameOrder(condorder,onoffFrameNum(1),onoffFrameNum(2));
% 
% 
% % 02/23/2016, by RZ
% % we add 4 trials blank at the very begining and the very end for both frame
% % and fixation order
% % for stim frame
% blankframe = zeros(nruns,round(sum(onoff)/timeUnit*blankTrialNum(2))); % 20 frames/trial, we want to 4 trials blank
% frameorder = horzcat(blankframe,frameorder,blankframe);
% expcondorder = horzcat(blankframe,expcondorder,blankframe);
% 
% 
% %% Create fixation task
% clear fixorder fixcolor;
% for rn = 1 : nruns
%     [fixorder(rn,:), fixcolor] = CreateFixationTask_LDT(size(frameorder,2));
% end

%% Save it out
desc = ' img is the image stack \n stimorder gives the order of the stimulus for each run \n frameorder gives image number in each trial \n fixorder gives order of fixation luminance \n fixcolor gives levels of fixation luminance \n expcondorder gives order of experiment conditions every frame \n condorder gives order of experiment conditions in every trial';
save RivalryExp img desc stimorder frameorder fixorder fixcolor expcondorder condorder

% also change the test stimuli
clear all;
CreateRivalryStim_test;

return
