Clc;
close all;
clear all;
i=imread('test1.JPG');
I=rgb2gray(i);
LEN=31;
THETA=11;
PSF=fspecial('motion',LEN,THETA);
blurred=imfilter(I,PSF,'circular','conv');
figure,imshow(blurred);
title('blurred image');
fspecial('gaussian',[5 5],0.5);
k = deconvwnr(blurred, PSF);
figure,imshow(k);
title('sharped image');
imagen=k;
% Convert to gray scale
if size(imagen,3)==3 %RGB image
	imagen=rgb2gray(imagen);
figure(2)
imshow(imagen)
end
% Convert to BW
threshold = graythresh(imagen);
imagen =~im2bw(imagen,threshold);
figure(3)
imshow(imagen)
% Remove all object containing fewer than 30 pixels
imagen = bwareaopen(imagen,2);
figure(4);imshow(imagen)
%Storage matrix word from image
word=[ ];
re=imagen;
%Opens text.txt as file for write
fid = fopen('text.txt', 'wt');
load templates
global templates
% Compute the number of letters in template file
num_letras=size(templates,2);
while 1
	%Fcn 'lines' separate lines in text
	[fl re]=lines(re);
	imgn=fl;
	figure(5)
	imshow(fl);pause(0.5)
	% Label and count connected components
 	[L Ne] = bwlabel(imgn);
 	for n=1:Ne
 		[r,c] = find(L==n);
 		% Extract letter
		n1=imgn(min(r):max(r),min(c):max(c));
 		% Resize letter (same size of template)
 		img_r=imresize(n1,[42 24]);
 		figure(6);imshow(img_r);pause(0.5)
 		%-------------------------------------------------------------------
 		% Call fcn to convert image to text
 		letter=read_letter(img_r,num_letras);
 		% Letter concatenation
 		word=[word letter];
 	end
 	fprintf(fid,'%s\n',word);%Write 'word' in text file (upper)
 	% Clear 'word' variable
 	word=[ ];
 	%*When the sentences finish, breaks the loop
 	if isempty(re) %See variable 're' in Fcn 'lines'
 		break
 	end
end
fclose(fid);
%Open 'text.txt' file
winopen('text.txt')