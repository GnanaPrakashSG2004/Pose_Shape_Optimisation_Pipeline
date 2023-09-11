function shape_optimized_wireframe_img_coords = ceresShapeOptimizer(seq, frm, id, label_dir, kpNetOutputFile, kpLookupFile, mean_shape_file, def_vector_file)
% label_dir directory path must be relative to './devkit/matlab' directory
  numViews = 1;
  numPts   = 36;
  numObs   = 36;

  [carCenterArr, ~] = mobili(seq, frm, id, label_dir);

  avgCarLength = 3.8600;
  avgCarWidth  = 1.6362;
  avgCarHeight = 1.5208;

  K = [
        721.53, 0, 609.55;
        0, 721.53, 172.85;
        0, 0, 1;
      ];
  Kflat = reshape(K', [], 1);

  kpNetMatrix = getKpNetMatrix(seq, frm, id, label_dir, kpNetOutputFile);
  observationVector = kpNetMatrix(:, 1:2, :);

  observationWeights = kpWeightsShape(seq, frm, id, label_dir, kpNetOutputFile, kpLookupFile);

  [meanLocationArr, defVectorArr] = alignMeanShape(seq, frm, id, label_dir, mean_shape_file, def_vector_file);

  [~, trans_matrices, rot_matrices] = ceresPoseOptimizer(seq, frm, id, label_dir, kpNetOutputFile, kpLookupFile, mean_shape_file, def_vector_file);

  lambdas = [0.0208000000000000,0.00970000000000000,0.00720000000000000,0.00570000000000000,0.00470000000000000,0.00330000000000000,0.00210000000000000,0.00160000000000000,0.00100000000000000,0.000900000000000000,0.000800000000000000,0.000800000000000000,0.000700000000000000,0.000600000000000000,0.000500000000000000,0.000500000000000000,0.000400000000000000,0.000400000000000000,0.000400000000000000,0.000300000000000000,0.000300000000000000,0.000300000000000000,0.000300000000000000,0.000300000000000000,0.000200000000000000,0.000200000000000000,0.000200000000000000,0.000200000000000000,0.000200000000000000,0.000200000000000000,0.000200000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000];

  shape_optimized_wireframe = zeros(36, 3, numel(seq));
  shape_optimized_wireframe_img_coords = zeros(36, 2, numel(seq));

  for i=1:numel(seq)
    ceresInputID = fopen("ceres/ceres_input_singleViewShapeAdjuster.txt", "w");
      fprintf(ceresInputID, "%d %d %d\n", numViews, numPts, numObs);
      fprintf(ceresInputID, "%f ", carCenterArr(i, :)); fprintf(ceresInputID, "\n");
      fprintf(ceresInputID, "%f %f %f\n", avgCarHeight, avgCarWidth, avgCarLength);
      fprintf(ceresInputID, "%f ", Kflat); fprintf(ceresInputID, "\n");
      for j=1:numObs
        fprintf(ceresInputID, "%f ", observationVector(j, :, i)); fprintf(ceresInputID, "\n");
      end
      fprintf(ceresInputID, "%f\n", observationWeights(:, i));
      for j=1:numObs
        fprintf(ceresInputID, "%f ", meanLocationArr(j, :, i)); fprintf(ceresInputID, "\n");
      end
      for j=1:42
        fprintf(ceresInputID, "%f ", defVectorArr(j, :, i)); fprintf(ceresInputID, "\n");
      end
      fprintf(ceresInputID, "%f ", lambdas(:)); fprintf(ceresInputID, "\n");
      for j=1:3
        fprintf(ceresInputID, "%f\n", rot_matrices(j, :, i));
      end
      fprintf(ceresInputID, "%f\n", trans_matrices(:, :, i));
    fclose(ceresInputID);

    cd ceres/;
    system("./singleViewShapeAdjuster");
    optimized_wireframe = importdata("ceres_output_singleViewShapeAdjuster.txt");
    cd ../;

    shape_optimized_wireframe(:, :, i) = optimized_wireframe * K';
    shape_optimized_wireframe_img_coords(:, :, i) = [shape_optimized_wireframe(:, 1, i) ./ shape_optimized_wireframe(:, 3, i), shape_optimized_wireframe(:, 2, i) ./ shape_optimized_wireframe(:, 3, i)];
  end
end