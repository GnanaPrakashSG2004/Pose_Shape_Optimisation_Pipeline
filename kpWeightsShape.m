function W = kpWeightsShape(seq, frm, id, label_dir, kpNetOutputFile, kpLookupFile)
  [~, Wkpl, Wkps] = kpWeights(seq, frm, id, label_dir, kpNetOutputFile, kpLookupFile);

  W = 0.2 * Wkps + 0.8 * Wkpl;
  min = 0.001;
  [r,c] = find(W < min);
  for i=1:length(r)
      W(r(i), c(i)) = min;
  end
end