//
//  MarqueeText.swift
//  RadioCar
//

import SwiftUI

struct MarqueeText: View {
    let text: String
    let font: Font
    let speed: Double

    @State private var textWidth: CGFloat? = nil
    @State private var containerWidth: CGFloat? = nil
    @State private var animationOffset: CGFloat = 0
    @State private var hasStartedAnimation = false

    var body: some View {
        GeometryReader { geo in
            let containerW = geo.size.width

            HStack(spacing: 0) {
                Text(text)
                    .font(font)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .background(
                        GeometryReader { textGeo -> Color in
                            DispatchQueue.main.async {
                                let newTextWidth = textGeo.size.width
                                let newContainerWidth = containerW

                                // Only start animation once
                                if !hasStartedAnimation && newTextWidth > newContainerWidth {
                                    self.textWidth = newTextWidth
                                    self.containerWidth = newContainerWidth
                                    self.hasStartedAnimation = true
                                    startAnimation(textWidth: newTextWidth, containerWidth: newContainerWidth)
                                }
                            }
                            return Color.clear
                        }
                    )
                    .offset(x: animationOffset)
            }
            .frame(width: containerW, alignment: .leading)
            .clipped()
        }
        .frame(height: fontSizeToHeight(font: font))
    }

    func startAnimation(textWidth: CGFloat, containerWidth: CGFloat) {
        // Start from right side (containerWidth)
        // Move to left until text completely exits (-textWidth)
        let distance = textWidth + containerWidth
        let duration = distance / CGFloat(speed)

        // Set initial position to right
        animationOffset = containerWidth

        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
            // Move to left (negative direction)
            animationOffset = -textWidth
        }
    }

    func fontSizeToHeight(font: Font) -> CGFloat {
        switch font {
        case .largeTitle: return 34
        case .title: return 28
        case .title2: return 22
        case .title3: return 20
        case .headline: return 17
        case .body: return 17
        case .callout: return 16
        case .subheadline: return 15
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        default: return 17
        }
    }
}

