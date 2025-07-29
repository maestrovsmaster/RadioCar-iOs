//
//  VolumeSliderView.swift
//  RadioCar
//
//  Created by Maestro Master on 28/07/2025.
//
import SwiftUI

import SwiftUI

struct VolumeBarView: View {
    @Binding var volume: Float
    let segmentsCount: Int
    let color: Color

    private func segmentVolume(at index: Int) -> Float {
        let step = 1.0 / Float(segmentsCount)
        return step + Float(index) * step
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(0..<segmentsCount, id: \.self) { index in
                let segmentVol = segmentVolume(at: index)
                let isFilled = volume >= segmentVol

                ResizedVolumeSegment(
                    volume: segmentVol,
                    isFilled: isFilled,
                    color: color
                ) {
                    volume = segmentVol
                }
            }
        }
    }
}


struct ResizedVolumeSegment: View {
    let volume: Float
    let isFilled: Bool
    let color: Color
    let onTap: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack {
                //Spacer()
                
                Rectangle()
                    .fill(color.opacity(0.0))
                    .frame(
                        width: geometry.size.width * 0.8, height: ( 1 * geometry.size.height ) - ( 1 * geometry.size.height * CGFloat(volume))
                    )
                    .cornerRadius(3)
                    .onTapGesture {
                        onTap()
                    }
                
                Rectangle()
                    .fill(color.opacity(isFilled ? 1 : 0.4))
                    .frame(
                        width: geometry.size.width * 0.8, height: 4 + 0.8 * geometry.size.height * CGFloat(volume)
                    )
                    .cornerRadius(3)
                    .onTapGesture {
                        onTap()
                    }
            }
        }
        .frame(width: 20, height: 30) // Width of each segment
    }
}


