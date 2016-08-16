
movierect = CenterRect([0 0 round(scfactor*d2images) round(scfactor*d1images)],rect) + ...
                [offset(1) offset(2) offset(1) offset(2)];

%% compute some
if ~exist('currentrblumconst','var')||sum(currentrblumconst~=rblumconst)~=0
    currentrblumconst = rblumconst;
dotColor_r      = round(dotColor*rblumconst(2)*(rblumconst(1)*(rblumconst(1)<128)+(254-rblumconst(1))*(rblumconst(1)>127))+rblumconst(1)); 
dotColor_b      = round(dotColor*rblumconst(4)*(rblumconst(3)*(rblumconst(3)<128)+(254-rblumconst(3))*(rblumconst(3)>127))+rblumconst(3));
frameColor_r    = ([255 255 255]-127)/127*rblumconst(2)*(rblumconst(1)*(rblumconst(1)<128)+(254-rblumconst(1))*(rblumconst(1)>127))+rblumconst(1);
frameColor_b    = ([255 255 255]-127)/127*rblumconst(4)*(rblumconst(3)*(rblumconst(3)<128)+(254-rblumconst(3))*(rblumconst(3)>127))+rblumconst(3);
end         
%% script to draw dots background 
if stereoMode == 0
    Screen('DrawDots', win, xy,dotsSize,dotColor,[rect(3)/2 rect(4)/2],1); %drawDots
    Screen('FrameRect', win, [255 255 255],[desRect(1)-dotsSize desRect(2)-dotsSize desRect(3)+dotsSize desRect(4)+dotsSize],5); %DrawFrame
    Screen('FillOval', win, grayval,movierect+[-50 -50 50 50]); %Draw blank for stimuli presentation
    
elseif stereoMode == 1||stereoMode == 2||stereoMode == 5
    Screen('SelectStereoDrawBuffer', win, 0);
    Screen('DrawDots', win, xy,dotsSize,dotColor_r,[rect(3)/2 rect(4)/2],1); %drawDots
    Screen('FrameRect', win, frameColor_r,[desRect(1)-dotsSize desRect(2)-dotsSize desRect(3)+dotsSize desRect(4)+dotsSize],5); %DrawFrame
    Screen('FillOval', win, rblumconst(1),movierect+[-50 -50 50 50]); %Draw blank for stimuli presentation
    Screen('SelectStereoDrawBuffer', win, 1);
    Screen('DrawDots', win, xy,dotsSize,dotColor_b,[rect(3)/2 rect(4)/2],1); %drawDots
    Screen('FrameRect', win, frameColor_b,[desRect(1)-dotsSize desRect(2)-dotsSize desRect(3)+dotsSize desRect(4)+dotsSize],5); %DrawFrame
    Screen('FillOval', win, rblumconst(3),movierect+[-50 -50 50 50]); %Draw blank for stimuli presentation
end
    