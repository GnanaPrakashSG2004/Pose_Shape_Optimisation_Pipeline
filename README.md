### Reconstructing Vehicles from a Single Image: Shape Priors for Road Scene Understanding
- [Slide deck](https://www.canva.com/design/DAFZtxaLbLQ/Xf7UhIvKjwqkJFeGFSx5LA/view?utm_content=DAFZtxaLbLQ&utm_campaign=designshare&utm_medium=link&utm_source=publishsharelink)

### What the scripts do:
- `distinguishable_colors.m`: Generates visually different colors for plotting
- `getTracklets.m`: Extracts all the required fields from the tracklets obtained from the `readLabels.m` script given in the `devkit` package
  - This script requires the directory path to the labels relative to the `devkit/matlab` directory
- `mobili.m`: Generates the 3D bounding box projection using the tracklet data
  - This script is implemented based on the paper [Robust Scale Estimation in Real-Time Monocular SFM for Autonomous Driving](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6909599&tag=1)
  - This script requires the directory path to the labels relative to the `devkit/matlab` directory
- `reorientDeformationVectors.m`: Reorients the deformation vectors based on the standards followed in the KITTI dataset
- `reorientMeanShape.m`: Reorients the mean shape vector based on the standards followed in the KITTI dataset
- `scaleMeanShape.m`: Scales the dimensions of the mean shape vector based on given average dimensions of the car
- `trackletInstances.m`: Returns an array containing 8 attributes for each of the required instances
  - This script requires the directory path to the labels relative to the `devkit/matlab` directory
- `visualizeAdjusting.m`: Plots the mean shape of the car before and after reorientation based on the KITTI standards using the `scaleMeanShape.m`, `reorientMeanShape.m` and `visualizeWireFrame3D.m` scripts
- `visualizeScaling.m`: Plots the mean shape of the car before and after scaling using the `scaleMeanShape.m` and `visualizeWireFrame3D.m` scripts
- `visualizeWireFrame3D.m`: Plots the 3D wireframe of the car using the mean shape vector

### Other files and directories:
- `devkit`: Contains the scripts for processing the KITTI dataset
- `Left_Colour_Images`: Contains the left colour images of the KITTI dataset
- `training`: Contains the training labels of the KITTI dataset
- `meanShape.txt`: Contains the mean shape vector of the car with dimensions `14*3`
- `vectors.txt`: Contains the deformation vectors of the car with dimensions `5*42`