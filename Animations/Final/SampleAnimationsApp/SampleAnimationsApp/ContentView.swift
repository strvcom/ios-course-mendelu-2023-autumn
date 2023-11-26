//
//  ContentView.swift
//  SampleAnimationsApp
//
//  Created by Matej Molnár on 14.11.2023.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State var usesSpriteKit = true

    var body: some View {
        VStack {
            Toggle("Uses SpriteKit", isOn: $usesSpriteKit)
                .padding(.horizontal, 20)

            Group {
                if usesSpriteKit {
                    SpriteView(
                        scene: EmojiLoadingScene(),
                        options: [.allowsTransparency]
                    )
                } else {
                    EmojiLoadingView()
                }
            }
            .frame(width: 300, height: 300)
        }
    }
}

#Preview {
    ContentView()
}
