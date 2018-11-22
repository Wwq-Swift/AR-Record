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
    var arSessionConfiguation: ARConfiguration?
    
    
    /// 三个星球节点
    private var sunNode: SCNNode?
    private var moonNode: SCNNode?
    private var earthNode: SCNNode?
    
    private var sonHaloNode: SCNNode?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        createNodes()
    }
    
    private func createNodes() {
        sunNode = SCNNode()
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
        sceneView.scene.rootNode.addChildNode(sunNode!)
//        sceneView.scene.rootNode.a
        addSunNodeAnimation()
        addSunLight()
        createEarthNode()
        createMoonNode()
    }
    
    private func createEarthNode() {
        earthNode = SCNNode()
        earthNode?.geometry = SCNSphere(radius: 1)
        //    地球上圖
        earthNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth-diffuse-mini.jpg"
        //    地球夜光圖
        earthNode?.geometry?.firstMaterial?.emission.contents = "art.scnassets/earth-emissive-mini.jpg"
        earthNode?.geometry?.firstMaterial?.specular.contents = "art.scnassets/earth-specular-mini.jpg"
        earthNode?.position = SCNVector3(10, 0, 0)
        
        //    太陽照到地球上的光層，還有反光度，地球的反光度
        earthNode?.geometry?.firstMaterial?.shininess = 0.1 // 光澤
        earthNode?.geometry?.firstMaterial?.specular.intensity = 0.5 // 反射多少光出去
        
        sunNode?.addChildNode(earthNode!)
        addEarthAnimation()
    }
    
    private func createMoonNode() {
        moonNode = SCNNode()
        moonNode?.geometry = SCNSphere(radius: 0.5)
        //    地球上圖
        moonNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/moon.jpg"
        //    地球夜光圖
        moonNode?.geometry?.firstMaterial?.emission.contents = "art.scnassets/earth-emissive-mini.jpg"
        moonNode?.geometry?.firstMaterial?.specular.contents = "art.scnassets/earth-specular-mini.jpg"
        moonNode?.position = SCNVector3(4, 0, 0)
        earthNode?.addChildNode(moonNode!)

    }
    
    private func addSunNodeAnimation() {
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 10
        animation.toValue = NSValue(scnVector4: SCNVector4(0, 1, 0, CGFloat.pi * 2))
        animation.repeatCount = Float.greatestFiniteMagnitude
        sunNode?.addAnimation(animation, forKey: "SunRotation")
    }
    
    private func addEarthAnimation() {
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.duration = 5
        animation.toValue = NSValue(scnVector4: SCNVector4(0, 10, 0, CGFloat.pi * 2))
        animation.repeatCount = Float.greatestFiniteMagnitude
        earthNode?.addAnimation(animation, forKey: "earthRotation")
    }
    
    private func addSunLight() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.color = UIColor.red
        
        sunNode?.addChildNode(lightNode)
        
        lightNode.light?.attenuationEndDistance = 20
        lightNode.light?.attenuationStartDistance = 1
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1
        SCNTransaction.commit()
        
        sonHaloNode = SCNNode()
        sonHaloNode?.geometry = SCNPlane(width: 25, height: 25)
        sonHaloNode?.rotation = SCNVector4(1, 0, 0, 0)
//        _sunHaloNode.rotation = SCNVector4Make(1, 0, 0, 0 * M_PI / 180.0);
        sonHaloNode?.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/sun-halo.png"
        sonHaloNode?.geometry?.firstMaterial?.lightingModel = .constant
        sonHaloNode?.geometry?.firstMaterial?.writesToDepthBuffer = false
        sonHaloNode?.opacity = 0.9
        sunNode?.addChildNode(sonHaloNode!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// 全局追踪
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
//        configuration.isAutoFocusEnabled = true
        /// 自适应灯光(室内室外灯光环境切换)
//        arSessionConfiguation = configuration
//        arSessionConfiguation?.isLightEstimationEnabled = true
        
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
