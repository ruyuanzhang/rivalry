function [dcolor, colors] = CreateFixationTask_Luminance(nframes,fixrate,nlum)
% [dcolor, colors] = CreateFixationTask_Luminance(nframes)
% Create fixation task of detect luminance increment or decrement
% Inputs:
%       nframes:                number of frames total you want the color sequence
%   optional:
%       fixrate:      how many frames you want to change the luminance
%       nlum:       how many luminance levels you want
% 
% Output:
%       dcolor:     a nrun * frames matrix indexing colors
%       colors:     a nlum * 3 (RGB) of color list
% 
%i.e.
% [dcolor, colors] = CreateFixationTask(nframes)
%
% history.
% 02/24/16, RZ created it based on function CreateFixationTask.m from Jason Yeatman 
%           

if ~exist('nframes','var')||isempty('nframes')
    error('please input the number of frames you want');
end

if ~exist('fixrate','var')||isempty('fixrate')
    fixrate = 5; % default, change luminance every 5 frames.
end

if ~exist('nlum','var')||isempty('nlum')
    nlum = 5; %default, 5 luminance levels;
end

color =[255 0 0] ;% color for detecting. default is red [255 0 0];
colors=[linspace(color(1),40,nlum)' linspace(color(2),0,nlum)' linspace(color(3),0,nlum)'];

% total size(colors,1) color items in this color list, so the target rate will be every
% fixrate * size(colors,1) per target.If you want to change the target rate, simple
% delete or add more repeated colors using code above. Let's say you want
% one target every 30 frame, then there should be ceil(30/fixrate) items in
% color list, just handly add or delete some colors 
% i.e. 
%        colors = vertcat(colors, colors(2:3));
% or     colors = vertcat(colors,colors(2:end),colors(2:end));


% Create a random vector indexing into the colors
%here is old code from Jason...I think it's wrong...
%dcolor = ceil(rand(1, nframes).*size(colors,1);

%here is the fixation
dcolor = ceil(rand(1, ceil(nframes/fixrate)).*size(colors,1));
dcolor = repmat(dcolor,fixrate,1);
dcolor = reshape(dcolor,[],size(dcolor,1)*size(dcolor,2));
dcolor = dcolor(1:nframes);

% Add numbers so it matches KNK's format
dcolor = [-1 -dcolor -1 1];