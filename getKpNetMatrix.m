function [kp_net_matrix, seq_frm_id] = getKpNetMatrix(seq, frm, id, label_dir, kpNetOutputFile)
  kp_data_matrix = readmatrix(kpNetOutputFile);

  info = importdata("infofile.txt");
  indices = [];
  seq_frm_id = [];
  for i=1:size(seq,2)
      index = find(info(:,2) == seq(i) & info(:,3) == frm(i) & info(:,4) == id(i));
      indices = [indices; index];
      seq_frm_id = [seq_frm_id; info(index,2) info(index,3) info(index,4)];
  end

  kp_data = [];
  for i=1:size(indices, 1)
    kp_data = [kp_data; kp_data_matrix(indices(i), :)];
  end

  kp_net_matrix = zeros(36, 3, size(kp_data, 1));
  for i=1:numel(seq)
    vehicle_data = [];

    for j=1:3:106
      vehicle_data = [vehicle_data; kp_data(i, j:j+2)];
    end
    kp_net_matrix(:, :, i) = vehicle_data;
  end

  tracklet_data = getTracklets(seq, frm, id, label_dir);

  for i=1:size(kp_net_matrix, 3)
    kp_net_matrix(:, 1, i) = (kp_net_matrix(:, 1, i) * abs(tracklet_data(i, 4) - tracklet_data(i, 6))) / 64;
    kp_net_matrix(:, 1, i) = kp_net_matrix(:, 1, i) + tracklet_data(i, 4);

    kp_net_matrix(:, 2, i) = (kp_net_matrix(:, 2, i) * abs(tracklet_data(i, 5) - tracklet_data(i, 7))) / 64;
    kp_net_matrix(:, 2, i) = kp_net_matrix(:, 2, i) + tracklet_data(i, 5);
  end
end