function trackletFields = getTracklets(seq, frm, id, label_dir)
% label_dir directory path must be relative to './devkit/matlab' directory

trackletFields = [];

cd ./devkit/matlab

for i=1:numel(seq)
  labels = readLabels(label_dir, seq(i));
  frmObjects = labels{frm(i) + 1}; % All tracklets of the sequence having the required frame number

  for j=1:numel(frmObjects)
    if frmObjects(j).id == id(i)
      bbox_x1   = frmObjects(j).x1;
      bbox_y1   = frmObjects(j).y1;
      bbox_x2   = frmObjects(j).x2;
      bbox_y2   = frmObjects(j).y2;
      ry        = frmObjects(j).ry;
      t         = frmObjects(j).t;
      trackletFields = [trackletFields; seq(i), frm(i), id(i), bbox_x1, bbox_y1, bbox_x2, bbox_y2, ry, t];
    end
  end
end

cd ../../

end