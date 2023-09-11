function M = scaleMeanShape(M) % 14*3 matrix
  avgCarLength = 3.8600;
  avgCarWidth = 1.6362;
  avgCarHeight = 1.5208;

  % Calculating the dimensions of the mean shape
  l = norm((M(18, :) + M(36, :))/2 - (M(11, :) + M(29, :))/2);
  w = norm(M(7, :) - M(25, :));
  h = norm((M(15, :) + M(14, :) + M(33, :) + M(32, :))/4 - (M(6, :) + M(7, :) + M(25, :) + M(24, :))/4);

  % Scaling the dimensions of the mean shape
  M(:, 1) = M(:, 1) * avgCarLength / l;
  M(:, 3) = M(:, 3) * avgCarWidth  / w;
  M(:, 2) = M(:, 2) * avgCarHeight / h;
end