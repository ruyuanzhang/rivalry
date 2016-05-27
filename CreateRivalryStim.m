% Create stimulus for binocular rivalry experiment
clear all;close all;clc


%% 

% add functions repository
addpath(genpath(pwd));
% set image parameters
conditions      =[9 6]; % [a b] where
                            %a conditions need double trials 
                            %b conditions need singal trials 
                            %total a+b conditions                            
nTrial          =[6 3]; % [a b] where
                            %a trials for double trial conditions in a run
                            %b trials for singal trial conditiosn in a run
                            %total a+b conditions
trialNum        = conditions*nTrial'; % OK. We need these many stimulus trials in a run
imageSize       = 110; %  pixels
bgColor         = 127;
contrastRatio   = 0.5; 
%contrast ratio for face stimuli for adjusting the relative contrast strengh of face and house.
%contrastRatio for house is 1-contrastRatio



%% let's read in face, house stimuli.
load('faces.mat');
faces=images(:,:,1:trialNum);
load('houses.mat');
houses=images(:,:,1:trialNum);
faceimg=[];
houseimg=[];
faceRMS = [];
houseRMS = [];
% do some processing on face and house images
for i=1:trialNum
    %let's resize face and house images and adjust their contrast to 50%
    tmp=faces(:,:,i);
    tmp=imresize(tmp,[imageSize imageSize]);
    tmp=(tmp-min(tmp(:)))/(max(tmp(:))-min(tmp(:)));%set to 0-1
    tmp=(tmp-0.5)*contrastRatio+0.5;
    tmp=uint8(round(bgColor*2*tmp));%set to 50% contrast and scale it to 0~254;
    faceimg(:,:,i)=tmp;
    rms_tmp = sqrt(sum((tmp(:)-bgColor).^2));
    faceRMS = horzcat(faceRMS,rms_tmp);%compute the rms contrast;
  
    tmp=houses(:,:,i);
    tmp=imresize(tmp,[imageSize imageSize]);
    tmp=(tmp-min(tmp(:)))/(max(tmp(:))-min(tmp(:)));%set to 0-1
    tmp=(tmp-0.5)*(1-contrastRatio)+0.5;
    tmp=uint8(round(bgColor*2*tmp));%set to 50% contrast and scale it to 0~254;
    houseimg(:,:,i)=tmp;  
    rms_tmp = sqrt(sum((tmp(:)-bgColor).^2));
    houseRMS = horzcat(houseRMS,rms_tmp);%compute the rms contrast;
end
% Create four different stimuli, face, house, word, face+house
faceHouseimg = (faceimg-bgColor)+(houseimg-bgColor)+bgColor;
%We might also need blank images with gray background
blankimg    = bgColor*2*0.5*ones(imageSize,imageSize,trialNum);
clear tmp images faces houses;% clear some redundency 
RMS = mean(horzcat(faceRMS,houseRMS));

%% load the images and do some simple computation
%dealing with word stim. word is a little bit trikcy, do some process here.
words=textread('3_letter_words.txt','%s');
words=words';
wordimg=[];
for i = 1:trialNum
    tmp = uint8(renderText(words{i},'Courier',24,6));
    tmp=imresize(tmp,imageSize/max(size(tmp))); %resize the images
    % Set contrast
    tmp(tmp==1)=round(sqrt(RMS.^2/sum(tmp(:)>0))+bgColor); %we matched the RMS contrast to face and house img
    tmp(tmp==0)=bgColor;
    % stack it up
    wordimg(:,:,i) = tmp; % all images
end
% Ugly...Word image is not a square, we want to center the rect
wordRect = CenterRect([0 0 size(wordimg,1) size(wordimg,2)], [0 0 imageSize imageSize]);
tmp    = bgColor*ones(imageSize,imageSize,trialNum);
tmp(wordRect(1):wordRect(3)-1,:,:) = wordimg;
wordimg = tmp;clear tmp;
save('afterWord');

%Now we create a big matrix to include these five categories
img = zeros(imageSize,imageSize,trialNum,5);
img (:,:,:,1) = blankimg;
img (:,:,:,2) = faceimg;
img (:,:,:,3) = houseimg;
img (:,:,:,4) = wordimg;%we already set pixel values before
img (:,:,:,5) = faceHouseimg;
img = uint8(img);

%save('RivalryExp'); % Save the data;

%% --------- create presentation sequence
% to quickly change some parameters for piloting purpose, I redundantly
% repeat some variable.

%add functions repository
addpath(genpath(pwd));
%Decide on the frame order
% some parameters
nruns           = 14; %how many runs you want                             
onoff           = [2 2]; % 1s-ON/3s-OFF design
timeUnit        = 0.2;% duration of each time unit
onoffFrameNum   = int8(onoff/timeUnit);
conditions      =[9 6]; % [a b] where
                            %a conditions need double trials 
                            %b conditions need singal trials 
                            %total a+b conditions  
nTrial          =[6 3]; % [a b] where
                            %a trials for double trial conditions in a run
                            %b trials for singal trial conditiosn in a run
                            %total a+b conditions
blankTrialNum   = [5 4]; %[A B] where 
                            % A:blank trials in the run
                            % B:blank trials at the beginning and the end                        
                           
%generate stimulus order, we need to go back this section to do some work
%
for rn = 1:nruns
    tmp1 = rem(1:nTrial(1)*conditions(1),conditions(1))+1; 
    tmp2 = rem(1:nTrial(2)*conditions(2),conditions(2))+1+conditions(1);
    tmp  = horzcat(tmp1,tmp2); %trials from 
    % Add in blanks and Shuffle stim order to randomize conditions for the run
    %stimorder(rn,:) = Shuffle(horzcat(tmp, zeros(1,nblank)));
    % here, we need two constraints
    % 1. blanks cannnot be consecutive
    % 2. blank should not be at very beginning and very end
    % use insertBlankTrial function to deal with it
    stimorder(rn,:) = insertBlankTrial(horzcat(tmp, zeros(1,blankTrialNum(1))));
end
frameorder = makeFrameOrder(stimorder,onoffFrameNum(1),onoffFrameNum(2));

% 02/23/2016, by RZ
% we add 4 trials blank at the very begining and the very end for both frame
% and fixation order
% for stim frame
blankframe = zeros(nruns,round(sum(onoff)/timeUnit*blankTrialNum(2))); % 20 frames/trial, we want to 4 trials blank
frameorder = horzcat(blankframe,frameorder,blankframe);

%% Create fixation task
clear fixorder fixcolor;
for rn = 1 : nruns
    [fixorder(rn,:), fixcolor] = CreateFixationTask_Luminance(size(frameorder,2));
end

%% Save it out
desc = ' img is the image stack \n sc denotes the contrast of each image\n sl denotes the lexicality level\n stimcat denotes the category\n stimorder gives the order of the stimulus for each run\n'
save RivalryExp img desc stimorder frameorder fixorder fixcolor

% also change the test stimuli
clear all;
CreateRivalryStim_test;

return


