%% match face,house,cars rms contrast.
% seting target rms contrast too high will induce many pixels out of
% 0~1range. But as long as there is only very small portion of such
% 'spiky' pixel, it's acceptable. So resulting images should be visually
% checked

cl;
imageSize = 260;
squre     = 184;
RMS = 0.12*ones(1,19);




img=zeros(imageSize,imageSize,19,5);
mask=img;
%%
% 720/sqrt(2)=510*510
rect=CenterRect([1 1 squre squre],[1 1 imageSize imageSize]);
tmp=zeros(imageSize,imageSize);
tmp(rect(1):rect(3),rect(2):rect(4))=1;
ind=find(tmp==1);


for i=1:19
    % read in image and mask
    cd face_19;
    face=imread(sprintf('face%02d.png',i));facemask=imread(sprintf('face%02d_mask.png',i));
    cd ..
    cd house_24;
    house=imread(sprintf('house%02d.png',i));housemask=imread(sprintf('house%02d_mask.png',i));
    cd ..
    cd object_24;
    car=imread(sprintf('object%02d.png',i));carmask=imread(sprintf('object%02d_mask.png',i));
    cd ..
    
    %resize img
    face=imresize(face,[imageSize imageSize]);facemask=imresize(facemask,[imageSize imageSize]);
    house=imresize(house,[imageSize imageSize]);housemask=imresize(housemask,[imageSize imageSize]);
    car=imresize(car,[imageSize imageSize]);carmask=imresize(carmask,[imageSize imageSize]);
    
    % binarize facemask, read the index
    facemask(facemask(:)~=0)=255;faceind=find(facemask(:)==255);
    housemask(housemask(:)~=0)=255;houseind=find(housemask(:)==255);
    carmask(carmask(:)~=0)=255;carind=find(carmask(:)==255);
    
    % scale image to 
    face=imnormconst(face);
    house=imnormconst(house);
    car=imnormconst(car);
    
    % compute pre rms contrast
    rmsface=sqrt(sum((face(faceind)-mean(face(faceind))).^2)/numel(faceind));
    rmshouse=sqrt(sum((house(houseind)-mean(house(houseind))).^2)/numel(houseind));
    rmscar=sqrt(sum((car(carind)-mean(car(carind))).^2)/numel(carind));
    
    
    
    % scale it
    face(faceind)=(face(faceind)-mean(face(faceind)))/rmsface*RMS(i)+0.5;
    face(facemask(:)==0)=0.5;
    house(houseind)=(house(houseind)-mean(house(houseind)))/rmshouse*RMS(i)+0.5;
    house(housemask(:)==0)=0.5;
    car(carind)=(car(carind)-mean(car(carind)))/rmscar*RMS(i)+0.5;
    car(carmask(:)==0)=0.5;
    facehouse=face+house-0.5;
    
    
    % now we match rms contrast in a squre region, we set to
    
    %compute pre rms contrast in this squre
    % compute pre rms contrast
    rmsface2=sqrt(sum((face(ind)-0.5).^2)/numel(ind));
    rmshouse2=sqrt(sum((house(ind)-0.5).^2)/numel(ind));
    rmscar2=sqrt(sum((car(ind)-0.5).^2)/numel(ind));
    %[rmsface2 rmshouse2 rmscar2]
    
    % scale it
    face(ind)=(face(ind)-0.5)/rmsface2*RMS(i)+0.5;
    house(ind)=(house(ind)-0.5)/rmshouse2*RMS(i)+0.5;
    car(ind)=(car(ind)-0.5)/rmscar2*RMS(i)+0.5;
    facehouse=face+house-0.5;
    
    % recompute rms again
    rmsface2_post=sqrt(sum((face(ind)-0.5).^2)/numel(ind));
    rmshouse2_post=sqrt(sum((house(ind)-0.5).^2)/numel(ind));
    rmscar2_post=sqrt(sum((car(ind)-0.5).^2)/numel(ind));
    [rmsface2_post rmshouse2_post rmscar2_post]
    
    img(:,:,i,1)=127;
    img(:,:,i,2)=round(face*254);
    img(:,:,i,3)=round(house*254);
    img(:,:,i,4) =round(car*254);
    img(:,:,i,5)=round(facehouse*254);
    
    mask(:,:,i,1)=127;
    mask(:,:,i,2)=round(facemask*254);
    mask(:,:,i,3)=round(housemask*254);
    mask(:,:,i,4)=round(carmask*254);
        
end
%%
viewimages(round(img(:,:,:,2)));colormap(gray);caxis([0 254]);
viewimages(round(img(:,:,:,3)));colormap(gray);caxis([0 254]);
viewimages(round(img(:,:,:,4)));colormap(gray);caxis([0 254]);
viewimages(round(img(:,:,:,5)));colormap(gray);caxis([0 254]);

%
%save('fLocStim','img','mask');
