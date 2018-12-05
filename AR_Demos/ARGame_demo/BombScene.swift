//
//  BombScene.swift
//  AR_One
//
//  Created by kris.wang on 2018/12/5.
//  Copyright © 2018年 kris.wang. All rights reserved.
//

import SpriteKit
import ARKit

class BombScene: SKScene {
    
    // 得分
    private var score: Int = 0
    // 定时炸弹的计时器
    private var bombTimer: Timer?
    // 炸弹在的时候 为 true，不在为false
    private lazy var isPlaying: Bool = false
    
    override init(size: CGSize) {
        super.init(size: size)
        let tipLb = createLabelNode(str: "点击屏幕开始", position: CGPoint(x: frame.midX, y: frame.midY))
        addChild(tipLb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isPlaying {
            
            isPlaying = true
            for label in children {
                label.removeFromParent() //移除炸弹
            }
            addBomb()
        } else {
            // 在游戏中
            guard let location = touches.first?.location(in: self) else {
                return
            }
            // 查看节点是否在可视范围内
            for node in children {
                bombTimer?.invalidate()
                //   判断被点击的是否是炸弹
                if node.contains(location), node.name == "Bomb" {
                    /// 得分加一
                    score += 1
                    //0.5 秒消失动作
                    let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                    node.run(fadeOut, completion: {
                        // 移除炸弹
                        node.removeFromParent()
                        self.addBomb()
                    })
                }
            }
        }
    }
    
    // 添加炸弹
    private func addBomb() {
        
        /// 获取当前的 frame
        guard let sceneView = view as? ARSKView,
            let currentFrame = sceneView.session.currentFrame else {
            return
        }
        //    炸弹的随机偏移量
        let xOffset = Float(arc4random_uniform(UInt32(30))) / 10 - 1.5
        let zOffset = Float(arc4random_uniform(UInt32(30))) / 10 + 0.5
        var tranform = matrix_identity_float4x4
        //   设置位置
        tranform.columns.3.x = currentFrame.camera.transform.columns.3.x - xOffset
        tranform.columns.3.z = currentFrame.camera.transform.columns.3.z - zOffset
        tranform.columns.3.y = currentFrame.camera.transform.columns.3.y
        
        let anchor = ARAnchor(transform: tranform)
        sceneView.session.add(anchor: anchor)
        bombTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(bombExplode), userInfo: nil, repeats: false)
    }
    /// 炸弹爆炸
    @objc private func bombExplode() {
        bombTimer?.invalidate()
        /// 更新最高分
        if UserDefaults.standard.integer(forKey: "HighestScore") < score {
            UserDefaults.standard.set(score, forKey: "HighestScore")
        }
        for tnode in children {
            guard let node = tnode as? SKLabelNode else { return }
            node.text = "💥"
            node.name = "Menu"
            //   炸弹爆炸动作
            let scaleExplode = SKAction.scale(to: 50, duration: 1.0)
            node.run(scaleExplode, completion: {
                self.displayMenu()
            })
        }
    }
    
    // 游戏结束的展示
    private func displayMenu() {
        
        let logoPositon = CGPoint(x: frame.midX, y: frame.midY + 30)
        let logoLb = createLabelNode(str: "Game Over!", position: logoPositon)
        
        let infoPosition = CGPoint(x: frame.midX, y: frame.midY - 30)
        let infoLabel = createLabelNode(str: "你被炸飛了", position: infoPosition)
        
        let scorePosition = CGPoint(x: frame.midX, y: infoLabel.frame.midY - 30 * 2 )
        let highScoreLb = createLabelNode(str: score.description, position: scorePosition)
        addChild(logoLb)
        addChild(infoLabel)
        addChild(highScoreLb)
        isPlaying = false
    }
    
    private func createLabelNode(str: String, position: CGPoint) -> SKLabelNode {
        let lb = SKLabelNode(fontNamed: "AvenirNext-Bold")
        lb.fontSize = 50.0
        lb.text = str
        lb.verticalAlignmentMode = .center
        lb.horizontalAlignmentMode = .center
        lb.position = position
        lb.name = "Menu"
        return lb
    }
}
