M = readmatrix('meanShape.txt');
tiledlayout(2, 1);

% The mean shape before scaling the dimensions
nexttile;
visualizeWireframe3D(M');
title('Before adjustment');

% Calculating the dimensions of the mean shape
l = max(M(:, 2)) - min(M(:, 2));
w = max(M(:, 1)) - min(M(:, 1));
h = max(M(:, 3)) - min(M(:, 3));

fprintf('Dimensions of the vehicle:\n\nLength: %f\nWidth: %f\nHeight: %f\n\n', l, w, h);

% Scaling the dimensions of the mean shape
M(:, 2) = M(:, 2) * 3.8600 / l;
M(:, 1) = M(:, 1) * 1.6362 / w;
M(:, 3) = M(:, 3) * 1.5208 / h;

writematrix(M, 'scaledMeanShape.txt', 'Delimiter', 'space');

nexttile;
visualizeWireframe3D(M');
title('After adjustment');