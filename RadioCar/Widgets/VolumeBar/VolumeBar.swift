import SwiftUI

struct VolumeBar: View {
    @Binding var volume: Float
    let segmentsCount: Int
    let color: Color
    var onValueChange: ((Float) -> Void)? = nil

    private var step: Float {
        1.0 / Float(segmentsCount)
    }

    private var items: [VolumeItem] {
        (0..<segmentsCount).map { i in
            let segmentVolume = step + Float(i) * step
            let isFilled = volume >= segmentVolume
            return VolumeItem(volume: segmentVolume, isFilled: isFilled)
        }
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(items) { item in
                ResizedImageBox(
                    size: 36,
                    heightPercent: item.volume,
                    isFilled: item.isFilled,
                    color: color
                ) {
                    onValueChange?(item.volume)
                    volume = item.volume
                }
            }
        }
        .frame(height: 50)
    }
}
