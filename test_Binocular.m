function test_Binocular

% The function to quickly check the binocular presentation on Vpixx,
% with very long stimuli duration and large stim.

%Input:
%   optional
%       runnum: number of current run?default = 1;
%       stimfile: specifile stim file, default = "rivalryExp.mat"

clear all;close all;clc;

%load the file
load('RivalryExp.mat');



% add functions untilized in the exp
addpath(genpath(pwd));

%% Set experiment parameters
stereoMode        =  1; 
%0,no stereo; 1,haploscope, two different images; 2, Vpixx two different
%images; 3,haploscope same image with disparity;4 Vpixx same image with
% dispartity

skipsync          =  1; % skip syncrony test for the monitor;


%% Set experiment parameters
offset = [];  % [] means no translation of the stimuli
movieflip = [0 0];  % [0 0] means no flips.  [1 0] is necessary for flexi mirror to show up right-side up
frameduration = 12;  % number of monitor frames for one unit.  60/5 = 12
ptonparams = {[],[],0,skipsync,stereoMode};  % don't change resolution



% Size of fixation
fixationsize = [11 0];
grayval = uint8(127);
scfactor = 2;  %scale images bigger or smaller,for testing purpose, let's make it bigger
contrast_factor = 1;% scale contrast of two lower level contrasts


%% Run experiment
oldclut = pton3D(ptonparams{:});

%make and present texture
% get information about the PT setup
win = firstel(Screen('Windows'));
rect = Screen('Rect',win);
face = uint8(round(faceimg(:,:,1)*254));
house = uint8(round(houseimg(:,:,1)*254));
word = uint8(round(houseimg(:,:,1)*2*254));

texture = Screen('MakeTexture',win,face);
texture2 = Screen('MakeTexture',win,house);


movierect = CenterRect([0 0 round(size(face,1)) round(size(face,2))],rect)
Screen('SelectStereoDrawBuffer', win, 0);
Screen('DrawTexture',win,texture,[],movierect,0,[],1);
Screen('SelectStereoDrawBuffer', win, 1);
Screen('DrawTexture',win,texture2,[],movierect,0,[],1);
Screen('flip',win);
KbWait(-1);

ptoff3D(oldclut,stereoMode);


% clear path
rmpath(genpath(pwd));


