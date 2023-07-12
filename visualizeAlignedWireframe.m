function visualizeAlignedWireframe(seq, frm, id, label_dir, mean_shape_file, def_vector_file)
% label_dir directory path must be relative to './devkit/matlab' directory
  [~, ~, img_coords_arr] = alignMeanShape(seq, frm, id, label_dir, mean_shape_file, def_vector_file);
  for i=1:size(img_coords_arr, 3)
    img_path = sprintf("./Left_Colour_Images/%d_%d.png", seq(i), frm(i));
    visualizeWireframe2D(img_path, img_coords_arr(:, :, i)');
    pause(2);
  end
end