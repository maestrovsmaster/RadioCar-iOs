import SwiftUICore
import SwiftUI

struct MediumPlayerView: View {
    @ObservedObject private var playerState = PlayerState.shared
    private let repository: StationRepository

    init() {
        let container = DependencyContainer()
        self.repository = container.stationRepository
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [AppColors.grad1.opacity(0.9), AppColors.darkBrush.opacity(0.8), AppColors.grad2.opacity(1.0)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
            
            VStack {
                Spacer() // штовхає все вниз

                    if playerState.isPlaying {
                    LottieView(animationName: "anim_wave")
                        .frame(height: 354)
                        .padding(.bottom, -150)
                        .allowsHitTesting(false) // Дозволяє кнопкам під анімацією приймати тапи
                }
            }
        
       // .frame(height: 70)
            
            VStack(spacing: 8) {
                Spacer()
                HStack(spacing: 12) {

                    StationImageCoverWidget(imageUrl : playerState.currentStation?.favicon)

                    VStack(alignment: .leading, spacing: 4) {

                        Text(playerState.currentStation?.name ?? "Choose station")
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(2)

                        // Show song metadata if available
                        if let metadata = playerState.songMetadata, !metadata.isEmpty {
                            HStack(spacing: 6) {
                                Image(systemName: "music.note")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))

                                MarqueeText(text: metadata, font: .subheadline, speed: 30)
                                    .foregroundColor(.white.opacity(0.9))
                                    .frame(height: 20)
                            }
                        } else if playerState.isPlaying && playerState.songMetadata == nil {
                            // Only show "Loading..." if we haven't attempted to load metadata yet
                            HStack(spacing: 4) {
                                ProgressView()
                                    .scaleEffect(0.7)
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white.opacity(0.6)))

                                Text("Loading metadata...")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }

                    }

                    Spacer()
                }
                .padding(.horizontal)

                // Action buttons row
                HStack(spacing: 16) {
                    
                    LikeWidget(isLiked: playerState.currentStationGroup?.isFavorite) {
                        Task {
                            await toggleFavorite()
                        }
                    }
                    .frame(width: 44, height: 44)

                    Spacer()
                        .frame(width: 20)

                    ReportWidget {
                        Task {
                            sendReport()
                        }
                    }
                    .frame(width: 44, height: 44)
                }
                .padding(.horizontal)
                .allowsHitTesting(true)

                VolumeBarView(
                    volume: $playerState.volume,
                    segmentsCount: 10,
                    color: .white
                )
                .frame(height: 24)
                
                Spacer()
                
                PlayStopPrevNextView()


            }.padding(.horizontal, 8)
             .padding(.vertical, 4)
        }
        .clipped() // Prevents content from overflowing
    }

    // MARK: - Actions

    /// Toggle favorite status for current station
    private func toggleFavorite() async {
        guard let stationGroup = playerState.currentStationGroup else {
            return
        }

        guard let firstStationUuid = stationGroup.stations.first?.stationuuid else {
            return
        }

        do {
            let newFavoriteState = !(stationGroup.isFavorite)

            if newFavoriteState {
                try await repository.addToFavorites(stationUuid: firstStationUuid)
            } else {
                try await repository.removeFromFavorites(stationUuid: firstStationUuid)
            }

            // Update PlayerState
            playerState.updateFavoriteStatus(isFavorite: newFavoriteState)

        } catch {
            print("Failed to toggle favorite: \(error)")
        }
    }

    /// Send report email for current station
    private func sendReport() {
        guard let stationName = playerState.currentStation?.name else {
            return
        }

        EmailHelper.sendReportEmail(stationName: stationName)
    }
}

struct MediumPlayer_Previews: PreviewProvider {
    static var previews: some View {
            MediumPlayerView()
        
    }
}
