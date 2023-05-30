function visualizeScaling(meanShapeFile)
  tiledlayout(2, 1);
  M = readmatrix(meanShapeFile); % 14*3 matrix

  nexttile;
  visualizeWireframe3D(M'); % The mean shape before scaling the dimensions
  title('Before scaling');

  M = scaleMeanShape(M);    % Scaling the mean shape vector

  nexttile;
  visualizeWireframe3D(M'); % The mean shape after scaling the dimensions
  title('After scaling');
end