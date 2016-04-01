
movierect = CenterRect([0 0 round(scfactor*d2images) round(scfactor*d1images)],rect) + ...
                [offset(1) offset(2) offset(1) offset(2)];

            
%% script to draw dots background 
if stereoMode == 0
    Screen('DrawDots', win, xy,dotsSize,dotColor,[rect(3)/2 rect(4)/2],1); %drawDots
    Screen('FrameRect', win, [255 255 255],[desRect(1)-dotsSize desRect(2)-dotsSize desRect(3)+dotsSize desRect(4)+dotsSize],5); %DrawFrame
    Screen('FillRect', win, grayval,movierect); %Draw blank for stimuli presentation
    
elseif stereoMode == 1||stereoMode == 2
    Screen('SelectStereoDrawBuffer', win, 0);
    Screen('DrawDots', win, xy,dotsSize,dotColor,[rect(3)/2 rect(4)/2],1); %drawDots
    Screen('FrameRect', win, [255 255 255],[desRect(1)-dotsSize desRect(2)-dotsSize desRect(3)+dotsSize desRect(4)+dotsSize],5); %DrawFrame
    Screen('FillRect', win, grayval,movierect); %Draw blank for stimuli presentation
    Screen('SelectStereoDrawBuffer', win, 1);
    Screen('DrawDots', win, xy,dotsSize,dotColor,[rect(3)/2 rect(4)/2],1); %drawDots
    Screen('FrameRect', win, [255 255 255],[desRect(1)-dotsSize desRect(2)-dotsSize desRect(3)+dotsSize desRect(4)+dotsSize],5); %DrawFrame
    Screen('FillRect', win, grayval,movierect); %Draw blank for stimuli presentation
end
    