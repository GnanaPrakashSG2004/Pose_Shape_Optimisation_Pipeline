function W = kpWeights(seq, frm, id, label_dir, kpNetOutputFile, kpLookupFile)
  tracklet_data = getTracklets(seq, frm, id, label_dir);
  ry = rad2deg(tracklet_data(:, 8) + pi/2)';
  ry_int = round(ry);

  kpNetOutput = getKpNetMatrix(seq, frm, id, label_dir, kpNetOutputFile);
  Wkps = [];
  for i=1:numel(ry_int)
    Wkps = [Wkps, kpNetOutput(:, 3, i)];
  end

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
end