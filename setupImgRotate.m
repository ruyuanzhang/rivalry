
%compuate the rotation angle
angleStep = 2;
if frameorder(framecnt)~=frameorder(framecnt-1)
    angleStepCnt = 0;
elseif frameorder(framecnt)==frameorder(framecnt-1)
    angleStepCnt = angleStepCnt+1;
end

if angleStepCnt == 0
    rotDir = sign(rand-0.5); 
end

if rotate == 1
    rotangle = rotDir*angleStepCnt*angleStep;
elseif rotate == 0
    rotangle = 0;
end
