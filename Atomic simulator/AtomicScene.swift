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
    
    var bordersize = 1000.0
    var scrollMonitor: Any?
    var world = 1
    var Particlelookingat = 0
    let k = 2
    var changeConstant = 1.0
    var Particles: [Particle] = []
    var cameraNode: SKCameraNode!
    override var acceptsFirstResponder: Bool { return true }
    // 1. Tell macOS this scene can become the focus

    // 2. Actually become the focus when asked
    override func becomeFirstResponder() -> Bool { return true }

    // 3. Keep the focus even if the mouse moves away
    override func resignFirstResponder() -> Bool { return false }
    
    ///- Some of the stuff here is borrowed/ learned from the solar system sim
    ///
    ///
    
    
    
    enum ParticleTypeBlueprint {
        
        case electron
        case proton
        case neutron
    }
    
    
    
    
    func SetWorld(theworld: Int) {
        
        world = theworld
    }
    
    
    
    //MARK: create a struct that holds the particla data
    func GetData() {
        Particles = UserDefaults.standard.object(forKey: "Particles \(world)") as? [Particle] ?? []
        
    }
  
    
    func StoreData() {
        
        UserDefaults.standard.set(Particles, forKey: "Particles \(world)")
    }
    
    //MARK: create particle
    func CreateParticle(position: CGPoint, type: ParticleTypeBlueprint) {
       
        var setRadius = CGFloat(0.0)
        var setMass: Double = 0.0
        var setCharge: Int = 0
        var setColour: SKColor = .red
        
        switch type {
            
        case .electron:
            setRadius = 5
            setMass = 0.000548579909
            setColour = .blue
            setCharge = -1
        case .proton:
            setRadius = 10
            setMass = 1
            setColour = .red
            setCharge = 1
        case .neutron:
            
            setRadius = 10
            setMass = 1
            setColour = .green
            setCharge = 0
            
        }
        
        var newParticle = Particle(radius: setRadius, mass: setMass, particleColor: setColour, charge: setCharge)
        Particles.append(newParticle)
        addChild(newParticle)
        newParticle.position = position
        
    }
    
    
    func applyForces() {
        
        
        
        for i in 0..<Particles.count {
            
            let thisParticle = Particles[i]
            
            for j in 0..<Particles.count where i != j {
                
                
                let thatParticle = Particles[j]
                
                let distX = thatParticle.position.x - thisParticle.position.x
                let distY = thatParticle.position.y - thisParticle.position.y
                let dx = (thatParticle.position.x - thisParticle.position.x) * (thatParticle.position.x - thisParticle.position.x) + 1.0
                let dy = (thatParticle.position.y - thisParticle.position.y) * (thatParticle.position.y - thisParticle.position.y) + 1.0
                let dist = sqrt(dx+dy + 100)
                
                if (thatParticle.charge + thisParticle.charge > 0 || thatParticle.charge == 0 && thisParticle.charge == 0) && dist < 200 && dist > 30 {
                    
                    thisParticle.dx += (distX/dist) * 15 * (dist - 60)
                    thisParticle.dy += (distY/dist) * 15 * (dist - 60)
                    
                    
                } else if dist < 30 && (thatParticle.charge + thisParticle.charge > 0 || thatParticle.charge == 0 && thisParticle.charge == 0) {
                    thisParticle.dx += 1
                    thisParticle.dy += 1
                    
                } else {
                    
                    
                   
                    let forcemagnitude = CGFloat(k) * (CGFloat(thatParticle.charge * thisParticle.charge) / dist)
                    thisParticle.dx -= (distX / dist) * forcemagnitude
                    thisParticle.dy -= (distY / dist) * forcemagnitude
                    
                }
                
                thisParticle.dx *= changeConstant
                thisParticle.dy *= changeConstant
                
            }
            
            thisParticle.applyForce()
            
            
            
            
        }
        
        
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.isUserInteractionEnabled = true
        
        DispatchQueue.main.async {
                view.window?.makeFirstResponder(view)
            }
        
        scrollMonitor = NSEvent.addLocalMonitorForEvents(matching: .scrollWheel) { [weak self] event in
                    self?.handleScroll(with: event)
                    return event // Pass the event back to the system
                }
        
        view.window?.makeFirstResponder(view)
        
        
        for i in 0..<Int(0.5 * bordersize) {
            let sidelend = 0.5 * bordersize * 10.5
            let x = Double.random(in: -sidelend...sidelend)
            let y = Double.random(in: -sidelend...sidelend)
            
            let type = Int.random(in: 1...3)
            
            var type2: ParticleTypeBlueprint = .electron
            
            switch type {
                
            case 1:
                type2 = .electron
                
            case 2:
            type2 = .proton
            case 3:
                type2 = .electron
            
            default:
                type2 = .proton
                
            }
            
            CreateParticle(position: CGPoint(x: x, y: y) ,type: type2)
            
            
        }
        
        
        
        cameraNode = SKCameraNode()
        
       
        addChild(cameraNode)
        self.camera = cameraNode
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        for i in 0..<Particles.count {
            
                Particles[i].dx *= 0.999
                Particles[i].dy *= 0.999
           // Particles[i].bounceofborder(Bordersize: bordersize)
            
        }
        applyForces()
        
        if Particlelookingat == -1 {
            cameraNode.position = CGPoint(x: 0.0, y: 0.0)
        } else {
            cameraNode.position = Particles[Particlelookingat].position
        }
        
    }
    
    
    override func mouseDown(with event: NSEvent) {
        print("Mouse was clicked!")
    }
    
    
    
    override func willMove(from view: SKView) {
            if let monitor = scrollMonitor {
                NSEvent.removeMonitor(monitor)
            }
        }
    
    
    override func keyDown(with event: NSEvent) {
        
        if event.keyCode == 123 && Particlelookingat - 1 > -2 {
            
            Particlelookingat -= 1
        }
        
        if event.keyCode == 124 && Particlelookingat + 1 < Particles.count - 1 {
            Particlelookingat += 1
        }
        
        
    }
    ///100% ai
    func handleScroll(with event: NSEvent) {
             // Visual confirmation
            
            guard let camera = self.camera else { return }
            
            // Use a multiplier to avoid the 'stuck at 0.2' issue
            let zoomSpeed: CGFloat = 0.05
            let factor = 1.0 - (event.deltaY * zoomSpeed)
            let newScale = camera.xScale * factor
            
            // Clamp it
            let clamped = max(0.1, min(10.0, newScale))
            camera.setScale(clamped)
            
            print("Manual Scroll Capture: \(clamped)")
        }
    
    
    
    
    class Particle: SKShapeNode {
        
        
    
        
        ///Mass in atomic units
        var mass = 0.0
        var particleColour: SKColor = .red
        var radius = CGFloat(0.0)
        var dx = 0.0
        var dy = 0.0
        
        
        
        func allFuncs() {
            
            
        }
        
        /*
        func bounceofborder(Bordersize: Double) {
            
            if self.position.x > Bordersize / 2 || self.position.x < -Bordersize / 2 {
                
              //  self.dx *= -1
                if self.position.x > Bordersize / 2 {
                    self.position.x = Bordersize / 2
                    
                } else {
                    
                    self.position.x = -Bordersize / 2
                }
                
            }
         
            if self.position.y > Bordersize / 2 || self.position.y < -Bordersize / 2 {
                
               // self.dy *= -1
                if self.position.y > Bordersize / 2 {
                    self.position.y = Bordersize / 2
                    
                } else {
                    
                    self.position.y = -Bordersize / 2
                }
            }
        }
        
        */
        func applyForce() {
            self.position.x += CGFloat(dx)
            self.position.y += CGFloat(dy)
        }
        
        ///1 is for positive 0 is for neutral and -1 is for negative
        var charge = 1
        
        init(radius: CGFloat, mass: Double, particleColor: SKColor, charge: Int) {
            
            self.radius = radius
            self.mass = mass
            self.particleColour = particleColor
            ///1 is for positive 0 is for neutral and -1 is for negative
            self.charge = charge
            
            super.init()
            
            let path = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius, height: radius), transform: nil)
            self.path = path
            
            self.fillColor = particleColour
            self.strokeColor = particleColour
            self.lineWidth = 1.0
            self.blendMode = .add
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }//MARK: PARTICLE CLASS END
    
    
    
}//MARK: Atomic Scene end


