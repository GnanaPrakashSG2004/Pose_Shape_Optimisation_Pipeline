function [W, Wkpl, Wkps] = kpWeights(seq, frm, id, label_dir, kpNetOutputFile, kpLookupFile)
  [kpNetOutput, seq_frm_id] = getKpNetMatrix(seq, frm, id, label_dir, kpNetOutputFile);

  tracklet_data = getTracklets(seq, frm, id, label_dir);
  ry = rad2deg(tracklet_data(:, 8) + pi/2)';
  ry_int = round(ry);

  Wkps = [];
  for i=1:numel(ry_int)
    Wkps = [Wkps, kpNetOutput(:, 3, i)];
  end

  seq = seq_frm_id(:, 1)';
  frm = seq_frm_id(:, 2)';
  id  = seq_frm_id(:, 3)';
  
  kpLookupMat = getKpLookup(kpLookupFile);

  Wkpl = [];
  for i=1:numel(ry_int)
    azimuth_angle = ry_int(i);
    if azimuth_angle <= 0 
      azimuth_angle = 360 - abs(azimuth_angle); 
    end
    Wkpl = [Wkpl, kpLookupMat(:, azimuth_angle) ./ sum(kpLookupMat(:, azimuth_angle))];
  end

  W = 0.3 * Wkps + 0.7 * Wkpl;
  min = 0.001;
  [r,c] = find(W < min);
  for i=1:length(r)
      W(r(i), c(i)) = min;
  end
end