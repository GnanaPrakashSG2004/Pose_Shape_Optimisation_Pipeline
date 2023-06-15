function kp_net_matrix = getKpNetMatrix(kpNetOutputFile)
  kp_data_matrix = readmatrix(kpNetOutputFile);

  kp_net_matrix = zeros(14, 3, size(kp_data_matrix, 1));
  for i=1:size(kp_data_matrix, 1)
    vehicle_data = [];

    for j=1:3:40
      vehicle_data = [vehicle_data; kp_data_matrix(i, j:j+2)];
    end
    kp_net_matrix(:, :, i) = vehicle_data;
  end
end