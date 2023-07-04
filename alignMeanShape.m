function [mean_shape_arr, def_vectors_arr, img_coords_arr] = alignMeanShape(seq, frm, id, label_dir, mean_shape_file, def_vector_file)
% label_dir directory path must be relative to './devkit/matlab' directory
  ry_arr = [];
  mean_shape_arr = zeros(14, 3, numel(seq));
  def_vectors_arr = zeros(5, 42, numel(seq));
  K = [
        721.53, 0, 609.55;
        0, 721.53, 172.85;
        0, 0, 1;
      ];
  img_coords_arr = zeros(14, 2, numel(seq));

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
    mean_shape_arr(:, :, i) = mean_trans;

    def_vectors_rot = zeros(5, 42);
    for j=1:3:40
      def_vectors_rot(:, j:j+2) = def_vectors(:, j:j+2) * rot_matrix; 
    end

    def_vectors_arr(:, :, i) = def_vectors_rot;

    img_coords = mean_trans * K';
    img_coords_arr(:, :, i) = [img_coords(:, 1) ./ img_coords(:, 3), img_coords(:, 2) ./ img_coords(:, 3)];
  end
end