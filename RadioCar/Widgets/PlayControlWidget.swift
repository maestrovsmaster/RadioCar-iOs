//
//  PlayControlWidget.swift
//  RadioCar
//
//  Created by Maestro Master on 24/07/2025.
//

import SwiftUI

struct PlayControlWidget: View {
    var isPlaying: Bool
    var isLoading: Bool = false
    var onPrevClick: () -> Void
    var onPlayPauseClick: () -> Void
    var onNextClick: () -> Void


    var body: some View {
        HStack {
            Button(action: onPrevClick) {
                Image("ic_prev_32")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(AppColors.tintColor)
            }

            Spacer()

            Button(action: onPlayPauseClick) {
                ZStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppColors.tintColor))
                            .frame(width: 52, height: 52)
                    } else {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color(red: 176/255, green: 220/255, blue: 245/255))
                            .frame(width: 52, height: 52)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            Spacer()

            Button(action: onNextClick) {
                Image("ic_next_32")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(AppColors.tintColor)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(Color.black)
    }
}

struct PlayControlWidget_Previews: PreviewProvider {
    static var previews: some View {
        PlayControlWidget(
            isPlaying: true,
            onPrevClick: { print("Prev tapped") },
            onPlayPauseClick: { print("Play/Pause tapped") },
            onNextClick: { print("Next tapped") }
        )
        .frame(width: 200)
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}
