function [mean_shape_arr, def_vectors_arr, img_coords_arr] = alignMeanShape(seq, frm, id, label_dir, mean_shape_file, def_vector_file)
% label_dir directory path must be relative to './devkit/matlab' directory
  ry_arr = [];
  mean_shape_arr = [];
  def_vectors_arr = [];
  K = [
        721.53, 0, 609.55;
        0, 721.53, 172.85;
        0, 0, 1;
      ];
  img_coords_arr = [];

  [B, ~] = mobili(seq, frm, id, label_dir);
  offset_angle = pi/2;
  tracklet_data = getTracklets(seq, frm, id, label_dir);
  ry_arr = [ry_arr; tracklet_data(:, 8) + offset_angle];
  
  
  mean_shape = readmatrix(mean_shape_file);
  mean_shape = reorientMeanShape(scaleMeanShape(mean_shape));
  
  def_vectors = reorientDeformationVectors(def_vector_file);
  
  for i=1:numel(ry_arr)
    rot_matrix = [cos(ry_arr(i)), 0, sin(ry_arr(i)); 0, 1, 0; -sin(ry_arr(i)), 0, cos(ry_arr(i))];
    mean_rot = mean_shape * rot_matrix;
    mean_trans = mean_rot + B(i, :);
    mean_shape_arr = [mean_shape_arr; mean_trans];
    
    % for j=1:3:40
    %   x_def_rot = [x_def_rot, def_vectors(:, j) * cos(ry_arr(i)) + def_vectors(:, j + 2) * sin(ry_arr(i))];
    %   y_def = [y_def, def_vectors(:, j + 1)];
    %   z_def_rot = [z_def_rot, def_vectors(:, j + 2) * cos(ry_arr(i)) - def_vectors(:, j) * sin(ry_arr(i))];
    % end
    % for j=1:14
    %   def_vectors_rot = [def_vectors_rot, x_def_rot(:, j), y_def(:, j), z_def_rot(:, j)];
    % end
    % def_vectors_arr = [def_vectors_arr; def_vectors_rot];

    img_coords = mean_trans * K';
    img_coords_arr = [img_coords_arr; img_coords(:, 1) ./ img_coords(:, 3), img_coords(:, 2) ./ img_coords(:, 3)];
    disp(img_coords_arr)
  end
end