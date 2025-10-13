//
//  StationImageCoverWidget.swift
//  RadioCar
//
//  Created by Maestro Master on 29/07/2025.
//

import SwiftUICore
import SwiftUI
import SwiftUI

struct StationImageCoverWidget: View {
    var size: CGFloat = 70  // ← параметр з дефолтним значенням
    
   // @ObservedObject private var playerState = PlayerState.shared
    
    var imageUrl: String? = nil
    
    var body: some View {
        if let faviconString = imageUrl, //playerState.currentStation?.favicon,
           let faviconURL = URL(string: faviconString) {
            AsyncImage(url: faviconURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size, height: size)
                        .onAppear {
                            print("🔄 Loading image from: \(faviconURL)")
                        }
                    
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size, height: size)
                        .cornerRadius(8)
                        .onAppear {
                            print("✅ Image loaded from: \(faviconURL)")
                        }
                    
                case .failure(let error):
                    Image(systemName: "exclamationmark.triangle")
                        .frame(width: size, height: size)
                        .onAppear {
                            print("❌ Failed to load image: \(error.localizedDescription)")
                        }
                    
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: 0xFF3A4A57), Color(hex: 0xFF1E2A34)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
        }
    }
}
