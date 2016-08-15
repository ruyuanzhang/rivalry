
%compuate the rotation angle
angleStep = 2;
if frameorder(framecnt)~=frameorder(framecnt-1)
    angleStepCnt = 0;
    rotangle = 0;
elseif frameorder(framecnt)==frameorder(framecnt-1)
    angleStepCnt = angleStepCnt+1;
end

if angleStepCnt == 0
    rotDir = sign(rand-0.5); 
end

if rotate == 1
    rotangle = rotangle+rotDir*angleStep;
    if rotangle > 30 ||rotangle < -30
        rotDir=-rotDir;
    end
elseif rotate == 0
    rotangle = 0;
end
