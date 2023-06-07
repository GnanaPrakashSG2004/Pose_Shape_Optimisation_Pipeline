function visualizeScaling(meanShapeData)
% meanShapeData can be either of type string or can be given as a matrix
  tiledlayout(2, 1);
  
  if ischar(meanShapeData)
    M = readmatrix(meanShapeData);  % 14*3 matrix
  elseif isnumeric(meanShapeData)
    M = meanShapeData;              % 14*3 matrix
  end

  nexttile;
  visualizeWireframe3D(M'); % The mean shape before scaling the dimensions
  title('Before scaling');

  M = scaleMeanShape(M);    % Scaling the mean shape vector

  nexttile;
  visualizeWireframe3D(M'); % The mean shape after scaling the dimensions
  title('After scaling');
end