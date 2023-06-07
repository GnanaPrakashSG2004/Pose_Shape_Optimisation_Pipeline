function visualizeAlignedWireframe(seq, frm, id, label_dir, mean_shape_file, def_vector_file, img_path)
% label_dir directory path must be relative to './devkit/matlab' directory
  [~, ~, img_coords_arr] = alignMeanShape(seq, frm, id, label_dir, mean_shape_file, def_vector_file);
  visualizeWireframe2D(img_path, img_coords_arr');
end