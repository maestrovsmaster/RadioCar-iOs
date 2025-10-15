//
//  PlayStopPrevNext.swift
//  RadioCar
//
//  Created by Maestro Master on 29/07/2025.
//

import SwiftUICore
import SwiftUI

struct PlayStopPrevNextView: View {
    @ObservedObject private var playerState = PlayerState.shared

    var body: some View {
        HStack(spacing: 40) {
            Button(action: {
                playerState.playPrevious()
            }) {
                Image(systemName: "backward.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }

            ZStack {
                // Play/Pause button
                Button(action: {
                    if playerState.isPlaying {
                        playerState.pause()
                    } else if let station = playerState.currentStation {
                        playerState.playStation(station)
                    }
                }) {
                    Image(systemName: getPlayButtonIcon())
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                }

                // Loading indicator (circular progress)
                if playerState.isBuffering {
                    LoadingRingView()
                        .frame(width: 56, height: 56)
                }
            }

            Button(action: {
                playerState.playNext()
            }) {
                Image(systemName: "forward.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 20)
    }

    private func getPlayButtonIcon() -> String {
        if playerState.isBuffering {
            // Show play icon while buffering (not pause)
            return "play.circle.fill"
        } else if playerState.isPlaying {
            return "pause.circle.fill"
        } else {
            return "play.circle.fill"
        }
    }
}

// Animated loading ring
struct LoadingRingView: View {
    @State private var rotation: Double = 0

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0.9), Color.white.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                ),
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
            .rotationEffect(Angle(degrees: rotation))
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}


