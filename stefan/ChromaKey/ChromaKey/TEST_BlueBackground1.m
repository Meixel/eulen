% Stefan Blazek 15.01.2012
% Kyurim Rhee 2009-05-20
% Note:  The Foreground image(BLUE) must be smaller in size than the Background image(BG)


%% Einlesen der Bilder
clear all; clc; close all
BLUE = imread('Blue.jpg');  

%%Parameter

% Treshholds
Thr_RL = 39;    % Red low
Thr_RH = 90;    % Red high
Thr_GL = 70;    % Green low
Thr_GH = 125;   % Green hig
Thr_B = 175;    % Blue low
Thr_BH = 230;   % Blue high

%BLUE = imread('before.jpg');
%BLUE = imread('Green.png');     Thr_RL = 0; Thr_RH = 120;   Thr_GL = 115; Thr_GH = 170;     Thr_B = 45; Thr_BH = 110;
%BG = imread('Field.jpg');
BG = imread('Weather map.jpg'); % Hintergrund
[y,x,z] = size(BLUE);       
%BLUE = BLUE(.1*y:.7*y, .3*x:.9*x, :);
%[y,x,z] = size(BLUE);


%% Bearbeitung

shiftY = 70;   shiftX = 185;
BG_R = BG(shiftY:shiftY+y-1, shiftX:shiftX+x-1,1);  % red
BG_G = BG(shiftY:shiftY+y-1, shiftX:shiftX+x-1,2);  % green
BG_B = BG(shiftY:shiftY+y-1, shiftX:shiftX+x-1,3);  % blue
clear BG
BG(:,:,1) = BG_R;
BG(:,:,2) = BG_G;
BG(:,:,3) = BG_B;
R_BLUE = BLUE(:,:,1);
G_BLUE = BLUE(:,:,2);
B_BLUE = BLUE(:,:,3);
BackGround = BG;

%% MASKEN
% Pixelsuche innerhalb der Schwellenwerte
% index weises suche

%[x,y]= find( R_BLUE>Thr_RL && R_BLUE<Thr_RH);

ErgoRed =1-  (R_BLUE>Thr_RL & R_BLUE<Thr_RH);
figure;
imshow(ErgoRed)

ErgoGreen=1-  (G_BLUE>Thr_GL & G_BLUE<Thr_GH);
figure
imshow(ErgoGreen)

ErgoBlue=1-  (B_BLUE>Thr_B & B_BLUE<Thr_BH);
figure
imshow(ErgoBlue)


Masterergo=(ErgoRed+ErgoGreen+ErgoBlue);
figure
imshow(Masterergo)

break
%% Aufbau der Masken
for i = 1:x*y
    if R_BLUE(i)>Thr_RL && R_BLUE(i)<Thr_RH
        MaskR(i) = 1;
    else 
        MaskR(i) = 0;
    end
    if G_BLUE(i)>Thr_GL && G_BLUE(i)<Thr_GH
        MaskG(i) = 1;
    else 
        MaskG(i) = 0;
    end
    if B_BLUE(i)>Thr_B && B_BLUE(i)<Thr_BH
        MaskB(i) = 1;
    else 
        MaskB(i) = 0;
    end
end

%% Masken

MaskR = MaskR';
MaskG = MaskG';
MaskB = MaskB';
Mask = MaskR .*MaskG .* MaskB;


for j = 1:x
    MASK_R(1:y, j) = MaskR(j*y-y+1:(1+j)*y-y);
    MASK_G(1:y, j) = MaskG(j*y-y+1:(1+j)*y-y);
    MASK_B(1:y, j) = MaskB(j*y-y+1:(1+j)*y-y);    
    MASK(1:y, j)   = Mask(j*y-y+1:(1+j)*y-y);    
end
MaskR = MASK_R;
MaskG = MASK_G;
MaskB = MASK_B;
Mask = MASK;
MASK_R = uint8(MASK_R);
MASK_G = uint8(MASK_G);
MASK_B = uint8(MASK_B);
MASK = uint8(MASK);

%MASK = MASK_R .* MASK_G .* MASK_B;

BG(:,:,1) = MASK .* BG(:,:,1);    
BG(:,:,2) = MASK .* BG(:,:,2);    
BG(:,:,3) = MASK .* BG(:,:,3);    

Mask_FG = abs(Mask - 1);
MASK_FG = uint8(Mask_FG);    
FG(:,:,1) = MASK_FG .* BLUE(:,:,1);    
FG(:,:,2) = MASK_FG .* BLUE(:,:,2);    
FG(:,:,3) = MASK_FG .* BLUE(:,:,3);    

FImage = FG + BG;

figure(1)
subplot(431); imshow(BLUE); title({('Original Image')}); ylabel('RGB'); 
subplot(432); imhist(RGB2gray(BLUE)); title({('Chroma Key');('');('Histogram')}); ylabel('grayscale')   
subplot(433); imshow(Mask); title('Mask'); ylabel('Final Mask')
subplot(434); imshow(R_BLUE); ylabel('Red');     subplot(435); imhist(R_BLUE);    subplot(436); imshow(MaskR); ylabel('Mask using Red Component')
subplot(437); imshow(G_BLUE); ylabel('Green');   subplot(438); imhist(G_BLUE);    subplot(439); imshow(MaskG); ylabel('Mask using Green Component')
subplot(4,3,10); imshow(B_BLUE); ylabel('Blue'); subplot(4,3,11); imhist(B_BLUE); subplot(4,3,12); imshow(MaskB); ylabel('Mask using Blue Component')

figure(2)
subplot(421); imshow(BLUE);         ylabel('Original Foreground Image'); title('ForeGround')
subplot(422); imshow(BackGround);   ylabel('Original Background Image'); title('BackGround')
subplot(423); imshow(Mask);         ylabel('Foreground Mask')
subplot(424); imshow(Mask_FG);       ylabel('Background Mask')
subplot(425); imshow(FG);           ylabel('Chroma Keyed Foreground')
subplot(426); imshow(BG);           ylabel('Chroma Keyed Background')
subplot(414); imshow(FImage);       title('Chroma Keyed Final Image');

figure(3)
imshow(FImage); title('Chroma Keyed Final Image')

figure(4)
subplot(221); imshow(BLUE); title('Original Foreground Image');
subplot(222); imshow(BackGround); title('Original Background Image');
subplot(212); imshow(FImage); title('Chroma Keyed Image');