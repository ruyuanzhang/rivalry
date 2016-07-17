% Create stimulus for binocular rivalry experiment from fLoc stimuli
clear all;close all;clc;
    

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
effectiveSize   = 290;
imageSize       = round(sqrt(2)*effectiveSize); %  pixels
bgColor         = 127;
contrastRatio   = 0.5; 
%contrast ratio for face stimuli for adjusting the relative contrast strengh of face and house.
%contrastRatio for house is 1-contrastRatio


%let's read in face, house stimuli.
load('fLocStim.mat');
faceHouseimg = zeros(imageSize,imageSize,24);


%% do some processing on face and house images
for i=1:24
   
    
    %let's resize face and house images and adjust their contrast to 50%
    tmp1=double(face(:,:,i));
    tmp1=imresize(tmp1,[imageSize imageSize]);
    tmp1=varycontrast(tmp1/254,50); %change to 50% contrast;
    tmp1=round(tmp1*254);
    %tmp1=double(imhistmatch(uint8(tmp1),uint8(tmp2)));
    faceimg(:,:,i)=tmp1; 
    
    tmp2=double(house(:,:,i));
    tmp2=imresize(tmp2,[imageSize imageSize]);
    tmp2=varycontrast(double(tmp2)/254,50); %change to 50% contrast;
    tmp2=round(tmp2*254);
    %tmp2=double(imhistmatch(uint8(tmp1),uint8(tmp2)));
    houseimg(:,:,i)=tmp2;
    
    faceHouseimg(:,:,i)=tmp1+tmp2-127;
    
  
end



viewimages(faceimg);colormap(gray);
viewimages(houseimg);colormap(gray);
viewimages(faceHouseimg);colormap(gray);


faceimg=repmat(faceimg,1,1,3);
houseimg=repmat(houseimg,1,1,3);
faceHouseimg=repmat(faceHouseimg,1,1,3);
%We also need blank images with gray background
blankimg    = bgColor*2*0.5*ones(imageSize,imageSize,trialNum);
clear tmp images faces houses;% clear some redundency 

%% Now we need to make some word image,we are trying to match 
%dealing with word stim. word is a little bit trikcy, do some process here.
%We need first compute averaged rms contrast.
RMS= (sqrt(sum((faceimg(:)-bgColor).^2))+sqrt(sum((houseimg(:)-bgColor).^2)))/(2*size(faceimg,3));
words=textread('3_letter_words.txt','%s');
words=words';
wordimg=[];
for i = 1:trialNum
    tmp = uint8(renderText(words{i},'Courier',24,6));
    tmp=imresize(tmp,imageSize/max(size(tmp))); %resize the images
    % Set luminance
    tmp(tmp==1)=round(sqrt(RMS.^2/sum(tmp(:)>0))+bgColor); %we matched the RMS contrast to face and house img
    tmp(tmp==0)=bgColor;
    
    %resize again to make it imageSize*imageSize
    wordRect = CenterRect([0 0 size(tmp,1) size(tmp,2)], [0 0 imageSize imageSize]);
    tmp2 = bgColor*ones(imageSize,imageSize);
    tmp2(wordRect(1):wordRect(3)-1,:,:) = tmp;
    
    %generate pinknoise background
    pinkBg = generatepinknoise(imageSize); %create pinknoise background
    pinkBg = (imnormconst(pinkBg)/254-0.5)*0.5+0.5;%scale it to 0.25~0.75,50% contrast;
    
    pinkBg = pinkBg*127;
    pinkBg(tmp2>bgColor)=max(tmp2(:));
    % stack it up
    wordimg(:,:,i) = pinkBg; % all images
end
viewimages(wordimg);colormap(gray);



%% Now we create a big matrix to include these five categories
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
onoff           = [1 3]; % 1s-ON/3s-OFF design

nruns           = 14; %how many runs you want                             
timeUnit        = 0.2;% duration of each time unit
onoffFrameNum   = int8(onoff/timeUnit);
conditions      = [9 6]; % [a b] where
                            %a conditions need double trials 
                            %b conditions need singal trials 
                            %total a+b conditions  
nTrial          = [6 3]; % [a b] where
                            %a trials for double trial conditions in a run
                            %b trials for singal trial conditiosn in a run
                            %total a+b conditions
blankTrialNum   = [5 4]; %[A B] where 
                            % A:blank trials in the run
                            % B:blank trials at the beginning and the end                        
                           
%generate stimulus order, we need to go back this section to do some work

for rn = 1:nruns
    tmp1 = rem(1:nTrial(1)*conditions(1),conditions(1))+1; 
    tmp2 = rem(1:nTrial(2)*conditions(2),conditions(2))+1+conditions(1);
    tmp_cond = horzcat(tmp1,tmp2);
    tmp_stim  = 1:(nTrial*conditions');
    tmp_color = rem(tmp_stim,2)+1;
    % Add in blanks and Shuffle stim order to randomize conditions for the run
    %stimorder(rn,:) = Shuffle(horzcat(tmp, zeros(1,nblank)));
    % here, we need two constraints
    % 1. blanks cannnot be consecutive
    % 2. blank should not be at very beginning and very end
    % use insertBlankTrial function to deal with it
    
    [tmp_cond, index]=Shuffle(tmp_cond);
    tmp_color=tmp_color(index);
    stimorder(rn,:) = insertBlankTrial(horzcat(tmp_stim, zeros(1,blankTrialNum(1))));
    condorder(rn,:) = insertel(tmp_cond,zeros(1,blankTrialNum(1)),find(stimorder(rn,:)==0));
    rg_colororder(rn,:) = insertel(tmp_color,zeros(1,blankTrialNum(1)),find(stimorder(rn,:)==0));
end
frameorder = makeFrameOrder(stimorder,onoffFrameNum(1),onoffFrameNum(2));
expcondorder = makeFrameOrder(condorder,onoffFrameNum(1),onoffFrameNum(2));
RGcolororder = makeFrameOrder(rg_colororder,onoffFrameNum(1),onoffFrameNum(2));

% 02/23/2016, by RZ
% we add 4 trials blank at the very begining and the very end for both frame
% and fixation order
% for stim frame
blankframe = zeros(nruns,round(sum(onoff)/timeUnit*blankTrialNum(2))); % 20 frames/trial, we want to 4 trials blank
frameorder = horzcat(blankframe,frameorder,blankframe);
expcondorder = horzcat(blankframe,expcondorder,blankframe);
RGcolororder = horzcat(blankframe,RGcolororder,blankframe);

%% Create fixation task
clear fixorder fixcolor;
for rn = 1 : nruns
    [fixorder(rn,:), fixcolor] = CreateFixationTask_LDT(size(frameorder,2));
end

%% Save it out
desc = ' img is the image stack \n stimorder gives the order of the stimulus for each run \n frameorder gives image number in each trial \n fixorder gives order of fixation luminance \n fixcolor gives levels of fixation luminance \n expcondorder gives order of experiment conditions every frame \n condorder gives order of experiment conditions in every trial'
save RivalryExp_original img desc stimorder frameorder fixorder fixcolor expcondorder condorder rg_colororder RGcolororder

% also change the test stimuli
clear all;
CreateRivalryStim_test;

return