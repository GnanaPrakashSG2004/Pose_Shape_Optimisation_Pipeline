function kp_lookup_matrix = getKpLookup(kpLookupFile)
  kpLookup_struct = load(kpLookupFile);
  kp_lookup_matrix = kpLookup_struct.keypoint_visibility_36';
end