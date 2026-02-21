//
//  AtomicScene.swift
//  Atomic simulator
//
//  Created by Desire on 2026-02-21.
//

import SpriteKit
import GameplayKit


@Observable

class AtomicScene: SKScene {
    
    
    var world = 1
    var Particlepos = [1:CGPoint(x: 0.0, y: 0.0)]
    
    
    func SetWorld(theworld: Int) {
        
        world = theworld
    }
    
    
    
    func GetData() {
        Particlepos = UserDefaults.standard.object(forKey: "Particlepos \(world)") as? [Int:CGPoint] ?? [1:CGPoint(x: 0.0, y: 0.0)]
        
    }
  
    
    func StoreData() {
        
        UserDefaults.standard.set(Particlepos, forKey: "Particlepos \(world)")
    }
    
    
    
    override func didMove(to view: SKView) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
    }
    
    
    class Particle: SKShapeNode {
        ///Mass in atomic units
        let mass = 0.0
        
        
        init(particleTexture: SKTexture) {
            
            
            
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }//MARK: PARTICLE CLASS END
    
    
    
}//MARK: Atomic Scene end


