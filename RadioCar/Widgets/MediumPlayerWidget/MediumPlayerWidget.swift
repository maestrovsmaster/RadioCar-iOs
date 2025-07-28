import SwiftUICore
import SwiftUI

struct MediumPlayerView: View {
    @ObservedObject private var playerState = PlayerState.shared
    

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                if let faviconString = playerState.currentStation?.favicon,
                   let faviconURL = URL(string: faviconString) {
                    AsyncImage(url: faviconURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 90, height: 90)
                                .onAppear {
                                                print("🔄 Loading image from: \(faviconURL)")
                                            }

                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 90)
                                .cornerRadius(8).onAppear {
                                    print("✅ Image loaded from: \(faviconURL)")
                                }

                        case .failure(let error):
                             Image(systemName: "exclamationmark.triangle")
                                 .onAppear {
                                     print("❌ Failed to load image: \(error.localizedDescription)")
                                 }

                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Color.gray.frame(width: 90, height: 90)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(playerState.currentStation?.name ?? "Choose station")
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)

                    /*if let bitrate = playerState.currentStation?.streams.first?.bitrate {
                        Text("Bitrate: \(bitrate) kbps")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }*/
                }
                Spacer()
            }
            .padding(.horizontal)

           /* if let metadata = playerState.songMetadata, !metadata.isEmpty {
                Text(metadata)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }*/
            
           /* if let title = playerState.songMetadata {
                            Text("🎵 \(title)")
                                .font(.headline)
                                .lineLimit(1)
                        }*/

            Spacer()

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
        .padding()
        .background(Color.blue)
        .cornerRadius(16)
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: 250)
    }
}

/*struct MediumPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let testStation = Station(
            id: UUID(),
            name: "Test Station",
            favicon: "https://example.com/favicon.png", // Ось тут favicon — String
            streams: [Station.Stream(bitrate: 128)]
        )
        PlayerState.shared.currentStation = testStation
        PlayerState.shared.isPlaying = true
        PlayerState.shared.songMetadata = "Test Song - Test Artist"
        return MediumPlayerView()
            .preferredColorScheme(.dark)
            .padding()
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
}*/
