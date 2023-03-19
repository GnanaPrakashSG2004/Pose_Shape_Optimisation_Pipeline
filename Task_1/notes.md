- Monocular images captured using a single camera/lens
- Give 2D images and does not provide depth information
- Harder to estimate 3D structure from than stereo image
- Binocular images use 2 parallaxed images to produce binocular vision giving depth perception and stereopsis

- The model is trained on previous 3D images of cars and this information is encoded as shape priors.
- Shape priors are obtained from a small keypoint-annotated dataset
- Keypoints are those points of the image which stand out from the rest of the image
- CNNs are used to localize keypoints and train convolutional architecture on the obtained data
- Then, shape-aware adjustments recovers the 3D locations of the keypoints and fills occluded keypoints
- Then, Iteratively Re-weighted Least Squares(IRLS) scheme is used to handle incorrectly detected keypoints
- Tested on autonomous driving benchmarks

- Present road scene understanding approaches use LiDAR (Light Detection and Ranging) / stereo cameras
- 2D images to 3D inspiration from humans
- Aims to train machines on collected shape priors from existing 2D images of cars that are keypoint-annotated
- Accurate keypoint detection is shown to benefit pose and shape estimation
- This scheme can estimate the 3D pose given shape prior and keypoint detections and can fill occluded keypoints in the process too
- Minimizes error(noise) in erroneously detected keypoints using the IRLS scheme, which gives accuracy of >90%
- CNN-cascade architecture used to perform keypoint localization, helping 3D pose and shape adjustment
- Dataset is from the KITTI autonomous driving benchmark
- Estimating shape and pose simultaneously is difficult and this schema decouples these estimations
- Initially, the coarse shape is obtained after aligning the pose with the mean shape for the given set of keypoints
- Then, a shape-adjustment algo is run over all the keypoints which ensures that the obtained shape satisfies geometric constraints enforced by the shape prior of that object category
- Algo gives 27% more accuracy in terms of pose accuracy than other leading monocular and stereo schemes

- This algo does shape reconstruction based on Then, a shape-adjustment algo is run over all the keypoints which ensures that the obtained shape satisfies geometric constraints enforced by the shape prior of that object category
- A camera model and a globally optimal pose estimation pipelines are used in this algo for reconstruction
- This algo uses a cascaded architecture of convolutional-networks that is trained on keypoint localization

## Shape priors:
- Shape prior is ordered collection of 3D vertices (keypoints, or parts) for the average shape of an instance from the object category
- Keypoints refer to various semantic parts of an object category that are common to all instances of that category
- For cars, potential keypoints are wheel centers, headlights, rooftop corners, etc.
- Only small dataset of 300 instances was used
- SfM (Structure-from-Motion) needs same rigid instances across multiple images
- But, algo wants as many different instances as possible to handle variations within the same class
- But, keypoints cannot be used as correspondences in the SfM method
- Thus, the EM-PPCA algo is employed to use keypoints as correspondences after which the Non-Rigid Structure-from-Motion (NRSfM) algo is used to reconstruct the 3D image from the 2D one
- Likelihood maximization is done using the EM method due to the presence of missing keypoints due to occlusion, which are filled using the E-step method

## Problem Formulation:
- After this, each instance of an object category is characterized using shape and pose parameters, where shape parameters show the locations of the object keypoints relative to a canonical coordinate frame, while the pose parameters specify the orientation of the set of keypoints wrt the camera
- We divide the simultaneous shape and pose estimation problem into two subproblems of shape estimation and pose estimation separately
- We presently have the projection of the object shape onto the image plane
- From this, we can derive the object pose
- And from these both, we can derive the shape of the object
- This is given by p(X, T | x) = p(X | T, x)·p(T | x), where X is the object shape, T is the object pose and x is the the projection of X onto the image plane
- An initial idea on p(T | x) is obtained using the CNN-cascade to generate an approximate viewpoint of the object in 3D
- Then, p(X, T | x) is estimated using an EM-like scheme, which iterates between pose and shape adjustment subproblems

## Pose adjustment:
- Pose adjustment done in two phases - keypoint localization and robust alignment
  ### Keypoint localization:
  - First, keypoints are detected (denoted by KNet), all of which are further refined using keypoint-specific fine tuning methods
  - N patches of size 32*32 around each of the keypoint are randomly sampled and fine-tuning is done. The keypoint likelihoods are aggregated and maximized and the maxima of the normalized keypoint likelihood map is chosen to be the estimated location of the keypoint

  ### Robust alignment:
  - With the above data, a robust Perspective n-Point (PnP) problem is formulated, which can be solved using the Gröebner basis solver to give a globally optimal solution
  - This method is highly intolerant to keypoint localization errors and thus, IRLS method is used.

- Thus, the ASPnP + IRLS algo is used to reconstruct the pose to a great accuracy

## Shape-Aware Adjustment:
  ### Planarization:
  - The fact that all vehicles have planar surfaces is used and the object shape is considered to be a quad mesh.
  - It is ensured all 4 points (4 because quad mesh) on a face are planar and the normals to the planes are of unit magnitude

  ### Symmetrization:
  - The fact that all vehicles are symmetric about their medial plane is used in this reconstruction algo in the projective case and is solved using non-linear least squares method

  ### Regularization:
  - The length, width and height of each shape are regularized so that the planarization and symmetrization energies are real values
  - These terms are ensured to be as close to the prior values as possible
  - Also, a modification of the Laplacian smoothing regularizer is used which ensures that each vertex remains close to the centroid of its neighbours. This even performs better than the Euclidean regularizer

  ### Initialization:
  - Bounding boxes are used, where the mean shape is adjusted to the center of the bounded box.
  - Although, the ASPnP + IRLS algo handles errors pretty well, the use of bounding boxes results in a slight performance boost and thus, is employed in initialization

- The shape-aware adjustment is achieved by the accumulation of all the above points
- Since, the algo is solving for the shape of a single instance, there are very few variables thus resulting in real-time performance

## Dataset:
- Was categorised into train and validation splits
- Based on the levels of occlusion and truncation, the evaluation has been split into Easy, Moderate and Hard regimes
- The CNN-cascade is trained by annotating data from the train split

## Keypoint annotations for KITTI:
- The 2D annotated keypoints are used and then, a PnP (Perspective n-Point) algorithm that uses reference CAD models to correct incorrectly marked keypoints is initialized

## Metrics:
- The Average Orientation Precision (AOP) metric is used to evaluate the pose estimated by our method
- The Average Precision of Keypoints (APK) method is used to evaluate error in estimated keypoint locations
- The Hausdorff distance metric is used to quantitatively evaluate the distance between two shapes(meshes)

## Implementation:
- The CNNs used for keypoint detection were trained in Caffe, over annotated data from the train split, which contained no overlap between images/sequences
- The shape-aware adjustment was implemented using Ceres Solver, and was solved using a dense Schur linear system solver and a Jacobi preconditioner

## Pose Estimation:
- The proposed approach (ASPnP + IRLS) achieves precise pose (to within 5 degrees) for more than 50% of the samples
- On average, the pose estimation performance is improved by 11.42% wrt the next-best competitor
- The algo estimates pose that is within ±30° of the original azimuth, while more than half of the time, we are within ±5° of the actual azimuth
- The ASPnP algo struggles when there is noise and hence, the IRLS method reduces weight for the incorrectly filled keypoints with every iteration and thus, a closer estimate is obtained
- The mesh error metric is evaluated based on the Hausdorff distance of the optimized shape from the shape prior
- The less change in Hausdorff Distance from the pose estimation to the shape estimation shows that these 2 problems can be decoupled
- The high change in Hausdorff Distance from the initialization to the pose estimation is justified as the initialization is done erroneously and thus, large rotations and transformations have to be applied