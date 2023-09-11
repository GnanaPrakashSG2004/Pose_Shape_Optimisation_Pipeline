function M = reorientMeanShape(M) % 14*3 matrix
  % M = -M; % Reversing the direction of all the coordinate axes

  % Changing the length components to the Z-axis and the height components to the Y-axis
  % X-axis remains unchanged
  M(:, [1, 3]) = M(:, [3, 1]);
  M(:, 2) = -M(:, 2);
end