function constcalibration(runnum,stimfile)

% The main experiment function for binocular rivalry experiment with
% ptmovieview function, maybe not use movieview


%Input:
%   optional
%       runnum: number of current run?default = 1;
%       stimfile: specifile stim file, default = "rivalryExp.mat"

subj = input('Input subject number:','s');

if ~exist('runnum','var') || isempty(runnum)
    runnum = 1;
end
if ~exist('stimfile','var') || isempty(stimfile)
    path = fileparts(which('run_rivalryExp.m'));
    stimfile = fullfile(path,'rivalryExp.mat');
end

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



load(sprintf('lumconst_%s.mat',subj));
rblumconst=lumconst; %initial contrast for left and right image
rblumconst


frameduration = 24;  % number of monitor frames for one unit.  60/5 = 12,120/5=24
%ptonparams = {[1920 1080 120 24],[],0,skipsync,stereoMode};  % manually

%ptonparams = {[1920 1080 120 24],[],0,skipsync,stereoMode};  % manually

%change resolution
ptonparams = {[],[],0,skipsync,stereoMode};  % don't change resolution



% Size of fixation
fixationsize = [11 0];
grayval = uint8(127);
scfactor = 1;  % scale images bigger or smaller
contrast_factor = 1;% scale contrast of two lower level contrasts

%scale the contrast
if contrast_factor ~= 1
    pixVal = unique(img);
    pixVal_tmp = pixVal(2:end); % 
    pixVal_tmp = (pixVal_tmp-grayval) * contrast_factor + grayval;
    pixVal_tmp(pixVal_tmp>254) = 254; % set maxima pixel value
    for i=1:size(pixVal_tmp,1);
        img(img==pixVal(i+1)) = pixVal_tmp(i); % change the pix value to new contrast
    end
end


%img = uint8(round(faceimg*254));

%%
% we use key buttons '1','2'to increase/decrease red and '1','2'to increase/decrease green 


%% Run experiment
oldclut = pton3D(ptonparams{:});
[timeframes,timekeys,digitrecord,trialoffsets] = ...
    ptviewmovie3D_consthack(reshape(img,[size(img,1), size(img,2), 1 , size(img,3),size(img,4)]), ...
    frameorder(runnum,:),[],frameduration,fixorder(runnum,:),fixcolor, ...
    fixationsize,grayval,[],[],offset,[],movieflip,scfactor,[], ...
    [],[],[],'t',[],[],[],[],[],[],[],[],stereoMode,expcondorder(runnum,:),rblumconst); % scanner button box trigger, for letter, use 't' ; for digit, use "5" 
ptoff3D(oldclut,stereoMode);

%Save the timing info and key button press for future analysis
load('test.mat');

% plot the green channel staircase
figure;
plot(catconst(:,1),'r-o','lineWidth',2);ylim([0 1.5]);hold on;
plot(catconst(:,2),'g-o','lineWidth',2);ylim([0 1.5]);hold on;
plot(catconst(:,3),'b-o','lineWidth',2);ylim([0 1.5]);hold on;
legend({'F','H','C'});
xlabel('trials');
ylabel('contrast');

c=fix(clock);
filename=sprintf('%d%02d%02d%02d%02d%02d_sub%s_consttest',c(1),c(2),c(3),c(4),c(5),c(6),subj);
save(filename);

fprintf('Mean conrast values for F,H,C are %.4f %.4f %.4f \n',mean(catconst(50:end,1)),mean(catconst(50:end,2)),mean(catconst(50:end,3)));
lumconst(2) = mean(catconst(50:end,1));
lumconst(4) = mean(catconst(50:end,2));
lumconst(5) = mean(catconst(50:end,3));
save(sprintf('lumconst_%s.mat',subj),'lumconst');



% clear path
rmpath(genpath(pwd));


