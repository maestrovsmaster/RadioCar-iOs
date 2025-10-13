//
//  LottieView.swift
//  RadioCar
//
//  Created by Maestro Master on 29/07/2025.
//
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode

    init(animationName: String, loopMode: LottieLoopMode = .loop) {
        self.animationName = animationName
        self.loopMode = loopMode
    }

    func makeUIView(context: Context) -> UIView {
        let container = UIView(frame: .zero)

        let animationView = LottieAnimationView(name: animationName)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        animationView.play()

        container.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: container.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: container.heightAnchor),
            animationView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])

        return container
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

