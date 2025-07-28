import SwiftUI

struct FaviconCard: View {
    let imgURL: String?
    var size: CGFloat = 36

    var body: some View {
        if let imgURL, let url = URL(string: imgURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    placeholder
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                case .failure(_):
                    placeholder
                @unknown default:
                    placeholder
                }
            }
            .frame(width: size, height: size)
        } else {
            placeholder
                .frame(width: size, height: size)
        }
    }

    var placeholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: 0xFF3A4A57), Color(hex: 0xFF1E2A34)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct FaviconCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            FaviconCard(imgURL: "https://www.google.com/favicon.ico")
            FaviconCard(imgURL: nil)
        }
    }
}

