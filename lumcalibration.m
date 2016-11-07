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

subj = input('Input subject number:','s');

%load the file
load('RivalryExp.mat');

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

rblumconst=[127 1 127 1 1]; %initial contrast for left and right image

frameduration = 24;  % number of monitor frames for one unit.  60/5 = 12,120/5=24
%ptonparams = {[1920 1080 120 24],[],0,skipsync,stereoMode};  % manually
ptonparams = {[1920 1080 120 24],[],0,skipsync,stereoMode};  % manually

%change resolution
%ptonparams = {[],[],0,skipsync,stereoMode};  % don't change resolution


% Size of fixation
fixationsize = [11 0];
grayval = uint8(127);
scfactor = 1;  % scale images bigger or smaller



%% Run experiment
oldclut = pton3D(ptonparams{:});
[timeframes,timekeys,digitrecord,trialoffsets] = ...
    ptviewmovie3D_lumhack(reshape(img,[size(img,1), size(img,2), 1 , size(img,3),size(img,4)]), ...
    frameorder(runnum,:),[],frameduration,fixorder(runnum,:),fixcolor, ...
    fixationsize,grayval,[],[],offset,[],movieflip,scfactor,[], ...
    [],[],[],'t',[],[],[],[],[],[],[],[],stereoMode,expcondorder(runnum,:),rblumconst); % scanner button box trigger, for letter, use 't' ; for digit, use "5" 
ptoff3D(oldclut,stereoMode);

%Save the timing info and key button press for future analysis
load('test.mat');

% compute the plot the green channel staircase
labeltoplot=nReversalLabel;
labeltoplot(labeltoplot==0)=-1;
labeltoplot(labeltoplot==1)=min(eyelum(labeltoplot==1,1),eyelum(labeltoplot==1,2));
% We discard first three reversals and average other reversals.
labels=find(nReversalLabel~=0);
lumthreshold(1)=mean(eyelum(labels(4:end),1));
lumthreshold(2)=mean(eyelum(labels(4:end),2));

figure;
plot(eyelum(:,1),'r-o','lineWidth',2);ylim([0 150]);hold on;
plot(eyelum(:,2),'g-o','lineWidth',2);ylim([0 150]);hold on;
plot(labeltoplot,'k*','MarkerSize',10);ylim([0 150]);hold on; % plot reversal
plot(1:numel(eyelum(:,1)),ones(1,numel(eyelum(:,1)))*lumthreshold(1),'r--');ylim([0 150]);hold on;  %plot threshold
plot(1:numel(eyelum(:,2)),ones(1,numel(eyelum(:,2)))*lumthreshold(2),'g--');ylim([0 150]);hold on;  %plot threshold
xlabel('Trials');
ylabel('Luminance');
legend({'Red (left) eye','Green (right) eye'});





c=fix(clock);
filename=sprintf('%d%02d%02d%02d%02d%02d_sub%s_lumtest',c(1),c(2),c(3),c(4),c(5),c(6),subj);
save(filename);

fprintf('Mean luminance value in last 32 trials are %.4f for left(red) and %.4f right(blue) \n',lumthreshold(1),lumthreshold(2));
lumconst = [lumthreshold(1) 1  lumthreshold(2) 1 1];
save(sprintf('lumconst_%s.mat',subj),'lumconst');


% clear path
rmpath(genpath(pwd));


