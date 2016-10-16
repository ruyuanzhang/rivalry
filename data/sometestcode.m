%%
cl;
H(1)=figure;
set(H(1),'Position',[ 680  118  400  400]);
note={sprintf('face left rms=0.1\nhouse right rms=0.2'),...
    sprintf('face right rms=0.1\nhouse left rms=0.2'),...
    sprintf('face left rms=0.15\nhouse right rms=0.15'),...
    sprintf('face right rms=0.15\nhouse left rms=0.15'),...
    sprintf('face right rms=0.15\nhouse left rms=0.20')};
for i=[1 2 3 4 5]
    load(sprintf('test%d.mat',i));
    ax(i)=subplot(3,2,i);
    myplot(eyelum(:,1)/127,'r-o');
    myplot(eyelum(:,2)/127,'g-o');
    ylim([0 1]);
    xlabel('trials');
    ylabel('scale');
    if i==1
        legend('left eye','right eye');
    end
    
    text(10,0.1,note{i});
end

%supertitle('LH');
figrmwhitespace(ax,3,2);
%%
H(2)=figure;
name=matchfiles('*test*');
set(H(2),'Position',[680  118  400   400]);
note={sprintf('face lefteye rms=0.1\nhouse righteye rms=0.2'),...
    sprintf('face righteye rms=0.1\nhouse lefteye rms=0.2'),...
    sprintf('face lefteye rms=0.15\nhouse righteye rms=0.15'),...
    sprintf('face righteye rms=0.15\nhouse lefteye rms=0.15'),...
    sprintf('face righteye rms=0.15\nhouse lefteye rms=0.20')};
for i=1:5
    load(name{i});
    ax(i)=subplot(3,2,i);
    myplot(eyelum(:,1)/127,'r-o');
    myplot(eyelum(:,2)/127,'g-o');
    ylim([0 1]);
    xlabel('trials');
    ylabel('scale');
    text(10,0.1,note{i});
    if i==1
        legend('left eye','right eye');
    end
end
figrmwhitespace(ax,3,2);
%%
H(3)=figure;
set(H(3),'Position',[548   717   400   350]);
note={sprintf('face, left eye, rms=0.15\nhouse right rms=0.15'),...
    sprintf('face, right eye, rms=0.5\nhouse left rms=0.5'),...
    sprintf('face, left eye, rms=0.5\nhouse righteye rms=0.5'),...
    sprintf('face, righteye, rms=0.5\nhouse lefteye rms=0.5')};


for i=6:9
    load(name{i});
    bx(i-5)=subplot(2,2,i-5);
    myplot(eyelum(:,1)/127,'r-o');
    myplot(eyelum(:,2)/127,'g-o');
    ylim([0 1]);
    xlabel('trials');
    ylabel('scale');
    text(10,0.1,note{i-5});
    if i==1
        legend('left eye','right eye');
    end
end
figrmwhitespace(bx,2,2);