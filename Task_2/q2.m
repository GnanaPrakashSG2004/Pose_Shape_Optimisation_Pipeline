% Changing the mean shape vector
M = readmatrix('meanShape.txt');

l = max(M(:, 2)) - min(M(:, 2));
w = max(M(:, 1)) - min(M(:, 1));
h = max(M(:, 3)) - min(M(:, 3));

M(:, 2) = M(:, 2) * 3.8600 / l;
M(:, 1) = M(:, 1) * 1.6362 / w;
M(:, 3) = M(:, 3) * 1.5208 / h;

M = -M;
M(:, [2, 3]) = M(:, [3, 2]);
writematrix(M, 'updatedMeanShape.txt', 'Delimiter', 'space');

visualizeWireframe3D(M');

% Changing the deformation vectors
DV = readmatrix('vectors.txt');

DV(:, 2) = DV(:, 2) * 3.8600 / l;
DV(:, 1) = DV(:, 1) * 1.6362 / w;
DV(:, 3) = DV(:, 3) * 1.5208 / h;

DV = -DV;
for swapCol = 2:3:41
    DV(:, [swapCol, swapCol + 1]) = DV(:, [swapCol + 1, swapCol]);
end

writematrix(DV, 'updatedVectors.txt', 'Delimiter', 'space');