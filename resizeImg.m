%quickly change image size online 
clear all;close all;clc;
load('RivalryExp_original'); %load the original files,
%the original image size is 270*270

imageSize   = 232; %orginal one is 5 deg, 232 is 4 deg

tmp = zeros(imageSize,imageSize,size(img,3),size(img,4));

for i = 1:size(img,3)
    for j=1:size(img,4)
        tmp(:,:,i,j)=imresize(img(:,:,i,j),[imageSize imageSize]);
    end    
end

clear img;
img = uint8(tmp);

%% Save it out
desc = ' img is the image stack \n stimorder gives the order of the stimulus for each run \n frameorder gives image number in each trial \n fixorder gives order of fixation luminance \n fixcolor gives levels of fixation luminance \n expcondorder gives order of experiment conditions every frame \n condorder gives order of experiment conditions in every trial'
save RivalryExp img desc stimorder frameorder fixorder fixcolor expcondorder condorder rg_colororder RGcolororder

% also change the test stimuli
clear all;
CreateRivalryStim_test;