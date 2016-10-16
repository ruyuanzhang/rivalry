function lumcalibration(runnum,stimfile)

% The main experiment function for binocular rivalry experiment with
% ptmovieview function, maybe not use movieview


%Input:
%   optional
%       runnum: number of current run?default = 1;
%       stimfile: specifile stim file, default = "rivalryExp.mat"


if ~exist('runnum','var') || isempty(runnum)
    runnum = 1;
end
if ~exist('stimfile','var') || isempty(stimfile)
    path = fileparts(which('run_rivalryExp.m'));
    stimfile = fullfile(path,'rivalryExp.mat');
end

%load the file
load('RivalryExp.mat');


% replace images to gabors
gabor=createGrating(size(img,1)/2);
gabor = gabor.gratingImg;
gabor = repmat(gabor,[1 1 76]);
img(:,:,:,2)=gabor;
img(:,:,:,3)=gabor;
img(:,:,:,4)=gabor;

% add functions untilized in the exp
addpath(genpath(pwd));

%% Set experiment parameters

stereoMode        =  5; 

% 0,no stereo; 1,haploscope, two different images;2, Vpixx two
% different images;3,haploscope same image with disparity;4 Vpixx same image with
% dispartity

skipsync          =  1; % skip syncrony test for the monitor;

fprintf('\n\nRUNNING LEXICALITY EXPERIMENT STIMFILE %s\nRUN %d',stimfile,runnum);
%% Set experiment parameters
offset = [0 0];  % [] means no translation of the stimuli
movieflip = [0 0];  % [0 0] means no flips.  [1 0] is necessary for flexi mirror to show up right-side up

rblumconst=[127 1 127 1]; %initial contrast for left and right image

frameduration = 12;  % number of monitor frames for one unit.  60/5 = 12,120/5=24
%ptonparams = {[1920 1080 120 24],[],0,skipsync,stereoMode};  % manually
%ptonparams = {[1920 1080 120 24],[],0,skipsync,stereoMode};  % manually

%change resolution
ptonparams = {[],[],0,skipsync,stereoMode};  % don't change resolution


% Size of fixation
fixationsize = [11 0];
grayval = uint8(127);
scfactor = 1;  % scale images bigger or smaller



%% Run experiment
oldclut = pton3D(ptonparams{:});
[timeframes,timekeys,digitrecord,trialoffsets] = ...
    ptviewmovie3D_lumhack_lum(reshape(img,[size(img,1), size(img,2), 1 , size(img,3),size(img,4)]), ...
    frameorder(runnum,:),[],frameduration,fixorder(runnum,:),fixcolor, ...
    fixationsize,grayval,[],[],offset,[],movieflip,scfactor,[], ...
    [],[],[],'t',[],[],[],[],[],[],[],[],stereoMode,expcondorder(runnum,:),rblumconst); % scanner button box trigger, for letter, use 't' ; for digit, use "5" 
ptoff3D(oldclut,stereoMode);

%Save the timing info and key button press for future analysis
load('test.mat');

% plot the green channel staircase
figure;
plot(eyelum(:,1),'r-o','lineWidth',2);ylim([0 150]);hold on;
plot(eyelum(:,2),'g-o','lineWidth',2);ylim([0 150]);hold on;

c=fix(clock);
filename=sprintf('%d%02d%02d%02d%02d%02d_lumtest',c(1),c(2),c(3),c(4),c(5),c(6));
save(filename);
%sprintf('Mean luminance value in last 32 trials are %d for left(red) and %d right(blue)')
%save(['run' num2str(runnum)],'timeframes','timekeys');

% clear path
rmpath(genpath(pwd));


