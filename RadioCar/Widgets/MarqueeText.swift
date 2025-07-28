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

    var body: some View {
        GeometryReader { geo in
            let containerW = geo.size.width

            HStack {
                Text(text)
                    .font(font)
                    .background(
                        GeometryReader { textGeo -> Color in
                            DispatchQueue.main.async {
                                self.textWidth = textGeo.size.width
                                self.containerWidth = containerW
                                if textGeo.size.width > containerW {
                                    startAnimation(textWidth: textGeo.size.width, containerWidth: containerW)
                                }
                            }
                            return Color.clear
                        }
                    )
                    .offset(x: animationOffset)
            }
            .clipped()
        }
        .frame(height: fontSizeToHeight(font: font))
    }

    func startAnimation(textWidth: CGFloat, containerWidth: CGFloat) {
        let distance = textWidth + containerWidth
        let duration = distance / CGFloat(speed)

        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
            animationOffset = -distance
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

