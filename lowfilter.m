function I3 = lowfilter(I)
h1=fspecial('average',[1001 1001]);
I1=imfilter(I,h1,'replicate');
I3=abs(I1-I);
figure, imshow(I3);
end