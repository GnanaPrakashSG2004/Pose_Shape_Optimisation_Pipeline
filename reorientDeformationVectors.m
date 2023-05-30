function DV = reorientDeformationVectors(vectorsFile) % 5*42 matrix
  DV = readmatrix(vectorsFile); % 5*42 matrix
  DV = -DV; % Reversing all the coordinate axes

  % Changing the length components to the Z-axis and the height components to the Y-axis
  % X-axis remains unchanged
  for swapCol = 2:3:41
    DV(:, [swapCol, swapCol + 1]) = DV(:, [swapCol + 1, swapCol]); 
  end
end