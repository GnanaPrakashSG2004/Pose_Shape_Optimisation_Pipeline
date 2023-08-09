## DistanceError:
- Calculates residuals corresponding to the estimated mesh and the initial mesh
  - This ensures that the predicted solution is close to the initial estimate
<hr>

## PlanarityError:
- Calculates the distance of the 4 vertices from the plane and tries to minimise them
  - Hence finding the best plane to minimise the distances between them
- Can be related to the points such as the 4 keypoints on top of the car, viz., `L_F_ROOFTOP`, `R_F_ROOFTOP`, `L_B_ROOFTOP` and `R_B_ROOFTOP`
  - This error is then used to find the optimal plane for the keypoints such that all of them lie on it and hence the wireframe is optimised
<hr>

## UnitMagnitude:
- To optimize the coefficients of the normal such that the magnitude of the normal is close to unit magnitude
<hr>

## KeypointReprojectionError:
- This error computes the distance between the detected pattern keypoint and the corresponding point in the real world image
- The coordinates of the 3D prediction point are obtained by multiplying the camera intrinsics matrix `K` and the observation vectors
- Then, using the concept of homogeneous coordinates, we obtain the 2D coordinates
  - Some optimisation is used in the division
- Residuals are calculated by subtracting the coordinates of the 2D projected point and its corresponding parts of the observation vectors
<hr>

## ChamferFieldKeypointError:
- This error is similar to the normal keypoint reprojection error in the sense that the error is calculated in a similar way except for the fact that it is set to `0` if the distance is within a given threshold, also known as the Chamfer Field error
- Chamfer distance is calculated to estimate the distance between two point clouds, which is done by summing the squares of the distances of each point in one point cloud to the nearest point in the other point cloud
- If this distance is within the Chamfer threshold `influence`, then the error is set to a very small quantity
  - This small non-zero value is selected to ensure that the solver does not get stuck in a local minimum
- All the other calculations are done similar to that of the normal keypoint reprojection error
<hr>

## WeightedKeypointReprojectionError:
- This implementation is similar to that of the normal keypoint reprojection error calculations but the difference is in the calculations of the residuals
- The residuals are calculated by multiplying the difference of the predicted keypoint coordinates and the observed coordinates with the square root of the corresponding weight
- This error is more useful in the implementation of the IRLS scheme
  - The IRLS - Iteratively Reweighted Least Squares scheme is the modified version of the least squares scheme where weights are assigned to each of the residuals and the residuals are multiplied by the square root of the corresponding weight
  - These weights are introduced to reduce the influence of outliers and occlusions in the data
  - They are calculated and modified in each iteration depending on the current variance of the residuals
<hr>

## RegularizationTerm:
- This term ensures that the 3D points are as close as possible to the center of the car
- The residuals are calculated just by computing the difference of the predicted and actual values but scaled by a factor of `10`
<hr>

## InitialDepth:
- This term ensures that the keypoints retain their initial depths as much as possible
- The residuals are calculated just by computing the difference of the predicted and actual values
<hr>

## ParallelToGround:
- This function ensures that the normal of the car is parallel to the ground frame normal `[0, 1, 0]'`
- The residuals are calculated by computing the difference of the normal vector from `[0, 1, 0]'` and are scaled by a factor of `3`
<hr>

## BoxCoverage:
- This cost function ensures that the predicted mesh covers the entire box
- Hence, this ensures that the points are as far as possible from each other
- The residuals are computed by just assigning them to the inverse of the difference of the corresponding coordinates
<hr>

## DimensionPrior:
- This cost function ensures that the distance between two points is of appropriate magnitude, so that the wireframe of the car is of appropriate shape
- The residuals are computed using the difference between the square of the distance between the predicted locations of the points and the square of the expected distance between the points
<hr>

## HeightPrior:
- This cost function ensures that the height of the point is of appriopriate magnitude from the ground plane, so that the wireframe of the car is of appropriate shape
- The residuals are computed just by calculating the difference of the `Y`-coordinate of the predicted location of the point and the expected height of the point
<hr>

## LaplacianSmoother:
- Laplacian smoother regularizer is used to prevent overfitting of models
- This works by minimising the distance of the point from the mean position of its neighbours
- The residuals are calculated by just taking the difference of the predicted location of the point and the mean location of its neighbours
- This cost function helps in smoothing of polynomial meshes, which in our case is the wireframe of the car
<hr>

## ParallelLines:
- Cost function to penalise when two lines, one joining p1 and p2 and the other joining p3 and p4 are not parallel
- Their parallel nature is calculated by taking the cross product of the two lines using the coordinates of the corresponding points
- The residuals are just the cross products of the two lines scaled by a factor of `5`
<hr>

## PerpendicularLines:
- Cost function to penalise if line joining p1 and p2 is not perpendicular to the line joining p2 and p3
- Perpendicularity is calculated by taking the dot product of the two lines using the coordinates of the corresponding points
- The residuals are just the dot products of the two lines scaled by a factor of `5`
<hr>

## LambdaReprojectionError:
- We calculate the 3D point coordinates from the predicted 3D point and also the weighted deformation vector coordinates
- We then project these to the corresponding 2D coordinates using the camera intrinsics matrix `K` and the concepts of homogeneous coordinates
- The residuals are then just the difference of the calculated 2D coordinates and the observed 2D keypoints multiplied by the corresponding square roots of the weights
<hr>

## LambdaAlignmentError:
- The 3D point coordinates are calculated similarly from the predicted 3D point and the weighted deformation vector coordinates
- The residuals are just the difference of the calculated 3D coordinates and the observed 3D keypoints multiplied by the corresponding square roots of the weights
- This cost function is used to ensure that our predictions dont move too far from our initial guess of where the point must be present
  - It is to this location that we are 'soft' regularizing our predictions to
<hr>

## LambdaRegularizer:
- This cost function is used to ensure that the influence of the lamdas is not too strong on the deformation of the shape of the car
- The residuals are just the weighted sum of the deformation vector coordinates, where the weights are the corresponding lambdas of the vectors
<hr>

## LambdaRegularizerWeighted:
- This cost function is similar to the LambdaRegularizer cost function except for the calculation of the residuals
- The residuals are `5` in number (one for each of the lambdas) which are just the products of the lambda values and their corresponding square roots of the weights
<hr>

## TranslationRegularizer:
- This cost function ensures that there is no huge drift of the translation estimate from the initial estimate
- The residuals are just the scaled down values of the translation estimates
<hr>

## RotationRegularizer:
- This cost function ensures that the angle of rotation is maximally aligned to the Y-axis
- The residuals for the X and Z axes are majorly scaled up to hevaily penalize the deviation from the Y-axis
- The residual for the Y-axis is just 0 as the normal has been initialised to 1 initially as well
<hr>

## PnPError:
- This cost function is to optimise the PnP Error and to improve the Rotation matrix R and the translation vector t estimates
- We first calculate the 3D point coordinates from the predicted 3D point and the weighted deformation vector coordinates
- After this, we rotate this point using the angle axis matrix that has been updated till this point to rotate the point accordingly along the appropriate axis by the required angle
  - Here, a note regarding ceres implementation: The resulting point must be stored in another array as inplace rotation is not supported
  - The square of the angle (in radians) is obtained using the dot product of the angle axis matrix with itself since the direction vector is of unit magnitude
  - We then use the rodriguez formula to calculate the resulting coordinates if the angle is non-zero
  - Else, we use the Taylor series approximation to calculate the resulting coordinates to avoid division by zero
- Then, the translation estimate is added to the rotated point to obtain the final 3D coordinates
- This predicted 3D point is then projected to the 2D system using the camera intrinsics matrix and the concepts of homogeneous coordinates
- Finally, the residuals are calculated by just taking the difference of the calculated 2D coordinates and the observed 2D keypoints multiplied by the corresponding square roots of the weights
<hr>