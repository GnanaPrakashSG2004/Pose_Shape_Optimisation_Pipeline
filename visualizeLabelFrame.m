function visualizeLabelFrame(seq, frm, label_dir)
% label_dir directory path must be relative to './devkit/matlab' directory
% seq and frm are integers corresponding to all tracklets of the frame
% having frame number frm in the sequence seq
  meanShapeVectors = [];

  cd ./devkit/matlab/

  labels = readLabels(label_dir, seq);
  cd ../..
  for i=1:numel(labels{frm + 1})
    meanShapeVectors = [meanShapeVectors; labels{frm + 1}(i).t];
  end

  meanShapeVectors = scaleMeanShape(meanShapeVectors);
  meanShapeVectors = reorientMeanShape(meanShapeVectors);

  visualizeWireframe3D(meanShapeVectors');
end