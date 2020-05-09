//
//  ARViewController.swift
//  crewsade_app
//
//  Created by Hugo Lefrant on 09/05/2020.
//  Copyright © 2020 Lou Batier. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
   var sceneNode = SCNNode()
       var isSceneRendered = false
       var trick:String? = ""
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           // Set the view's delegate
           sceneView.delegate = self
           
           // Show statistics such as fps and timing information
           sceneView.showsStatistics = false
           
           loadScene()
       }
       
    @IBAction func test(_ sender: Any) {
        print("stop")
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           // Create a session configuration
           let configuration = ARWorldTrackingConfiguration()
           
           // Enable horizontal plane detection
           configuration.planeDetection = .horizontal
           
           // Run the view's session
           sceneView.session.run(configuration)
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           
           // Pause the view's session
           sceneView.session.pause()
       }
       
       // MARK: - ARSCNViewDelegate
       
       func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
           if let planeAnchor = anchor as? ARPlaneAnchor {
               let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)); plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.7)
               
               
               let planeNode = SCNNode(geometry: plane)
               
               planeNode.position = SCNVector3Make(
                   planeAnchor.center.x,
                   planeAnchor.center.y,
                   planeAnchor.center.z)
               planeNode.rotation = SCNVector4Make(1, 0, 0, -Float.pi / 2.0)
               
               
               let box = SCNBox(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z), length: 0.001, chamferRadius: 0)
               planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: box, options: nil))
               
               node.addChildNode(planeNode)
               
               if !isSceneRendered {
                   isSceneRendered = true
                   sceneNode.scale = SCNVector3(0.1, 0.1, 0.1)
                   sceneNode.position = SCNVector3Make(
                       planeAnchor.center.x,
                       planeAnchor.center.y,
                       planeAnchor.center.z)
                   node.addChildNode(sceneNode)
               }
           }
       }
       
       func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
           if let planeAnchor = anchor as? ARPlaneAnchor,
               let planeNode = node.childNodes.first,
               let plane = planeNode.geometry as? SCNPlane {
               plane.width = CGFloat(planeAnchor.extent.x)
               plane.height = CGFloat(planeAnchor.extent.z)
               planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
               
               let box = SCNBox(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z), length: 0.001, chamferRadius: 0)
               planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: box, options: nil))
               
           }
       }
       
       private func loadScene() {
           guard let scene = SCNScene(named: "art.scnassets/skate_final_KICKFLIP.dae") else {
               print("Impossible de charger la scène !")
               return
           }
           let childNodes = scene.rootNode.childNodes
        let time = childNodes[0].animationKeys

        print(childNodes[0].animationPlayer(forKey: time[0])?.animation.duration)
           for childNode in childNodes {
               sceneNode.addChildNode(childNode)
           }
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
       
       /*
        // MARK: - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        }
        */
       
    
}