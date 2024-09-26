//
// ---------------------------- //
// Original Project: TapAttachment
// Created on 2024-09-26 by Tim Mitra
// Mastodon: @timmitra@mastodon.social
// Twitter/X: timmitra@twitter.com
// Web site: https://www.it-guy.com
// ---------------------------- //
// Copyright © 2024 iT Guy Technologies. All rights reserved.


import SwiftUI
import RealityKit

struct ContentView: View {
    @State private var isTapped: Bool = false
   // @State var cube = Entity()
    //let cube = try! Entity.load(named: "Cube")
    @State private var cube: Entity?
    
    var body: some View {
        Text("Hello World!")
        RealityView { content, attachments in
            
            //cube = ModelEntity(mesh: .generateBox(width: 0.1, height: 0.1, depth: 0.1), materials: [SimpleMaterial(color:.white, isMetallic: false)])
            do {
                let localEntity = try await Entity(named: "Cube")
                cube = localEntity
                cube?.position = [0.0, 0.0, 0.0]
                cube?.components.set(InputTargetComponent())
                cube?.components.set(CollisionComponent(shapes: [.generateBox(width: 0.1, height: 0.1, depth: 0.1)]))
                guard let cube else {
                    print("can't find cube")
                    return
                }
                print("found cube")
                content.add(cube)
            } catch {
                print("can't find cube")
            }
            
        } update: { content, attachments in
            if isTapped {
                if let text = attachments.entity(for: "cube1") {
                    text.position = [0, 0.2, 0]
                    
                    content.entities.first?
                        .findEntity(named: "Cube")?
                        .addChild(text, preservingWorldTransform: true)
                }
            } else {
                // Hide the attachment by removing it from the parent
                if let text = attachments.entity(for: "cube1") {
                    content.entities.first?
                        .findEntity(named: "Cube")?
                        .removeChild(text)
                }
            }
        } attachments: {
            Attachment(id: "cube1") {
                Text("Cube 1")
                    .font(.extraLargeTitle)
            }
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity(/*cube ?? Entity()*/)
                .onEnded { _ in
                    isTapped = true
                    Task {
                        try await Task.sleep(nanoseconds: 100_000_000)
                        isTapped = false
                    }
                }
        )
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
