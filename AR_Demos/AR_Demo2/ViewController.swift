//
//  ViewController.swift
//  AR_Demo2
//
//  Created by 王伟奇 on 2018/11/21.
//  Copyright © 2018 王伟奇. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
/// 太阳系的 demo
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let arSessionConfiguation: ARConfiguration?
    
    
    /// 三个星球节点
    let sunNode: SCNNode?
    let moonNode: SCNNode?
    let earthNode: SCNNode?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        createNode()
    }
    
    private func createNode() {
        sunNode = SCNNode()
        earthNode = SCNNode()
        moonNode = SCNNode()
        
        sunNode?.geometry = SCNSphere(radius: 3)
        
        // diffuse 扩散  平均扩散到物件表面
        //multiply 镶嵌   把整张图片拉伸，会变淡
        sunNode?.geometry?.firstMaterial?.multiply.contents = "art.scnassets/sun.jpg"
        sunNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/sun.jpg"
        sunNode?.geometry?.firstMaterial?.multiply.intensity = 0.5 // 强度
        sunNode?.geometry?.firstMaterial?.lightingModel = .constant
        
        sunNode?.position = SCNVector3(0, 5, -20)
        /// wrapS 从左到右渲染。 wrapT 从上到下渲染，一起就是完全包裹
        sunNode?.geometry?.firstMaterial?.multiply.wrapS = .repeat
        sunNode?.geometry?.firstMaterial?.diffuse.wrapS = .repeat
        sunNode?.geometry?.firstMaterial?.multiply.wrapT = .repeat
        sunNode?.geometry?.firstMaterial?.diffuse.wrapT = .repeat
        sceneView.scene.rootNode.addChildNode(sunNode)
//        sceneView.scene.rootNode.a
    }
    
    private func addSunAnimation() {
        let animation = CABasicAnimation(keyPath: "r")
        animation.duration = 10
        animation.fromValue = NSValue.va
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// 全局追踪
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        /// 自适应灯光(室内室外灯光环境切换)
        arSessionConfiguation = configuration
        arSessionConfiguation?.isLightEstimationEnabled = true
        
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
