import SwiftUICore
import SwiftUI

struct MediumPlayerView: View {
    @ObservedObject private var playerState = PlayerState.shared
    
    
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
                }
            }
        
       // .frame(height: 70)
            
            VStack(spacing: 16) {
                Spacer()
                HStack(spacing: 12) {
                    
                    StationImageCoverWidget(imageUrl : playerState.currentStation?.favicon)
                    
                    VStack(){
                        
                        Text(playerState.currentStation?.name ?? "Choose station")
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(2)
                      
                    }
                    

                    
                    
                    Spacer()
                }
                .padding(.horizontal)
            
                
                VolumeBarView(
                    volume: $playerState.volume,
                    segmentsCount: 10,
                    color: .white
                )
                .frame(height: 30)
                
                Spacer()
                
                PlayStopPrevNextView()
                
                
            }.padding()
            
      
            
        }.padding().frame(width: 20, height: 30)
    }
}

struct MediumPlayer_Previews: PreviewProvider {
    static var previews: some View {
            MediumPlayerView()
        
    }
}
