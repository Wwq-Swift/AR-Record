//
//  ARSCNView + Extention.swift
//  AR_One
//
//  Created by kris.wang on 2018/11/27.
//  Copyright © 2018年 kris.wang. All rights reserved.
//

import ARKit

extension ARSCNView {
    
    func worldVector(for position: CGPoint) -> SCNVector3? {
        let results = self.hitTest(position, types: .featurePoint)
        guard let result = results.first else {
            return nil
        }
        
        return SCNVector3.positionTrasform(result.worldTransform)
    }
}
