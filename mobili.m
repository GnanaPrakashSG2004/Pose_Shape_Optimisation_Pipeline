function [B, finalError] = mobili(seq, frm, id, label_dir)

avgCarHeight = 1.5208;
avgCarLength = 3.8600;

h = avgCarHeight;                 % Average height of camera from the ground plane
K = [
      721.53, 0, 609.55;
      0, 721.53, 172.85;
      0, 0, 1;
    ];                            % Camera intrinsics matrix
n = [0, -1, 0]';                  % Unit normal vector perpendicular to ground plane

trackletFields = getTracklets(seq, frm, id, label_dir);
B = [];                           % Matrix to store 3D projection vectors of all instances
finalError = [];                  % Comparision between estimates and actual measurements

for i=1:numel(seq)
  b = [(trackletFields(i, 4) + trackletFields(i, 6)) / 2, trackletFields(i, 7), 1]'; % Midpoint from left and right ends and on the bottom part
  proj = -(h * inv(K) * b) / (n' * inv(K) * b);
  proj = proj + [0; -avgCarHeight/2; avgCarLength/2]; % In 3D, move down in vertical direction and move inward to arrive at midpoint of 3D projection cube
  B = [B; proj'];
  finalError = [finalError; abs(proj' - trackletFields(i, 9:11))];
end

end