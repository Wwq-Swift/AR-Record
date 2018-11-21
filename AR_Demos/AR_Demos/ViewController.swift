//
//  ViewController.swift
//  AR_Demos
//
//  Created by 王伟奇 on 2018/11/21.
//  Copyright © 2018 王伟奇. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
/// 第一个demo 随便画一个几何图形物件
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        /// 用于显示针数
        sceneView.showsStatistics = true
        
        // Create a new scene
        //        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //
        let scene = SCNScene()
        ///几何
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        /// 渲染器
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        box.materials = [material]
        
        ///节点
        let boxNode = SCNNode(geometry: box)
        
        boxNode.position = SCNVector3(0, 0, -0.2)
        scene.rootNode.addChildNode(boxNode)
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
