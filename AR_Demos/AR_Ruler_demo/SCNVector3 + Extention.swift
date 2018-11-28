//
//  SCNVector3 + Extention.swift
//  AR_One
//
//  Created by kris.wang on 2018/11/27.
//  Copyright © 2018年 kris.wang. All rights reserved.
//

import ARKit

extension SCNVector3 {
    
    //    拿到镜头的坐标
    static func positionTrasform(_ tranform: matrix_float4x4) -> SCNVector3 {
        
        return SCNVector3Make(tranform.columns.3.x, tranform.columns.3.y, tranform.columns.3.z)
    }
    
    /// 获取两点间距离
    func distance(from vector: SCNVector3) -> CGFloat {
        let distanceX = self.x - vector.x
        let distanceY = self.y - vector.y
        let distanceZ = self.z - vector.z
        return CGFloat(sqrtf((distanceX * distanceX) + (distanceY * distanceY) + (distanceZ * distanceZ)))
    }
    
}

extension SCNVector3: Equatable {
    public static func == (vector: SCNVector3, anotherVector: SCNVector3) -> Bool {
        return (vector.x == anotherVector.x) && (vector.y == anotherVector.y) && (vector.z == anotherVector.z)
    }
}

extension SCNNode {
    /// 根据两点 创建一个 线的节点
    static func createLine(fromVector: SCNVector3, toVector: SCNVector3, lineColor: UIColor = .white) -> SCNNode {
        let indices: [UInt32] = [0,1]
        let source = SCNGeometrySource(vertices: [fromVector, toVector])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        let geomtry = SCNGeometry(sources: [source], elements: [element])
        geomtry.firstMaterial?.diffuse.contents = lineColor
        let node = SCNNode(geometry: geomtry)
        return node
    }
}
