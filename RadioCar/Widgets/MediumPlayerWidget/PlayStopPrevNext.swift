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
            
            Button(action: {
                if playerState.isPlaying {
                    playerState.pause()
                } else if let station = playerState.currentStation {
                    playerState.playStation(station)
                }
            }) {
                Image(systemName: playerState.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
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
    
}


