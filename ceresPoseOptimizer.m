function pose_optimized_wireframe = ceresPoseOptimizer(seq, frm, id, label_dir, kpNetOutputFile, kpLookupFile, mean_shape_file, def_vector_file)
% label_dir directory path must be relative to './devkit/matlab' directory
  numViews = 1;
  numPts   = 14;
  numObs   = 14;

  [carCenterArr, ~] = mobili(seq, frm, id, label_dir);

  avgCarLength = 3.8600;
  avgCarWidth  = 1.6362;
  avgCarHeight = 1.5208;

  K = [
        721.53, 0, 609.55;
        0, 721.53, 172.85;
        0, 0, 1;
      ];
  K = reshape(K', [], 1);

  kpNetMatrix = getKpNetMatrix(seq, frm, id, label_dir, kpNetOutputFile);
  observationVector = kpNetMatrix(:, 1:2, :);

  observationWeights = kpWeights(seq, frm, id, label_dir, kpNetOutputFile, kpLookupFile);

  [meanLocationArr, defVectorArr] = alignMeanShape(seq, frm, id, label_dir, mean_shape_file, def_vector_file);

  lambdas = [0.250000 0.270000 0.010000 -0.080000 -0.050000];

  pose_optimized_wireframe = zeros(14, 3, numel(seq));

  for i=1:numel(seq)
    ceresInputID = fopen("ceres/ceres_input_singleViewPoseAdjuster.txt", "w");
      fprintf(ceresInputID, "%d %d %d\n", numViews, numPts, numObs);
      fprintf(ceresInputID, "%f ", carCenterArr(i, :)); fprintf(ceresInputID, "\n");
      fprintf(ceresInputID, "%f %f %f\n", avgCarHeight, avgCarWidth, avgCarLength);
      fprintf(ceresInputID, "%f ", K); fprintf(ceresInputID, "\n");
      for j=1:numObs
        fprintf(ceresInputID, "%f ", observationVector(j, :, i)); fprintf(ceresInputID, "\n");
      end
      fprintf(ceresInputID, "%f\n", observationWeights(:, i));
      for j=1:numObs
        fprintf(ceresInputID, "%f ", meanLocationArr(j, :, i)); fprintf(ceresInputID, "\n");
      end
      for j=1:5
        fprintf(ceresInputID, "%f ", defVectorArr(j, :, i)); fprintf(ceresInputID, "\n");
      end
      fprintf(ceresInputID, "%f ", lambdas(:)); fprintf(ceresInputID, "\n");
    fclose(ceresInputID);

    cd ceres/;
    system("./singleViewPoseAdjuster");
    optimizerOutput = importdata("ceres_output_singleViewPoseAdjuster.txt");
    cd ../;
    
    rotMatrix = reshape(optimizerOutput(1:9), 3, 3);
    transMatrix = optimizerOutput(10:12);
    optimized_wireframe = (meanLocationArr(:, :, i) * rotMatrix) + transMatrix;
    pose_optimized_wireframe(:, :, i) = [optimized_wireframe(:, 1) ./ optimized_wireframe(:, 3), optimized_wireframe(:, 2) ./ optimized_wireframe(:, 3)];
  end
end