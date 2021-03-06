//
//  ViewController.swift
//  Hacktivity-1
//
//  Created by Alex Beals on 9/16/17.
//  Copyright © 2017 Alex Beals. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var banchor: ARAnchor?
    var node: SCNNode?
    var roadNode: SCNNode?
    var carNode: SCNNode?
    var planeHeight: CGFloat = 0.005
    var isTesting: Bool = false;
    
    // Psuedo-random numbers
    var trackWidth: CGFloat = 0.09
    var trackHeight: CGFloat = 0.13
    
    var timeToLap: Double = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Load the road
        let tempRoadScene = SCNScene(named: "art.scnassets/track.scn")!
        roadNode = tempRoadScene.rootNode
        
        // Load the car
        let tempCarScene = SCNScene(named: "art.scnassets/volks.scn")!
        carNode = tempCarScene.rootNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node:  SCNNode?
        if let planeAnchor = anchor as? ARPlaneAnchor {
            node = SCNNode()
            
            if (isTesting) { // enable for seeing plane
                let planeGeometry = SCNBox(width: CGFloat(planeAnchor.extent.x), height: planeHeight, length: CGFloat(planeAnchor.extent.z), chamferRadius: 0.0)
                planeGeometry.firstMaterial?.diffuse.contents = UIColor.green
                planeGeometry.firstMaterial?.specular.contents = UIColor.white
                let planeNode = SCNNode(geometry: planeGeometry)
                planeNode.position = SCNVector3Make(planeAnchor.center.x, Float(planeHeight / 2), planeAnchor.center.z)
                node?.addChildNode(planeNode)
            }
            
            banchor = planeAnchor
            
            // Place the road
            let newRoadNode = roadNode?.clone()
            if let newRoadNode = newRoadNode {
                newRoadNode.position = SCNVector3Make(planeAnchor.center.x, (isTesting ? Float(planeHeight * 2) : 0), planeAnchor.center.z)
                node?.addChildNode(newRoadNode)
            }
            
            // Place the car
            let newCarNode = carNode?.clone()
            if let newCarNode = newCarNode {
                addDrivingAnimation(node: newCarNode, center: planeAnchor.center)
                newCarNode.position = SCNVector3Make(planeAnchor.center.x + Float(trackWidth), 0, planeAnchor.center.z)
                node?.addChildNode(newCarNode)
            }
        }
        return node
    }
    
    // Animation
    func addDrivingAnimation(node: SCNNode, center: vector_float3) {
        // Position animation
        let positionAnimation = CAKeyframeAnimation(keyPath: #keyPath(SCNNode.position))
        
        positionAnimation.values = [
            SCNVector3Make(center.x + Float(trackWidth), 0, center.z),
            SCNVector3Make(center.x + Float(trackWidth), 0, center.z + Float(trackHeight)),
            SCNVector3Make(center.x - Float(trackWidth), 0, center.z + Float(trackHeight)),
            SCNVector3Make(center.x - Float(trackWidth), 0, center.z - Float(trackHeight)),
            SCNVector3Make(center.x + Float(trackWidth), 0, center.z - Float(trackHeight)),
            SCNVector3Make(center.x + Float(trackWidth), 0, center.z),
        ]
        
        positionAnimation.keyTimes = [
            0,
            1,
            2.5,
            4.5,
            6,
            7
        ]
        positionAnimation.duration = timeToLap
        positionAnimation.repeatCount = .infinity
        
        // Rotation animation
        let rotationAnimation = CAKeyframeAnimation(keyPath: #keyPath(SCNNode.eulerAngles))
        
        rotationAnimation.values = [
            SCNVector3Make(0, 0, 0),
            SCNVector3Make(0, 0, 0),
            SCNVector3Make(0, -90 * .pi / 180, 0),
            SCNVector3Make(0, -90 * .pi / 180, 0),
            SCNVector3Make(0, -180 * .pi / 180, 0),
            SCNVector3Make(0, -180 * .pi / 180, 0),
            SCNVector3Make(0, -270 * .pi / 180, 0),
            SCNVector3Make(0, -270 * .pi / 180, 0),
            SCNVector3Make(0, -360 * .pi / 180, 0),
            SCNVector3Make(0, -360 * .pi / 180, 0),
        ]
        
        // A pretty hacked together way to make the timings right
        rotationAnimation.keyTimes = [
            0,
            1,
            2,
            3.5,
            4.5,
            6.5,
            7.5,
            9,
            10,
            11
        ]
        rotationAnimation.duration = timeToLap
        rotationAnimation.repeatCount = .infinity
        
        node.removeAllAnimations()
        node.addAnimation(positionAnimation, forKey: "positionAnimation")
        node.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
