# DimensionsAR

This folder contains an example application allowing users to measure an object's dimensions by placing a bounding box around it, and showcases a slightly advanced usage of ARKit and SceneKit.

## Table of Content

- [The Bounding Box](#the-bounding-box)
- [Bounding Box Faces](#bounding-box-faces)
- [Functionalities](#funtionalities)
    - [Show/hide](#showhide)
    - [Move](#move)
    - [Scale](#scale)


# The Bounding Box

The bounding box is a subclass of [`SCNNode`](https://developer.apple.com/documentation/scenekit/scnnode) that represents a cuboid object of a certain extent (size), containing six faces—left, right, bottom, top, front and back—that together create a box. Whenever the extent is changed, the bounding box re-renders itself so that the faces have the updated extent as well.

# Bounding Box Faces

The bounding box face is also a subclass of [`SCNNode`](https://developer.apple.com/documentation/scenekit/scnnode) and represents one of the sides of the cuboid object described above. The default representation is a cube.

The face's geometry is of a rectangular shape (a square by default), which is at the initialization time correctly positioned and rotated so that it represents cuboid's side because by default each face is created the same way at the same position with the same orientation. By default the face is in a vertical position facing the camera (or world's positive z-axis).

Each face has the following properties that further help representing the face type better:
- Drag axis: Indicates which axis is used when dragging the face.
- A normal vector: Represents the direction of the face.

# Funtionalities

- [Show/hide](#showhide)
- [Move](#move)
- [Scale](#scale)

## Show/hide

The bounding box is displayed after a single tap gesture on any detected horizontal plane. This is achieved using ARKit's [`raycast(_:)`](https://developer.apple.com/documentation/arkit/arsession/3132065-raycast), which returns intersections of the raycasted query's ray and real-world surfaces, where the box will eventually appear.

Tapping on a button positioned in the top-right corner of the screen will hide (reset) the bounding box.

<p align="center"><img src="Images/tap.gif" height="450" width="200" /></p>

## Move

The position of the bounding box can be changed by dragging it with a single finger gesture (panning). 

There are two options how this is implemented, see in [`handlePanGesture(_:)`](https://github.com/strvcom/ios-course-mendelu-2022-autumn/blob/cc56a1142fd64116338f4aeee80329f92d47b7aa/Augmented%20Reality/DimensionsAR/DimensionsAR/Utils/GestureManager.swift#L82) in [`GestureManager`](https://github.com/strvcom/ios-course-mendelu-2022-autumn/blob/cc56a1142fd64116338f4aeee80329f92d47b7aa/Augmented%20Reality/DimensionsAR/DimensionsAR/Utils/GestureManager.swift#L11).

The first option calculates the new position relative to the previous position by calculating an offset while maintaining the same z-axis coordinate. So when dragging up and down the box is moving on the y-axis only.

<p align="center"><img src="Images/move-option-1.gif" height="450" width="200" /></p>

The second option relies on results from [`raycast(_:)`](https://developer.apple.com/documentation/arkit/arsession/3132065-raycast). Each time the user moves the finger, we check for new intersections and move the box to the location of the closest intersection.

<p align="center"><img src="Images/move-option-2.gif" height="450" width="200" /></p>

## Scale

The size of the bounding box can be changed by pinch gesture with two fingers (same as zooming). This will change the size about all axis. 

The implementation behind this is very simple — we simply multiply the bounding box's extent by the scale factor of the gesture. After each change we also need to mutate the factor to one so that each pinch gesture update starts from the new factor (it is relative to the points of the two touches).

<p align="center"><img src="Images/scale-all.gif" height="450" width="200" /></p>

To change the size about one axis, long press one of the box's face and drag it in the positive or negative direction of its normal vector to scale it. The application will let you know that you can start dragging with a haptic feedback.

This functionality is by far the most complicated one as it involves a lot of calculations and manipulations with the bounding box.

At the beginning we need to store information about the face we want to drag.
- Plane transformation matrix:
  - X vector is represented as the face's normal vector.
  - Z vector is represented as the cross product of the X vector and a directional vector from the point of hit on the face and the camera's position.
  - Y vector is represented as the cross product of the X vector and Z vector.
  - Translation vector is represented as the point of hit on the face.
- The bounding box's position in relative to the scene's world coordinate space.
- The bounding box's current extent.

Then, whenever we drag with the finger, we want to calculate a new extent and replace it with the current. This is done by unprojecting the gesture's location into the plane's coordinate space so that we can use this point's location to calculate the offset by which we will scale the extent. 

Because the face's normal vector points to the same direction as its x-axis (because we defined the transformation matrix this way), we are only interested in the changes on the x-axis. The new extent is calculated by adding an offset to the current extent. This offset is obtained by a simple multiplication of the face's normal vector and the point's x coordinate — and thanks to the way we represent normal vectors, this multiplication will only scale the correct axis.

<p align="center"><img src="Images/scale-face.gif" height="450" width="200" /></p>
