## Reconstructing Vehicles from a Single Image: Shape Priors for Road Scene Understanding (Main paper)
- [Paper](https://arxiv.org/abs/1609.09468)
- [Slide deck](https://www.canva.com/design/DAFZtxaLbLQ/Xf7UhIvKjwqkJFeGFSx5LA/view?utm_content=DAFZtxaLbLQ&utm_campaign=designshare&utm_medium=link&utm_source=publishsharelink)
<hr>

## 6-DoF Object Pose from Semantic Keypoints (Done as part of task 5)
- [Paper](https://arxiv.org/abs/1703.04670)
- [Slide deck](https://www.canva.com/design/DAFl4yGQGcM/QndI1K1yBbSgIfkNqVmq-g/view?utm_content=DAFl4yGQGcM&utm_campaign=designshare&utm_medium=link&utm_source=publishsharelink)
<hr>

### What the scripts do:
- `alignMeanShape.m`: Performs rotation and translation on the mean shape and deformation vectors of the car based on the alignment of the car labels with the camera and also returns the coordinates of the mean shape projected onto the image
- `ceresPoseOptimizer.m`: Creates the input file required by the `singleViewPoseAdjuster.cc` script in the `ceres` directory. Then, executes this script and returns the image coordinates of the optimized pose of the cars
- `distinguishable_colors.m`: Generates visually different colors for plotting
- `getKpLookup.m`: Returns the lookup table for the keypoints of the cars
- `getKpNetMatrix.m`: Returns a matrix containing the 2D pixel coordinates of the keypoints of each of the car labels along with their confidence values. Also resizes the image coordinates so that the coordinates are relative to the original image of the car and not just the scaled bounding box of the car, with dimensions 64*64 
- `getTracklets.m`: Extracts all the required fields from the tracklets obtained from the `readLabels.m` script given in the `devkit` package
- `kpWeights.m`: Returns the weight matrix corresponding to the keypoints of the cars based on both their confidence values and also the lookup table
  - This script requires the directory path to the labels relative to the `devkit/matlab` directory
- `mobili.m`: Generates the 3D bounding box projection using the tracklet data
  - This script is implemented based on the paper [Robust Scale Estimation in Real-Time Monocular SFM for Autonomous Driving](https://ieeexplore.ieee.org/document/6909599)
  - This script requires the directory path to the labels relative to the `devkit/matlab` directory
- `plotKpLocalization.m`: Plots the predicted image coordinates of the keypoints of the car on the image of the car
- `reorientDeformationVectors.m`: Reorients the deformation vectors based on the standards followed in the KITTI dataset
- `reorientMeanShape.m`: Reorients the mean shape vector based on the standards followed in the KITTI dataset
- `scaleMeanShape.m`: Scales the dimensions of the mean shape vector based on given average dimensions of the car
- `seqFrmId.m`: Helper script to return the `seq`, `frm` and `id` arrays used in all other files
- `trackletInstances.m`: Returns an array containing 8 attributes for each of the required instances
  - This script requires the directory path to the labels relative to the `devkit/matlab` directory
- `visualizeAdjusting.m`: Plots the mean shape of the car before and after reorientation based on the KITTI standards using the `scaleMeanShape.m`, `reorientMeanShape.m` and `visualizeWireFrame3D.m` scripts
- `visualizeAlignedWireframe.m`: Plots the aligned wireframe of the car on its actual image using the `visualizeWireFrame2D.m` script
- `visualizeScaling.m`: Plots the mean shape of the car before and after scaling using the `scaleMeanShape.m` and `visualizeWireFrame3D.m` scripts
- `visualizeWireFrame2D.m`: Plots the 2D wireframe of the car on its actual image using the mean shape vector
- `visualizeWireFrame3D.m`: Plots the 3D wireframe of the car using the mean shape vector
<hr>

### Other files and directories:
- `ceres`: Contains the single view pose and shape optimizer scripts and their definitions
- `devkit`: Contains the scripts for processing the KITTI dataset
- `Left_Colour_Images`: Contains the left colour images of the KITTI dataset
- `training`: Contains the training labels of the KITTI dataset
- `meanShape.txt`: Contains the mean shape vector of the car with dimensions `14 x 3`
- `vectors.txt`: Contains the deformation vectors of the car with dimensions `5 x 42`
<hr>