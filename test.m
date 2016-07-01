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
effectiveSize   = 270;
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
    tmp1=varycontrast(double(tmp1)/254,50); %change to 50% contrast;
    faceimg(:,:,i)=tmp1*254;
    
    tmp2=double(house(:,:,i));
    tmp2=imresize(tmp2,[imageSize imageSize]);
    tmp2=varycontrast(double(tmp2)/254,50); %change to 50% contrast;
    
    houseimg(:,:,i)=imhistmatch(uint8(tmp2*254),uint8(faceimg(:,:,i)));
    
      
    
    
    faceHouseimg(:,:,i)=faceimg(:,:,i)+ houseimg(:,:,i)-bgColor;
    
  
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

%% do some sythetion

tmp1=uint8(faceimg(:,:,1));
tmp2=uint8(houseimg(:,:,1));

tmp3=imhistmatch(tmp1,tmp2);

viewimages(cat(3,tmp1,tmp2,tmp3));
colormap(gray);



