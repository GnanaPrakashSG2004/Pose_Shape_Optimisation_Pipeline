function kp_net_matrix = getKpNetMatrix(seq, frm, id, label_dir, kpNetOutputFile)
  kp_data_matrix = readmatrix(kpNetOutputFile);

  kp_net_matrix = zeros(14, 3, size(kp_data_matrix, 1));
  for i=1:size(kp_data_matrix, 1)
    vehicle_data = [];

    for j=1:3:40
      vehicle_data = [vehicle_data; kp_data_matrix(i, j:j+2)];
    end
    kp_net_matrix(:, :, i) = vehicle_data;
  end

  tracklet_data = getTracklets(seq, frm, id, label_dir);

  for i=1:size(kp_net_matrix, 3)
    kp_net_matrix(:, 1, i) = kp_net_matrix(:, 1, i) / 64 * abs(tracklet_data(i, 4) - tracklet_data(i, 6));
    kp_net_matrix(:, 1, i) = kp_net_matrix(:, 1, i) + tracklet_data(i, 4);

    kp_net_matrix(:, 2, i) = kp_net_matrix(:, 2, i) / 64 * abs(tracklet_data(i, 5) - tracklet_data(i, 7));
    kp_net_matrix(:, 2, i) = kp_net_matrix(:, 2, i) + tracklet_data(i, 5);
  end
end