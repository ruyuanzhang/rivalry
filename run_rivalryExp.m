function run_rivalryExp(runnum,stimfile)

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

% add functions untilized in the exp
addpath(genpath(pwd));

%% Set experiment parameters
stereoMode        =  1; % 0?no stereo; 1,haplo scope;2, Vpixx
skipsync          =  1; % skip syncrony test for the monitor;

fprintf('\n\nRUNNING LEXICALITY EXPERIMENT STIMFILE %s\nRUN %d',stimfile,runnum);
%% Set experiment parameters
skipsync = 1
offset = [];  % [] means no translation of the stimuli
movieflip = [0 0];  % [0 0] means no flips.  [1 0] is necessary for flexi mirror to show up right-side up
frameduration = 12;  % number of monitor frames for one unit.  60/5 = 12
ptonparams = {[],[],0,skipsync,stereoMode};  % don't change resolution



% Size of fixation
fixationsize = [11 0];
grayval = uint8(127);
scfactor = 0.5;  % scale images bigger or smaller
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


%% Run experiment

oldclut = pton3D(ptonparams{:});
[timeframes,timekeys,digitrecord,trialoffsets] = ...
    ptviewmovie3D(reshape(img,[size(img,1), size(img,2), 1 , size(img,3),size(img,4)]), ...
    frameorder(runnum,:),[],frameduration,fixorder(runnum,:),fixcolor, ...
    fixationsize,grayval,[],[],offset,[],movieflip,scfactor,[], ...
    [],[],[],'t',[],[],[],[],[],[],[],[],stereoMode); % scanner button box trigger, for letter, use 't' ; for digit, use "5" 
ptoff3D(oldclut,stereoMode);

%Save the timing info and key button press for future analysis
load('test.mat');
save(['run' num2str(runnum)],'timeframes','timekeys');

% clear path
rmpath(genpath(pwd));


