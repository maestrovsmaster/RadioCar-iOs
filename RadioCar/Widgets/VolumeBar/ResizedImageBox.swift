import SwiftUICore
struct ResizedImageBox: View {
    let size: CGFloat
    let heightPercent: Float
    let isFilled: Bool
    let color: Color
    var onValueChange: (() -> Void)? = nil

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                Image(systemName: isFilled ? "square.fill" : "square")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size / 4 + CGFloat(size - size / 4) * CGFloat(heightPercent))
                    .foregroundColor(color.opacity(isFilled ? 1 : 0.5))
                    .onTapGesture {
                        onValueChange?()
                    }
            }
            .frame(width: size, height: geo.size.height)
        }
        .frame(width: size)
    }
}

