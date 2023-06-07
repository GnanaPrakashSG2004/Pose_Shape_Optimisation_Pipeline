function visualizeAdjusting(meanShapeData)
% meanShapeData can be either of type string or can be given as a matrix
  tiledlayout(2, 1);
  M = [];
  

  if ischar(meanShapeData)
    M = readmatrix(meanShapeData);  % 14*3 matrix
  elseif isnumeric(meanShapeData)
    M = meanShapeData;              % 14*3 matrix
  end
  M = scaleMeanShape(M);    % Scaling the mean shape vector

  nexttile;
  visualizeWireframe3D(M'); % Before adjustment of the orientation
  title('Before reorientation');

  M = reorientMeanShape(M); % Reorienting the mean shape vector

  nexttile;
  visualizeWireframe3D(M'); % After adjustment of the orientation
  title('After reorientation');
end