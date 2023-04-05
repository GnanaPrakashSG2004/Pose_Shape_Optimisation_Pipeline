% Changing the mean shape vector
% Reading from the unscaled vector as the length is needed to scale the
% vectors in the vectors.txt file also
M = readmatrix('meanShape.txt');

l = max(M(:, 2)) - min(M(:, 2));
w = max(M(:, 1)) - min(M(:, 1));
h = max(M(:, 3)) - min(M(:, 3));

M(:, 2) = M(:, 2) * 3.8600 / l;
M(:, 1) = M(:, 1) * 1.6362 / w;
M(:, 3) = M(:, 3) * 1.5208 / h;

% Reversing the direction of all the coordinate axes
M = -M;

% Swapping the Y and Z axes to adjust according to the direction of the
% camera, which is aligned in such a way that the direction of Length
% (Tailight to Headlight) is along the Z-axis, the Width (Left side to
% Right side) is aligned along the +ve X-axis and the Height (Top to
% Bottom) is aligned along the +ve Y-axis
M(:, [2, 3]) = M(:, [3, 2]);

writematrix(M, 'updatedMeanShape.txt', 'Delimiter', 'space');

visualizeWireframe3D(M');

% Changing the deformation vectors
DV = readmatrix('vectors.txt');

DV(:, 2) = DV(:, 2) * 3.8600 / l;
DV(:, 1) = DV(:, 1) * 1.6362 / w;
DV(:, 3) = DV(:, 3) * 1.5208 / h;

% Reversing all the coordinate axes
DV = -DV;

% Swapping the Y and Z coordinates of each coordinate, i.e., the 2nd and
% 3rd coordinates for every 3-pair
for swapCol = 2:3:41
    DV(:, [swapCol, swapCol + 1]) = DV(:, [swapCol + 1, swapCol]);
end

writematrix(DV, 'updatedVectors.txt', 'Delimiter', 'space');