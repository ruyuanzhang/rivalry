%%%%%%%% Some script for binocular rivalry

% During binocular rivaly, we usually dont merely present the visual
% stimuli. The stimuli should be present within the background, which is
% helpful for two eyes' fusion. Here we set some randonly displayed dots
% and a squre frame as the background.


% Draw background frame and dots
% Determine 
bgSize          = 800; % the background should be biggher than
desRect         = [0 0 bgSize bgSize];

%set up dots
x_bound         = desRect(3)-desRect(1);%
y_bound         = desRect(4)-desRect(2);%
dotsSize        = 10; %# of pixel;
dotsNum         = 300; %# of dots in total

dotColor        = uint8(round(repmat(rand(1,dotsNum),3,1)*255)); 

desRect         = CenterRect(desRect,rect) + [offset(1) offset(2) offset(1) offset(2)]; %set Frame rect
xy              = [randi(x_bound,[1,dotsNum])-round(x_bound/2);randi(y_bound,[1,dotsNum])-round(y_bound/2)]; %set location of dots
