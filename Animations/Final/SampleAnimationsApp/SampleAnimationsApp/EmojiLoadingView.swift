//
//  EmojiLoadingView.swift
//  SampleAnimationsApp
//
//  Created by Matej Molnár on 17.11.2023.
//

import SwiftUI

struct EmojiLoadingView: View {
    private let imageNames = Emojis.allCases.map { $0.rawValue }

    var body: some View {
        /// We need to specify spacing: 0, because HStack has a default spacing.
        HStack(spacing: 0) {
            ForEach(imageNames.indices, id: \.self) { index in
                Emoji(imageName: imageNames[index], delay: Double(index) * 0.2)
            }
        }
    }
}

struct Emoji: View {
    let imageName: String
    let delay: TimeInterval

    @State private var animationProgress: CGFloat = 0

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .modifier(
                /// Unfortunately the desired animation is not simple enough to be achieved without
                /// implementing a custom ViewModifier that conforms to Animatable protocol.
                RotationAndScaleModifier(progress: animationProgress)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 0.6)
                    .delay(0.6)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    animationProgress = 1
                }
            }
    }
}

struct RotationAndScaleModifier: ViewModifier, Animatable {
    /// A value between 0..1 based on which we are going to be calculating degrees and scale.
    var progress: CGFloat

    /// SwiftUI uses this property to animate changes over time by interpolating over this value.
    /// Without this property the scale animation won't work properly.
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    var degrees: CGFloat {
        -360 * progress
    }

    var scale: CGFloat {
        if progress < 0.5 {
            return 1 + progress
        } else {
            return 2 - progress
        }
    }

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(degrees))
            .scaleEffect(scale)
    }
}

#Preview {
    EmojiLoadingView()
        .frame(width: 300)
}
