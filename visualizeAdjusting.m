function visualizeAdjusting(meanShapeFile)
  tiledlayout(2, 1);
  M = readmatrix(meanShapeFile); % 14*3 matrix
  M = scaleMeanShape(M); % Scaling the mean shape vector

  nexttile;
  visualizeWireframe3D(M'); % Before adjustment of the orientation
  title('Before reorientation');

  M = reorientMeanShape(M); % Reorienting the mean shape vector

  nexttile;
  visualizeWireframe3D(M'); % After adjustment of the orientation
  title('After reorientation');
end