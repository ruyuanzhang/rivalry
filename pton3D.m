function oldclut = pton3D(resolution,winsize,clutfile,skipsync,stereoMode)

% function oldclut = pton(resolution,winsize,clutfile,skipsync)
%
% <resolution> (optional) is [width height framerate bitdepth] (e.g. [800 600 60 32]).
%   default is [] which means do not set the resolution.
% <winsize> (optional) is the fraction of the full extent of the screen at which
%   to open a window.  value should be in (0,1).  if supplied, we calculate the
%   new window size (rounding if necessary) and then put the window in the center.
%   default is [] which means open the window at the usual full extent.
% <clutfile> (optional) is
%   (1) a .mat file with the variable 'clut' defined
%   (2) a matrix with the clut itself
%   (3) a string referring to a PsychToolbox calibration.
%       in this case, we calculate the clut that achieves a linear response.
%   (4) 0 which means to use a linear clut
%   (4b) -1 which means to use a sqrt clut
%   (4c) -2 which means to use a sq clut
%   (5) [] which means to do nothing (i.e. do not touch the clut)
%   the clut should be a 256 x 3 matrix with values in [0,1].
%   default: [].
% <skipsync> (optional) is whether to skip the sync tests.  default: 0.
% <stereoMode> (optional) is 0 ,1 ,2 where
%       0:  no stereo
%       1:  stereo with heloscope, which corresponding to stereoMode 4 in
%           StereoDemo.m
%       2:  stereo with Vpixx with different images
%       3:  stereo with heloscope, same image with disparity 
%       4:  stereo with Vpixx, same image with disparity
%       5:  stereoMode for Anaglyph stereo
%
%
%
% initialize the PsychToolbox setup:
%   we assume that you want to operate on the screen with the maximum number.
%   we open a window on this screen and fill it with gray (value of 127).
%   we load in the clut.
%   we run KbName('UnifyKeyNames').
%   we return <oldclut>, which is the clut before the call to this function.
%
% use in conjunction with ptoff.m.  we automaticaly call ptoff at the beginning
% of this function, so it is okay to re-issue calls to pton without calling ptoff.
%
% some general notes on PsychToolbox stuff:
% - beware of java issues (PsychJavaTrouble, ListenChar, CharAvail, GetChar, FlushEvents).
%   we don't rely on any java stuff.
%
% history:
% 2016/08/09 - add a stereoMode option for Anaglyph stereo       
% 2011/10/13 - now always generate a CLUT at 8-bit (256 rows).
% 2016/03/07 - add a stereoModel variable to accordinate with normal
%              monitor presentation and Vpixx stereo presetation
%
% example:
% pton([],.5);

% input
if ~exist('resolution','var') || isempty(resolution)
  resolution = [];
end
if ~exist('winsize','var') || isempty(winsize)
  winsize = [];
end
if ~exist('clutfile','var') || isempty(clutfile)
  clutfile = [];
end
if ~exist('skipsync','var') || isempty(skipsync)
  skipsync = 0;
end
if ~exist('stereoMode','var') || isempty(stereoMode)
  stereoMode = 0;
end



% make sure ptoff
ptoff3D([],stereoMode);

% make sure things are sane
AssertOpenGL;

% which screen will we be operating upon?
screennum = max(Screen('Screens'));


if stereoMode == 2||stereoMode == 4
    %%% 3D BEGIN
    % NOTE: we assume useHardwareStereo==1 is true!!
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'UseDataPixx');
    %%%PsychImaging('AddTask', 'AllViews', 'RestrictProcessing', CenterRect([0 0 512 512], Screen('Rect', screennum)));
    Datapixx('Open');
    Datapixx('EnableVideoScanningBacklight');       % Only required if a VIEWPixx.
    Datapixx('EnableVideoStereoBlueline');
    Datapixx('SetVideoStereoVesaWaveform', 2);      % If driving NVIDIA glasses
    if Datapixx('IsViewpixx3D')
      Datapixx('EnableVideoLcd3D60Hz');
    end
    Datapixx('RegWr');
    %%% 3D END    
end


% set the resolution of the screen
if ~isempty(resolution)
  SetResolution(screennum,resolution(1),resolution(2),resolution(3),resolution(4));
end

% set the sync
Screen('Preference','SkipSyncTests',skipsync);

% open a window and fill with gray
if isempty(winsize)
  rect = [];
else
  rect = Screen('Rect',screennum);  % what is the total rect
  rect = CenterRect(round([0 0 rect(3)*winsize rect(4)*winsize]),rect);  % construct new size
end



bggray = round(255*.2);  % 127??

if stereoMode == 0
    [win,rect] = Screen('OpenWindow',screennum,127,rect);
elseif stereoMode == 1||stereoMode == 3  % simulated two windows on single monitor window, mainly heloscope.
    screennum = 0;
    [win,rect] = Screen('OpenWindow',screennum,127,rect,[],[],4); % number four is the stereoMode for openwindow function
elseif stereoMode == 2||stereoMode == 4 % use two windows by Vpixx

    %%% 3D BEGIN
    
    % OLD:
    % [win,rect] = Screen('OpenWindow',screennum,127,rect);
    %   % STEREO MODE:
    %   %[win,rect] = Screen('OpenWindow',screennum,127,rect,[],[],4);
       
    [win,rect]=PsychImaging('OpenWindow', screennum, bggray, rect, [], [], 1);
    SetStereoBlueLineSyncParameters(win, rect(4)+10);
    
    %%% 3D END
elseif stereoMode == 5
    %screennum = 0;
    [win,rect] = Screen('OpenWindow',screennum,127,rect,[],[],6); % number 6 is the stereoMode for openwindow function
end



% record the current clut
oldclut = Screen('ReadNormalizedGammaTable',win);

% if we have to deal with the clut
if ~isempty(clutfile)

  % define the clut
  if isequal(clutfile,0)
    clut = repmat(linspace(0,1,256)',[1 3]);
  elseif isequal(clutfile,-1)
    clut = repmat(sqrt(linspace(0,1,256)'),[1 3]);
  elseif isequal(clutfile,-2)
    clut = repmat(linspace(0,1,256)'.^2,[1 3]);
  elseif ischar(clutfile)
    if isequal(clutfile(end-3:end),'.mat')
      clut = loadmulti(clutfile,'clut');
    else
      [cal,cals] = LoadCalFile(clutfile);
      cal = SetGammaMethod(cal,0);
      linearValues = ones(3,1)*linspace(0,1,2^8); %%cal.describe.dacsize   %%assert(cal.describe.dacsize==8);
      clut = PrimaryToSettings(cal,linearValues)';
    end
  else
    clut = clutfile;
  end
  assert(size(clut,2)==3 && all(clut(:) >= 0) && all(clut(:) <= 1));  %%isequal(size(clut),[256 3]) 

  % load in the clut
  Screen('LoadNormalizedGammaTable',win,clut);

end

% do some setup stuff
KbName('UnifyKeyNames');
