% Changing the mean shape vector
M = readmatrix('meanShape.txt');
M = -M;
M(:, [2, 3]) = M(:, [3, 2]);
writematrix(M, 'updatedMeanShape.txt', 'Delimiter', 'space');

visualizeWireframe3D(M');

% Changing the deformation vectors
DV = readmatrix('vectors.txt');
DV = -DV;
for swapCol = 2:3:41
    DV(:, [swapCol, swapCol + 1]) = DV(:, [swapCol + 1, swapCol]);
end

writematrix(DV, 'updatedVectors.txt', 'Delimiter', 'space');