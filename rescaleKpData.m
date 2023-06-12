function kp_matrix = rescaleKpData(seq, frm, id, label_dir, kp_matrix)
  tracklet_data = getTracklets(seq, frm, id, label_dir);

  for i=1:size(kp_matrix, 3)
    kp_matrix(:, 1, i) = kp_matrix(:, 1, i) / 64 * abs(tracklet_data(i, 4) - tracklet_data(i, 6));
    kp_matrix(:, 1, i) = kp_matrix(:, 1, i) + tracklet_data(i, 4);

    kp_matrix(:, 2, i) = kp_matrix(:, 2, i) / 64 * abs(tracklet_data(i, 5) - tracklet_data(i, 7));
    kp_matrix(:, 2, i) = kp_matrix(:, 2, i) + tracklet_data(i, 5);
  end
end