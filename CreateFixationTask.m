function [dcolor, colors] = CreateFixationTask(nframes)
% Create fixation task of random color changes
% <nframes> number of frams,
% <dcolor>,<colors> are outputs. 
% <dcolor> is a vector indexing color presentation sequence,refering the
%   row number in color list <dcolor>
% <colors> is the n*3 matrix of color list, the row number n refers to
%   colors
% 
%i.e.
% [dcolor, colors] = CreateFixationTask(nframes)
%
% Create a random changing fixation dot.

% history.
% 02/23/16, RZ added variable ncolor to index number of colors
%           RZ added variable fixrate to index fixation color changing rate
%           

% 
ncolor = 3;%numebr of distinct colors in color list 12 set by Jason, changed to 5 by Kendrick request.
fixrate = 2;% number of frames for one fixation color presentation. Actual duration depends on monitor fresh rate

    
% make color list
colors = hsv(ncolor).*255;% those different colors we want.

% make red (the target) half as likely as the others
colors = vertcat(colors);
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