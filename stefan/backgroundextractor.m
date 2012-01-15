function [fOn,dOn, Mask]=backgroundextractor(I,f,d,option)
%% this function extractes all keypoints detected on the background
%
%% Input
%   I= RGB image
%   f= keypoint matrix (4 x n)
%   d= descriptor matrix (128 x n)
%
%% Output
% fOn= keypoints on the feather
% dOn= descriptors on the feather

interest=fix(f(1:2,:)'); % Extraktion der XY Koordinaten aus der Keypointliste


BW=im2bw(I,option);       %% 1= white; 0=black
%imshow(BW)

[yb,xb]=find(BW==0);    % Findet X,Y werte, die sich im schwarzen bereich befinden
Mask=[xb yb];           % XY Coordinates on the feather

[onfeather]= ismember(interest,Mask,'rows');

fOn=f(:,find(onfeather==1));
dOn=d(:,find(onfeather==1));