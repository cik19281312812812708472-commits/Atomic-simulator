//
//  ContentView.swift
//  Atomic simulator
//
//  Created by Desire on 2026-02-21.
//

import SwiftUI
import _SpriteKit_SwiftUI

struct MacSpriteView: NSViewRepresentable {
    let scene: SKScene

    func makeNSView(context: Context) -> SKView {
        let view = SKView()
        view.allowsTransparency = true
        // This ensures the view starts listening for mouse/scroll immediately
        DispatchQueue.main.async {
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    func updateNSView(_ nsView: SKView, context: Context) {
        if nsView.scene == nil {
            nsView.presentScene(scene)
        }
    }
}

enum AppStateBlueprint {
    
    case begining
    case worldselection
    case createworld
    case game
    
}


struct ContentView: View {
    
    @State private var appState: AppStateBlueprint = .begining
    @State private var numofWorlds = UserDefaults.standard.object(forKey: "numofWorlds") as? Int ?? 3
    @State private var WorldNames = UserDefaults.standard.object(forKey: "WorldNames") as? [Int:String] ??  [1:"World 1", 2:"World 2", 3:"World 3"]
    @State private var animationdone = false
    @State private var titleY = 1.0
    @State private var world = 1
    
    @State private var atomicScene: AtomicScene = {
        let scene = AtomicScene()
        scene.scaleMode = .resizeFill
        return scene
        
        
    }()
    
    ///a custom var to save the last location
    @State private var lastloc: AppStateBlueprint = .begining
    func saveData() {
        
        UserDefaults.standard.set(numofWorlds, forKey: "numofWorlds")
        UserDefaults.standard.set(WorldNames, forKey: "WorldNames")
        
    }
    
    
    
    var body: some View {
        
        
        //MARK: Switch statement
        
        switch appState {
            
        case .begining:
            
            
            
            GeometryReader { geometry in
               
                ZStack {
                    Color(red: 0.03529411764, green: 0.10588235294, blue: 0.02352941176)
                    
                    Image("Particle Sim Title")
                        .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.1)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.11)
                    
                    
                    
                    VStack {
                        
                
                        Button {
                            
                            appState = .worldselection
                            lastloc = .begining
                        } label: {
                            
                            Text("Start")
                                .font(.system(size: 50, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.1)
                            
                                .background (
                                    
                                    RoundedRectangle(cornerRadius: 160)
                                        .fill(Color.red.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 160)
                                                .stroke(
                                                    style: StrokeStyle(lineWidth: 2, dash: [])
                                                      
                                                )
                                            )
                                        .cornerRadius(10)
                                    
                                    
                                    
                                )
                            
                        }
                        .buttonStyle(ShrinkingButton())
                        
                    }//VStack end
                   
                    
                }//ZStack end
                
            }
            .ignoresSafeArea()
            
            
            
            
        case .worldselection:
            
            GeometryReader { geometry in
                
                ZStack {
                    Color(red: 0.03529411764, green: 0.10588235294, blue: 0.02352941176)
                    VStack {
                        
                        ForEach(0..<numofWorlds, id: \.self) { i in
                            
                            
                            Button {
                                
                                world = i
                                appState = .game
                                
                            } label: {
                                
                                Text("\(WorldNames[i+1, default: "Unknown World"])")
                                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.1)
                                
                                    .background (
                                        
                                        RoundedRectangle(cornerRadius: 160)
                                            .fill(Color.red.opacity(0.3))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 160)
                                                    .stroke(
                                                        style: StrokeStyle(lineWidth: 2, dash: [])
                                                    
                                                    )
                                                )
                                            .cornerRadius(10)
                                    )
                                
                            } // button end
                            .buttonStyle(ShrinkingButton())
                        } // for each end
                        
                    } //vstack end
                    
                    Button {
                        
                        lastloc = appState
                        appState = .begining
                        
                        
                    } label: {
                        
                        Text("Back")
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.1)
                            
                            .background (
                                
                                RoundedRectangle(cornerRadius: 160)
                                    .fill(Color.red.opacity(0.3))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 160)
                                            .stroke(
                                                style: StrokeStyle(lineWidth: 2, dash: [])
                                            
                                            )
                                        )
                                    .cornerRadius(10)
                            )
                        
                    } // button end
                    .buttonStyle(ShrinkingButton())
                    .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.9)
                    
                    
                    Button {
                        
                        lastloc = appState
                        appState = .createworld
                        
                        
                    } label: {
                        
                        Text("Create world")
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: geometry.size.width * 0.1, height: geometry.size.height * 0.1)
                            
                            .background (
                                
                                RoundedRectangle(cornerRadius: 160)
                                    .fill(Color.red.opacity(0.3))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 160)
                                            .stroke(
                                                style: StrokeStyle(lineWidth: 2, dash: [])
                                            
                                            )
                                        )
                                    .cornerRadius(10)
                            )
                        
                    } // button end
                    .buttonStyle(ShrinkingButton())
                    .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.9)
                    
                    
                    
                }//ZStack end
                
            }//geo end
            .ignoresSafeArea()
           
                
            
            
            
        case .game://MARK: GAME CODE
       
            //copied from AI
            MacSpriteView(scene: atomicScene)
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
          
            
        case .createworld: //MARK: CREATE WORLD
            
            GeometryReader { geometry in
                ZStack {
                    
                    VStack {
                            
                            Button {
                                
                                appState = .worldselection
                                
                            } label: {
                                
                                Text("WILL BE WORKED ON")
                                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.1)
                                
                                    .background (
                                        
                                        RoundedRectangle(cornerRadius: 160)
                                            .fill(Color.red.opacity(0.3))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(
                                                        style: StrokeStyle(lineWidth: 2, dash: [])
                                                    
                                                    )
                                                )
                                            .cornerRadius(10)
                                        
                                        
                                        
                                    )
                                
                            }
                        
                    }//Vstack end
                    
                    
                }
                
            }//geomertry end
            .ignoresSafeArea()
            
            
        }
        
        
        
        
        
    }
}

//copied from the Iron Bean
struct ShrinkingButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
    
    
    
}


#Preview {
    ContentView()
}
