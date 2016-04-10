function ptoff3D(oldclut,stereoMode)

% function ptoff(oldclut)
%
% <oldclut> (optional) is the clut to restore.
%   default is [] which means do not restore a clut.
%
% uninitialize the PsychToolbox setup by restoring the clut
% and closing all PsychToolbox windows.
%
% use in conjunction with pton.m.
%
% example:
% pton;
% ptoff;

% input
if ~exist('oldclut','var') || isempty(oldclut)
  oldclut = [];
end
if ~exist('stereoMode','var') || isempty(stereoMode)
  stereoMode = 0;
end



% do it
win = Screen('Windows');
%%% 3D BEGIN

% THIS CRASHES FOR SOME REASON. JUST OMIT THE RESTORATION!!!!
%if ~isempty(oldclut)
%  Screen('LoadNormalizedGammaTable',win,oldclut);
%end

%%% 3D END
Screen('Close',win);
Screen('CloseAll');




if stereoMode == 2 || stereoMode == 4
    %%% 3D BEGIN
    if Datapixx('IsViewpixx3D')
        Datapixx('DisableVideoLcd3D60Hz');
        Datapixx('RegWr');
    end
    Datapixx('Close');    
    %%% 3D END
end
