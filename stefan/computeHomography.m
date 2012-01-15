function H=computeHomography(x1y1s, x2y2s)

A = computeEstimationMatrix(x1y1s, x2y2s)

[U,S,V] = svd(A)

H = V(:, end)
H = reshape(H, 3, 3)'
end



function EstimationMatrix = computeEstimationMatrix(x1y1s, x2y2s)
% computes homography estimationmatrix given at least 4 points

if size(x1y1s, 2) ~= size(x2y2s, 2)
    error('incompatible sizes');
end

EstimationMatrix = [];

for i=1:size(x1y1s, 2)
    x1y1 = x1y1s(:, i);
    x2y2 = x2y2s(:, i);
    
    EstimationMatrix = [EstimationMatrix; computeOneLine(x1y1, x2y2)];
end

end



function lines = computeOneLine(x1y1, x2y2)
% computes two lines of the homography estimation matrix

x1 = x1y1(1);
y1 = x1y1(2);

x2 = x2y2(1);
y2 = x2y2(2);

line_one = [x1 y1 1 0 0 0 -x2*x1 -x2*y1 -x2];

line_two = [0 0 0 x1 y1 1 -y2*x1 -y2*y1 -y2];

lines = [line_one; line_two]
end