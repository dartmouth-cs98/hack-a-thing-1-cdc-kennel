# Hacktivity 1
Alex Beals, Manmeet Gujral

### What we did
For this project, we created an ARKit app that shows a car driving along an ovular track on a detected plane in the app. 

### Who did what
Our commits can provide a breakdown of who contributed what code exactly but for the most part all of this was done together discussing as one person "drove" the coding and the other looked along and helped design. Alex set up the boilerplate ARKit app base from apple and created/added the assets we would draw in our AR view. Manmeet worked on plane detection based on online sources listed below and placing a car on a road on the plane anchor. Alex cleaned up the drawing of the assets on the plane and changed the car from the track. Manmeet animated the car on the track and wrote the README. Ultimately, we were with each other for all of this code.

### What we learned
It was really cool to work with ARKit. It is surprisingly user friendly to start playing with and really interesting new tech. Ultimtaley we learned what it is like to work with AR and how difficult it would be to create a high quality game or interface in AR. We also learned how cumbersome it is to calibrate all the angles and motions of the animation. 

### What didn't work
Linking movements of one asset to another. All calculations were relative to the anchored plane, not to the track asset itself, which required some weird calibration with the asset GUI in xcode. We also did not know how to make an endless road that would expend with the horizon of the moving phone (would be really difficult with plane detection and anchoring).

## Screenshots and Video
See the screenshots and video folder.

### Assets
1. Car Model - https://free3d.com/3d-model/low-poly-volkswagen-84375.html
2. Road Model - https://kenney.nl/assets/racing-kit
3. Track - build by Alex from Road Model

### Sources
In no particular order, we sourced actual code from:
1. Animation - https://developer.apple.com/documentation/scenekit/animation/animating_scenekit_content
2. Plane Detection - https://github.com/sriscode/Arkit-PlaneDetect-PlaceObject/blob/master/ArkitPlaneDetect%26PlaceObject/ViewController.swift

In no particular order, we sourced ideas from:
1. Plane Detection - https://blog.markdaws.net/arkit-by-example-part-2-plane-detection-visualization-10f05876d53
2. Animations - http://mathewsanders.com/animations-in-swift-part-two/
