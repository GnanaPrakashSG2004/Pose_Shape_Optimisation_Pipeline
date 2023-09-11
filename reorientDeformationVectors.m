function DV = reorientDeformationVectors(vectorsFile, meanShape) % 5*42 matrix
  avgCarLength = 3.8600;
  avgCarWidth = 1.6362;
  avgCarHeight = 1.5208;

  % Calculating the dimensions of the mean shape
  l = norm((meanShape(18, :) + meanShape(36, :))/2 - (meanShape(11, :) + meanShape(29, :))/2);
  w = norm(meanShape(7, :) - meanShape(25, :));
  h = norm((meanShape(15, :) + meanShape(14, :) + meanShape(33, :) + meanShape(32, :))/4 - (meanShape(6, :) + meanShape(7, :) + meanShape(25, :) + meanShape(24, :))/4);
  
  DV = readmatrix(vectorsFile); % 5*42 matrix
  % DV = -DV; % Reversing all the coordinate axes

  % Changing the length components to the Z-axis and the height components to the Y-axis
  % X-axis remains unchanged
  for swapCol = 1:3:106
    DV(:, swapCol)     = DV(:, swapCol)     * avgCarLength / l;
    DV(:, swapCol + 2) = DV(:, swapCol + 2) * avgCarWidth  / w;
    DV(:, swapCol + 1) = DV(:, swapCol + 1) * avgCarHeight / h;
    
    DV(:, [swapCol, swapCol + 2]) = DV(:, [swapCol + 2, swapCol]);
    DV(:, swapCol + 1) = -DV(:, swapCol + 1);
  end
end