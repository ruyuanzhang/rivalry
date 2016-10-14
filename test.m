%%test grating rotation

gabor=createGrating(130,'spatialMaskType','Circular');
%% Run experiment
ptonparams = {[],[],0,1,0};  % don't change resolution
oldclut = pton3D(ptonparams{:});
win = firstel(Screen('Windows'));
rect = Screen('Rect',win);
texture=Screen('MakeTexture',win,gabor.gratingImg);

% presentation
for i=1:50
    rotangle=-45;
    t=0;
    for y=1:10
        rotangle=rotangle+2;
        Screen('DrawTexture',win,texture,[],[],rotangle,[],1);
        Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        Screen('DrawTexture',win,texture,[],[],-rotangle,[],0.5);
        Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        t=GetSecs;
        if y==0
            Screen('Flip',win);
        else
            t=Screen('Flip',win,t+0.2);
        end
    end
    
    Screen('FillRect',win,127);
    t=Screen('Flip',win);
    t=Screen('Flip',win,t+3);
end

ptoff3D(oldclut,0);
