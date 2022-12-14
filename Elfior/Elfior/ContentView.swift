//
//  ContentView.swift
//  Elfior
//
//  Created by Pierpaolo Siciliano on 12/12/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene = SKScene(fileNamed: "Scene")!
    
    var body: some View {
        SpriteView(scene: self.scene)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
