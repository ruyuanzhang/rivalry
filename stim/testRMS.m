%% match face,house,cars rms contrast.
% seting target rms contrast too high will induce many pixels out of
% 0~1range. But as long as there is only very small portion of such
% 'spiky' pixel, it's acceptable. So resulting images should be visually
% checked

%clearvars -except img;
cl;
load('fLocStim.mat');
clearvars -except img;

imageSize = 260;
squre     = 184;

%%
rect=CenterRect([1 1 squre squre],[1 1 imageSize imageSize]);
tmp=zeros(imageSize,imageSize);
tmp(rect(1):rect(3),rect(2):rect(4))=1;
ind=find(tmp==1);
for i=1:19
    
    % read in image and mask
    face=double(img(:,:,i,2))/254;
    house=double(img(:,:,i,3))/254;
    car=double(img(:,:,i,4))/254;
    
   
    % recompute rms again
    rmsface2_post=sqrt(sum((face(ind)-0.5).^2)/numel(ind));
    rmshouse2_post=sqrt(sum((house(ind)-0.5).^2)/numel(ind));
    rmscar2_post=sqrt(sum((car(ind)-0.5).^2)/numel(ind));
    [rmsface2_post rmshouse2_post rmscar2_post]
    
end
%

