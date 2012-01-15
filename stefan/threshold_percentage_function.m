function [numbers, threshs]=threshold_percentage_function(image, image_mask, numsteps)
%

if nargin < 3
    numsteps = 100
end

threshs = 0:1/numsteps:1;

object=length(image_mask);

numbers = [];
figure
for thresh = threshs
    
    thresholded_image = im2bw(image,thresh);
        
    imshow(thresholded_image);
    drawnow;
    numbers=[numbers, length(find(thresholded_image==0))/object];    % Findet X,Y werte, die sich im schwarzen bereich befinden
end

end

