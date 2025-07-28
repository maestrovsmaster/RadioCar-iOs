import SwiftUI

struct ControlBackground: View {
    var body: some View {
        GeometryReader { geometry in
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0x3A/255, green: 0x4A/255, blue: 0x57/255).opacity(0xCE / 255.0),
                    Color(red: 0x27/255, green: 0x27/255, blue: 0x2A/255).opacity(0xCE / 255.0),
                    Color(red: 0x27/255, green: 0x27/255, blue: 0x2A/255).opacity(0x4D / 255.0),
                    Color(red: 0x27/255, green: 0x27/255, blue: 0x2A/255).opacity(0xB4 / 255.0),
                    Color(red: 0x27/255, green: 0x27/255, blue: 0x2A/255).opacity(0xC9 / 255.0),
                    Color(red: 0x1E/255, green: 0x2A/255, blue: 0x34/255).opacity(1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: geometry.size.width, height: min(540, geometry.size.height))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
