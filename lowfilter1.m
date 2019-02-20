clc;clear all;
image=imread('figure.jpg');
image2=lowfilter(image);
%imshow(uint8(image2));
[m n]=size(image2);
h=imhist(image2);
hs = smooth(h,10);
h=fspecial('gaussian');
se1=strel('disk',3);
se2=strel('disk',2);
se3=strel('disk',4);
se4=strel('disk',5);
se5=strel('disk',1);
image2=imdilate(image2,se1);
image2=imerode(image2,se4);
%% 通过灰度均值二值化
vally = [];
for i = 2:255
    if hs(i-1) > hs(i) && hs(i+1) > hs(i) && i < 100 && i > 10
        vally = [vally i];
    end
end
for i = 1:m
    old(1,(n*(i-1)+1):n*i) = i;
    old(2,(n*(i-1)+1):n*i) = 1:n;
end
Thre = mean(vally);
for i = 1:length(old)
    if(image2(old(1,i),old(2,i)) > Thre)
        image2(old(1,i),old(2,i)) = 255;
    else
        image2(old(1,i),old(2,i)) = 0;
    end
end
%figure, imshow(image2);


image2=imdilate(image2,se1);
image2=imerode(image2,se1);
%figure, imshow(image2);
%% 提取轮廓
image3 =  edge(image2,'log');
%figure, imshow(image3);
%对轮廓初步膨胀
%image3=imdilate(image3,se2);
image3=imerode(image3,se3);
%figure, imshow(image3);
%寻找联通区
[image3,num] = bwlabel(image2);
num
%figure, imshow(image3);
%imwrite(image3,'image3.jpg','jpg');
%去除小的联通区
for i = 1:num
    if length(find(image3==i)) < 2000
        image3(find(image3==i))=0;
    else
        image3(find(image3==i))=255;
    end
end
%figure, imshow(image3);
%对剩下的联通区进一步膨胀腐蚀
image3=imdilate(image3,se3);
%image3=imerode(image3,se5);
[image4,num] = bwlabel(image3);
for i = 1:num
    if length(find(image4==i)) < 1000
        image4(find(image4==i))=0;
    else
        image4(find(image4==i))=255;
    end
end
[fin,num] = bwlabel(image4);
%figure, imshow(fin);
imwrite(fin,'image.jpg','jpg');
num
image5 = zeros(m,n);
image5(find(fin~=0)) = image(find(fin~=0));
%figure, imshow(image5);
