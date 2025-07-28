import SwiftUI


struct BitrateWidget: View {
    var bitrate: BitrateOption? = .standard
    var onClick: () -> Void

    var body: some View {
        if let bitrate = bitrate {
            Button(action: onClick) {
                ZStack {
                    Image("ic_rect_36")
                        .renderingMode(.template)
                        .foregroundColor(AppColors.baseBlue.opacity(0.6))

                    Text(text(for: bitrate))
                        .foregroundColor(tint(for: bitrate))
                        .font(.system(size: 9, weight: .semibold))
                }
                .frame(width: 36, height: 36)
                .background(Color.clear)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private func text(for bitrate: BitrateOption) -> String {
        switch bitrate {
        case .hd: return "HD"
        case .high: return "192"
        case .standard: return "128"
        case .low: return "64"
        case .veryLow: return "32"
        }
    }

    private func tint(for bitrate: BitrateOption) -> Color {
        switch bitrate {
        case .hd: return AppColors.tintColor
        case .high: return AppColors.baseBlue
        case .standard, .low: return AppColors.tintColor
        case .veryLow: return Color.red
        }
    }
}

struct BitrateWidget_Previews: PreviewProvider {
    static var previews: some View {
        BitrateWidget(bitrate: .hd) {
            print("Bitrate clicked")
        }
    }
}
