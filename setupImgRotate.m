%compuate the rotation angle
angleStep = 1;
%found the correct rotation steps
index = find(frameorder(1:framecnt)==0);
angleStepCnt = framecnt - index(end)-1;
if angleStepCnt == 0
    rotDir = sign(rand-0.5); 
end
if rotate == 1
    rotangle = rotDir*angleStepCnt*angleStep;
elseif rotate == 0
    rotangle = 0;
end
