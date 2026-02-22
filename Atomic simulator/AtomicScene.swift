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
    
    var scrollMonitor: Any?
    var world = 1
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
    
    
    func CreateParticle(position: CGPoint, type: ParticleTypeBlueprint) {
       
        var setRadius = CGFloat(0.0)
        var setMass: Double = 0.0
        var setCharge: Int = 0
        var setColour: SKColor = .red
        
        switch type {
            
        case .electron:
            setRadius = 0.1
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
        
        
        for i in 0..<100 {
            let x = Int.random(in: -100...100)
            let y = Int.random(in: -100...100)
            CreateParticle(position: CGPoint(x: x, y: y) ,type: .proton)
        }
        
        cameraNode = SKCameraNode()
        
       
        addChild(cameraNode)
        self.camera = cameraNode
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
    }
    
    
    override func mouseDown(with event: NSEvent) {
        print("Mouse was clicked!")
    }
    
    
    
    override func willMove(from view: SKView) {
            if let monitor = scrollMonitor {
                NSEvent.removeMonitor(monitor)
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


