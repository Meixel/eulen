clc;
clear all;
close all;

%% Zuallererst die vl_setup.m ausführen!!!

%% Ort des Classifiers
%path('C:\Users\stefan\Documents\Doktorarbeit\Matlab\Pattern Recognition\ClassifierManifoldLearn');

%addpath(path);

%% Einlesen von Einzelbildern

%I = imread('Fluegel.jpg');
%I = imread('Federgreen.jpg');
%I = imread('Dach.jpg');
%I = imread('Feder.jpg');
% I2=I;
% I = single(rgb2gray(I));

%% Bildpaar

I=imread('quiselfedermask.jpg');
Ib=I;
I2=imread('quiselfluegelmaske.jpg');
I2b=I2;
I = single(rgb2gray(I));
I2 = single(rgb2gray(I2));




%[f,d]=vl_sift(I);  % Normale Berechnung
%% Einstellungen für detector
%   opt_octaves = 0
%   opt_levels,
%   opt_first_octave,
%   opt_frames,
%   opt_edge_thresh,
%   opt_peak_thresh,
%   opt_norm_thresh,
%   opt_magnif,
%   opt_window_size,
%   opt_orientations,
%   opt_float_descriptors,
%   opt_verbose


%% Feature Extraktion
octaves=2;          % 1
levels=7;           % 5
[f,d]=vl_sift(I2,'Levels',levels,'Octaves', octaves) ;

[f2,d2]=vl_sift(I,'Levels',levels,'Octaves', octaves) ;
% peak threshhold
%peak_thresh=9;
% [f2,d2]=vl_sift(I2,'PeakThresh', peak_thresh) ;
% [f,d]=vl_sift(I,'PeakThresh', peak_thresh) ;


% edge thresh hold
% edge_thresh=1;
% [f,d] = vl_sift(I, 'edgethresh', edge_thresh) ;
 






%% Filterung der Keypoints

% Alle Keypunkte mit einem Radius kleiner als 9 pixel

 fsmall=f(:,find(f(3,:)<=9));

% fsmall2=f2(:,find(f2(3,:)<=30));

% Hintergrund extraktion

% Fluegel
option=0.99; % Muster= 0.9   Komplette Fluegel = 0.99 
[fOn,dOn, Mask_Wing]=backgroundextractor(I2b,fsmall,d,option);

% Feder
option=0.9;  % Muster= 0.4   Komplette Fer = 0.9
[fOn2,dOn2, Mask_feather]=backgroundextractor(Ib,f2,d2,option);


%% Muster Extraction


close all;
numsteps=50;
threshs = 0:1/numsteps:0.35;
numbers = [];
object=length(Mask_feather);

for thresh = threshs
    
    thresholded_image = im2bw(Ib,thresh);
    Q=find(thresholded_image==0)/object;   
    imshow(thresholded_image);
    drawnow;
    numbers=[numbers, length(find(thresholded_image==0))/object];    % Findet X,Y werte, die sich im schwarzen bereich befinden
end
% [numbers, threshs]=threshold_percentage_function(I, Mask_feather, numsteps)
figure;
plot(threshs, numbers)


break

%% Distance

Distances=distance(double(dOn(:, :)), double(dOn2(:, :)))

[S, Indices] = sort(Distances, 1)

lowest_distances = S(1, :) %Distances(find(I==1))
second_lowest_distances = S(2, :) %Distances(find(I==2))

distance_ratios = lowest_distances ./ second_lowest_distances

interesting_points = find(distance_ratios < 0.99)

interesting_columns = Indices(:, interesting_points)

[interesting_rows, the_same_interesting_columns] = find(interesting_columns == 1)

feather_points_xy = fOn2(1:2, interesting_points)
wing_points_xy = fOn(1:2, interesting_rows')


H = computeHomography(feather_points_xy, wing_points_xy)







%% Visuelle Ausgabe der Daten

% Bild 1
% perm = randperm(size(f,2)) ; 
% sel = perm(1:50) ;
figure;
imshow(I2b)
hold on;
% h1 = vl_plotframe(f(:,sel)) ; 
% h2 = vl_plotframe(f(:,sel)) ; 
h1 = vl_plotframe(fOn(:,:)) ; 
h2 = vl_plotframe(fOn(:,:)) ; 



set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

hold off;

%% Bild2

figure;
imshow(Ib)
hold on;
% h1 = vl_plotframe(f(:,sel)) ; 
% h2 = vl_plotframe(f(:,sel)) ; 
h3 = vl_plotframe(fOn2(:,:)) ; 
h4 = vl_plotframe(fOn2(:,:)) ; 
set(h3,'color','k','linewidth',3) ;
set(h4,'color','y','linewidth',2) ;
hold off;



% Both images

figure;

Rows=max(size(I,1),size(I2,1))
Cols=(size(I,2) + size(I2,2))

Double_Image=zeros(Rows,Cols)

Double_Image(1:size(I,1),1:size(I,2))=I
Double_Image(1:size(I2,1),size(I,2)+1:size(I,2)+size(I2,2))=I2


imagesc(Double_Image)
colormap gray


for i=1:size(feather_points_xy, 2)
    xf = feather_points_xy(1, i)
    yf = feather_points_xy(2, i)
    
    xw = wing_points_xy(1, i)
    yw = wing_points_xy(2, i)
    
    line([xf, xw+size(I,2)], [yf, yw], 'color', 'y')
end



%[matches, scores] = vl_ubcmatch(d, d2) ;


%h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;  
%set(h3,'color','g') ;