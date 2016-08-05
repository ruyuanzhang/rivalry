function img=adjustconst(img,const)


if const>1
    const=1;
end

img=double(img);
mean=median(img(:));

img=(img-mean)*const+mean;




end