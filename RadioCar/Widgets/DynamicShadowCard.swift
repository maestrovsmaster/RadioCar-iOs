import SwiftUI

struct DynamicShadowCard<Content: View>: View {
    var contentColor: Color
    var brush: LinearGradient
    var elevation: CGFloat = 10
    let content: Content

    init(
        contentColor: Color,
        brush: LinearGradient = LinearGradient(
            colors: [Color.white, Color.gray], // заміни на свій backgroundBrush
            startPoint: .top,
            endPoint: .bottom
        ),
        elevation: CGFloat = 10,
        @ViewBuilder content: () -> Content
    ) {
        self.contentColor = contentColor
        self.brush = brush
        self.elevation = elevation
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(
                brush
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: contentColor.opacity(1.0), radius: elevation, x: 0, y: elevation / 2)
    }
}
