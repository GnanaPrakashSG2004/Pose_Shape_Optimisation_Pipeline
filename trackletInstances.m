function trackletInstances = trackletInstances(seq, frm, id, label_dir)
% label_dir directory path must be relative to './devkit/matlab' directory

trackletInstances = getTracklets(seq, frm, id, label_dir);
trackletInstances(:, 9:11) = []; % Removing the translation vector details

end