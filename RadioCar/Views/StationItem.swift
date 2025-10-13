//
//  StationItem.swift
//  RadioCar
//
//  Created by Maestro Master on 29/07/2025.
//
import SwiftUI

struct StationItemView : View {
    
    let station : Station
    
    @ObservedObject var playerState = PlayerState.shared
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [AppColors.grad1.opacity(0.8), AppColors.darkBrush.opacity(0.8), AppColors.grad2.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
            HStack {
                StationImageCoverWidget(size: 44, imageUrl : station.favicon)
                Text(station.name ?? "") .foregroundColor(.white)
                Spacer()
                
                if playerState.currentStation?.id == station.id && playerState.isPlaying {
                    //Image(systemName: "speaker.wave.2.fill")
                    LottieView(animationName: "anim_music")
                                   .frame(width: 34, height: 34)
                }
            }.padding()
        }.frame(height: 70.0).background(Color.black).onTapGesture {
            if  !playerState.isPlaying || playerState.currentStation?.id != station.id{
                PlayerState.shared.playStation(station)
            }else {
                PlayerState.shared.pause()
            }
            
        }
    }
}



