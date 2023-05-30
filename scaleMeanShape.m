function M = scaleMeanShape(M) % 14*3 matrix
  avgCarLength = 3.8600;
  avgCarWidth = 1.6362;
  avgCarHeight = 1.5208;

  % Calculating the dimensions of the mean shape
  l = max(M(:, 2)) - min(M(:, 2));
  w = max(M(:, 1)) - min(M(:, 1));
  h = max(M(:, 3)) - min(M(:, 3));

  % Scaling the dimensions of the mean shape
  M(:, 2) = M(:, 2) * avgCarLength / l;
  M(:, 1) = M(:, 1) * avgCarWidth  / w;
  M(:, 3) = M(:, 3) * avgCarHeight / h;
end