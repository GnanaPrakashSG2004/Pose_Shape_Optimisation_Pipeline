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