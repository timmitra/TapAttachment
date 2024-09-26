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
    let cube = try? Entity.load(named: "Cube.usdz")
    @State private var isTapped: Bool = false
    
    var body: some View {
        RealityView { content, attachments in
        } update: { content, attachments in
        } attachments: {
            
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
