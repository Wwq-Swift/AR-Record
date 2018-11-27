//
//  ViewController.swift
//  AR_Ruler_demo
//
//  Created by 王伟奇 on 2018/11/27.
//  Copyright © 2018 王伟奇. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    
    
    private lazy var session = ARSession()
    private lazy var sceneView: ARSCNView = ARSCNView()
//    private
    
    private lazy var vectorZero = SCNVector3()
    /// 测量开始节点  与测量i结束节点
    private lazy var startVector = SCNVector3()
    private lazy var endVector = SCNVector3Zero
    
    /// 所有的线数组
    private var lines: [Line] = []
    
    private var currentLine: Line?
    private var unit = lengthUnit.meter //单位
    
    /// 用于标记当前是否在测量
    private var isMeasuring = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.frame = view.bounds
        view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.session = session
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
//        sceneView.isUserInteractionEnabled = false
        sceneView.addGestureRecognizer(tapGes)
//        view.addGestureRecognizer(tapGes)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
    }
    
    @objc private func tapGesture(sender: UITapGestureRecognizer) {
        if  !isMeasuring {
//            reset() //
            isMeasuring = true
//            targetImageView.image = UIImage(named: "GreenTarget")
        } else {
            isMeasuring = false
            
            if let line = currentLine {
                lines.append(line)
                currentLine = nil
//                targetImageView.image = UIImage(named: "WhiteTarget")
            }
            
        }
    }
    
    /// 扫描
    private func scanWorld() {
        
        /// 去中心
        guard let worldPosition = sceneView.worldVector(for: view.center) else { return }
        
        //
        if isMeasuring {
            if startVector == vectorZero {
                startVector = worldPosition
                currentLine = Line(sceneView: self.sceneView, startVector: startVector, unit: unit)
            }
            
            endVector = worldPosition
            currentLine?.update(to: endVector)
            
            
        }
        
        
    }

}


extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.scanWorld()
        }
    }
}
