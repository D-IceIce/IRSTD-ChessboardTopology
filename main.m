%{
    Copyright (c) 2024 BINGBING DAN

    Author: Bingbing Dan
    Email: danbingbing20@mails.ucas.ac.cn
    Affiliation: University of Chinese Academy of Sciences

    Corresponding Publication:
    Bingbing Dan, et al. "Infrared dim-small target detection via chessboard topology"
    Optics & Laser Technology, 2024

%}

clc;
clear;
close all;

img = imread('images/1.bmp');
img = mat2gray(img);
[m,n] = size(img);
row = 5;
col = 5;

colPixel = [];
cPixel = [];
maxC = [];
minC = [];
for mm = 2:1+row
    imgScale = admdfunc(img,mm);
    threshold = min(imgScale(:)):(max(imgScale(:))-min(imgScale(:)))/col:max(imgScale(:));
    threshold(end) = threshold(end)+1;
    temp = zeros(m,n);
    C = [];
    for ii = 1:col
        if find(imgScale>=threshold(ii) & imgScale<threshold(ii+1))
            temp(imgScale>=threshold(ii) & imgScale<threshold(ii+1)) = ii;
            C = cat(1,C,sum(temp(:)==ii));
        else
             C = cat(1,C,0);
        end
    end

    colPixel = cat(3,colPixel,temp); 
    cPixel = cat(3,cPixel,arrayfun(@(x) C(x),temp)); 
    maxC = cat(3,maxC,max(C).*ones(m,n)); 
    C(C==0)=Inf;
    minC = cat(3,minC,min(C).*ones(m,n)); 
end

% scoreL
scoreL = sum(maxC./cPixel,3);
subplot(131)
imshow(scoreL,[])
title('scoreL')

% scoreS
mostCol = mode(colPixel,3);
mostCol = repmat(mostCol,[1 1 row]);
cPixel(colPixel~=mostCol) = 0;
x = minC./cPixel;
x(x==Inf)=0;
scoreS = sum(x,3);
subplot(132)
imshow(scoreS,[])
title('scoreS')

% result
R = mat2gray(scoreS)+mat2gray(scoreL);
subplot(133)
imshow(R,[])
title('Result')
