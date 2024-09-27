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
    @State private var isShowing: Bool = false
    @State private var cube: Entity?
    
    var body: some View {

        RealityView { content, attachments in
            
            do {
                let localEntity = try await Entity(named: "Cube")
                cube = localEntity
                cube?.position = [0.0, 0.0, 0.0]
                cube?.components.set(InputTargetComponent())
                if let bounds = cube?.visualBounds(relativeTo: cube) {
                    let size = bounds.extents // Get the size of the cube
                    let collisionShape = ShapeResource.generateBox(size: size)
                    cube?.components.set(CollisionComponent(shapes: [collisionShape]))
                }
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
            if isShowing {
                if let text = attachments.entity(for: "cube1") {
                    text.position = [0, 0.2, 0.25]
                    
                    content.entities.first?
                        .findEntity(named: "Cube")?
                        .addChild(text, preservingWorldTransform: true)
                }
            } else {
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
                .targetedToEntity(cube ?? Entity())
                .onEnded { _ in
                    isTapped.toggle()
                    if isTapped {
                        isShowing = true
                        // remove this if you want it to stay
                        Task {
                            try await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
                            isShowing = false
                        }
                    } else {
                        isShowing = false
                    }
                }
        )
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
