## problemStructs.hpp
- Functions to get
  - Number of observations
  - Number of observed keypoints
  - Coordinates of the car center
  - Height, width and length of the car
  - Observation vector
  - Weights for the observation vector
  - Camera intrinsics matrix
  - Mean 3D location of the car
  - Top 5 eigen vectors of the car: deformation vectors
  - Lambdas for the above 5 vectors

- Load file function to read the required variables from the input file
<hr>

## singleViewPoseAdjuster.cc
- Initialize logging by google logger
- Use the loadfile function and read the variables into the attributes of the `SingleViewPoseAdjustmentProblem` class
- Create variables to store the attributes of this class

- Also keep a copy of the initial 3D mean locations of the car in another array
- Initialize variables to keep track of the initial and final reprojection errors
- Also initialize an array to store the xz normal (normal to the plane of the car)

- Initialize the start indices of various keypoints
- Initialize the rotation matrix (to identity matrix of 3*3) and translation matrix to be [1, 1, 1]

- Copy this intial rotation matrix to another matrix and call the rotation matrix to angle axis function of ceres and store the result in a previously initialized angle axis array of size 3

- Create a new ceres `Problem` instance
- Create a new array to store the eigen vectors for the current keypoint
- Add a new pnpError variable for this keypoint to add a cost function to handle the pnp Error term using the ceres `CostFunction` type by adding it to the `AddResidualBlock` attribute of the ceres `Problem` instance
  - This is done for all the keypoints
- Add a `TranslationRegularizer` regularizer term to prevent too much drift of the translation term from the initial value
- Add a `RotationRegularizer` regularizer term to ensure that the rotation is done about the Y-axis only
- Set bounds on the translation estimates

- Solve the optimization problem by declaring the ceres `Solver` class and setting the options and also initializing the `Summary` class and then calling the `Solve` function
- Now, call the ceres function to convert the angle axis vector back to the rotation matrix. We also have the modified translation vector
- These are the final results
<hr>