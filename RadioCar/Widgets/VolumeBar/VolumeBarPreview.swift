import SwiftUICore
import SwiftUI
struct VolumeBarPreview: View {
    @State private var currentVolume: Float = 0.6

    var body: some View {
        ZStack {
            AppColors.black.edgesIgnoringSafeArea(.all)

            VolumeBar(volume: $currentVolume, segmentsCount: 10, color: AppColors.baseBlue) { newVolume in
                print("VolumeBarPreview: \(newVolume)")
            }
            .padding(16)
            .frame(width: 200, height: 50)
        }
    }
}

struct VolumeBarPreview_Previews: PreviewProvider {
    static var previews: some View {
        VolumeBarPreview()
    }
}
