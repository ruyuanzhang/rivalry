function run_rivalryExp(runnum,stimfile)

% The main experiment function for binocular rivalry experiment with
% ptmovieview function, maybe not use movieview


%Input:
%   optional
%       runnum: number of current run?default = 1;
%       stimfile: specifile stim file, default = "RivalryExp.mat"



if ~exist('runnum','var') || isempty(runnum)
    runnum = 1;
end
if ~exist('stimfile','var') || isempty(stimfile)
    path = fileparts(which('run_rivalryExp.m'));
    stimfile = fullfile(path,'rivalryExp.mat');
end

% receive some input
subj = input('Input subject number:','s');
expnum = input('What is the experiment number?\nRivalry:1\n');




%load the file
load('RivalryExp.mat');

% add functions untilized in the exp
addpath(genpath(pwd));

%% Set experiment parameters

stereoMode        =  5; 

% 0,no stereo; 1,haploscope, two different images;2, Vpixx two
% different images;3,haploscope same image with disparity;4 Vpixx same image with
% dispartity

skipsync          =  0; % skip syncrony test for the monitor;

fprintf('\n\nRUNNING BINOCULAR RIVALRY EXPERIMENT STIMFILE %s\nRUN %d',stimfile,runnum);
%% Set experiment parameters
offset = [0 0];  % [] means no translation of the stimuli
movieflip = [0 0];  % [0 0] means no flips.  [1 0] is necessary for flexi mirror to show up right-side up

%for kk

%load(sprintf('lumconst_%s.mat',subj));
%rblumconst=lumconst;
rblumconst=[127.0000    0.7729   100.7457    1.0000    0.7605];
rblumconst


frameduration = 12;  % number of monitor frames for one unit.  120/5 = 24

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
    ptviewmovie3D(reshape(img,[size(img,1), size(img,2), 1 , size(img,3),size(img,4)]), ...
    frameorder(runnum,:),[],frameduration,fixorder(runnum,:),fixcolor, ...
    fixationsize,grayval,[],[],offset,[],movieflip,scfactor,[], ...
    [],[],[],'t',[],[],[],[],[],[],[],[],stereoMode,expcondorder(runnum,:),rblumconst); % scanner button box trigger, for letter, use 't' ; for digit, use "5" 
ptoff3D(oldclut,stereoMode);

%Save the timing info and key button press for future analysis
load('test.mat');
c=fix(clock);
filename=sprintf('%d%02d%02d%02d%02d%02d_sub%s_run%02d_exp%03d',c(1),c(2),c(3),c(4),c(5),c(6),subj,runnum,expnum);
save(filename);

% clear path
rmpath(genpath(pwd));


