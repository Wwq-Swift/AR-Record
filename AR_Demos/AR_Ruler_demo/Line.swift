//
//  Line.swift
//  AR_One
//
//  Created by kris.wang on 2018/11/27.
//  Copyright © 2018年 kris.wang. All rights reserved.
//

import ARKit

/// 长度单位
///
/// - meter: 米
/// - cenitMeter: 厘米
/// - inch: 英寸
enum lengthUnit: String {
    
    case meter = "m"
    case cenitMeter = "cm"
    case inch = "inch"
    
    var factor: CGFloat {
        get {
            switch self {
            case .meter:
                return 1.0
            case .cenitMeter:
                return 100.0
            case .inch:
                return 39.3700787
            }
        }
    }
}

class Line {
    
    private let sceneView: ARSCNView!
    
    // 线的开头节点 和 结尾节点
    private var startPointNode: SCNNode!
    private var endPointNode: SCNNode!
    // 文本节点
    private lazy var textNode: SCNNode = SCNNode()
    private lazy var text: SCNText = SCNText(string: "", extrusionDepth: 0.1)
    // 线节点
    private var lineNode: SCNNode?
    
    /// 开始的真实世界坐标
    private var startVector: SCNVector3
    // 单位
    private var unit: lengthUnit = .meter
    
    init(sceneView: ARSCNView, startVector: SCNVector3, unit: lengthUnit = .meter) {
        self.startVector = startVector
        self.unit = unit
        self.sceneView = sceneView
        
        /// 开始的点
        let dot = SCNSphere(radius: 0.5)
        dot.firstMaterial?.diffuse.contents = UIColor.red
        dot.firstMaterial?.lightingModel = .constant      /// 。constant 照明模式 均匀平铺
        dot.firstMaterial?.isDoubleSided = true   // 表面是否光泽
        
        startPointNode = SCNNode(geometry: dot)
        startPointNode.position = startVector
        startPointNode.scale = SCNVector3(1/500.0,1/500.0,1/500.0)
        
        endPointNode = SCNNode(geometry: dot)
        endPointNode.scale = SCNVector3(1/500.0,1/500.0,1/500.0)
        
        sceneView.scene.rootNode.addChildNode(startPointNode)
        sceneView.scene.rootNode.addChildNode(endPointNode)
        
        setupText()
    }
    
    /// 创建文本
    private func setupText() {
        text.font = .systemFont(ofSize: 5)
        text.firstMaterial?.diffuse.contents = UIColor.blue
        text.firstMaterial?.lightingModel = .constant
        text.firstMaterial?.isDoubleSided = true //表面关泽
//        text.alignmentMode = kCAAlignmentCenter
//        text.truncationMode = kCATruncationMiddle // ...
        
        let textStrNode = SCNNode(geometry: text)
        /// 使字体 面对着手机摄像头
//        textStrNode.eulerAngles = SCNVector3Make(0, .pi, 0)
        
        textNode.addChildNode(textStrNode)
        
        // 将文字节点设置约束  将文字节点与线进行绑定， 始终在线的正中心
        let constraint = SCNLookAtConstraint(target: sceneView.pointOfView)
        //        SCNLookAtConstraint 是一种约束， 让它跟随我设定的目标
        //        永远面向手机
        constraint.isGimbalLockEnabled = true // 默认flse
        
        textNode.constraints = [constraint] // 添加約束
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    /// 更新线视图
    func update(to vector: SCNVector3) {
        lineNode?.removeFromParentNode()
        
        lineNode = SCNNode.createLine(fromVector: startVector, toVector: vector)
        sceneView.scene.rootNode.addChildNode(lineNode!)
        
        text.string = distanceStr(to: vector)
        textNode.position = SCNVector3((startVector.x + vector.x) / 2.0 , (startVector.y + vector.y) / 2.0 ,(startVector.z + vector.z) / 2.0 )
        
        endPointNode.position = vector
        
        if endPointNode.parent == nil {
            sceneView.scene.rootNode.addChildNode(endPointNode)
        }
    }
    
    /// 两点间距离字符串
    private func distanceStr(to vector: SCNVector3) -> String {
        let distance = startVector.distance(from: vector) * unit.factor
        return distance.description + unit.rawValue
    }
    
    /// 移除线
    func remove() {
        startPointNode.removeFromParentNode()
        endPointNode.removeFromParentNode()
        textNode.removeFromParentNode()
        lineNode?.removeFromParentNode()
    }
}























