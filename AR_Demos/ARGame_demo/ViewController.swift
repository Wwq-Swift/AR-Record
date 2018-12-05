//
//  ViewController.swift
//  ARGame_demo
//
//  Created by 王伟奇 on 2018/12/5.
//  Copyright © 2018 王伟奇. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {

    private lazy var sceneView = ARSKView()
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        sceneView.delegate = self
        let scene = BombScene(size: sceneView.frame.size)
        sceneView.presentScene(scene)
        view.addSubview(sceneView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = AROrientationTrackingConfiguration() /// 不需要和真实世界交互，速度更快
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        let bomb = SKLabelNode(fontNamed: "AvenirNext-Bold")
        bomb.fontSize = 50.0
        bomb.text = "💣"
        bomb.verticalAlignmentMode = .center
        bomb.horizontalAlignmentMode = .center
        bomb.name = "Bomb"
        return bomb
    }

}

