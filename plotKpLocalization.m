function plotKpLocalization(img, keyPoints)
  imshow(img);
  hold on;
  
  scatter(keyPoints(:, 1)', keyPoints(:, 2)', 100, 'filled');
  title("Localized keypoints of the vehicle");
  hold off;
end