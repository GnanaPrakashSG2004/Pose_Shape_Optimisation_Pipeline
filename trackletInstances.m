function trackletInstances = trackletInstances(seq, frm, id, label_dir)

trackletInstances = getTracklets(seq, frm, id, label_dir);
trackletInstances(:, 9:11) = []; % Removing the translation vector details

end