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


%% Set experiment parameters
p.stereoMode        =  1; % 1,haplo scope;2, Vpixx
p.skipsync          =  1; % skip syncrony test for the monitor;
p.stimSize          =  200;% 200*200 pixels image

cat1Name            =    ;%file name for category 1
cat2Name            =




%set the monitor parameters
if p.stereoMode == 1 %haplo scope
    p.monitorWidth = ;
    p,resolutation = ;
    p.viewDistance = ;
    p.scale_factor = ;
    
else p.stereoMode == 2 %Vpixx
    p.monitorWidth = ;
    p,resolutation = ;
    p.viewDistance = ;
    p.scale_factor = ; 
end

% open screen





















%Load the stimulus file
