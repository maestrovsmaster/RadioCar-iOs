import SwiftUI

struct LikeWidget: View {
    var isLiked: Bool?
    var onLikeClick: () -> Void
    
    var body: some View {
        if let liked = isLiked {
            Button(action: onLikeClick) {
                Image(liked ? "ic_favorite_24" : "ic_favorite_stroke_24")
                    .renderingMode(.template)
                    .foregroundColor(AppColors.grayLight)
                    .accessibilityLabel("Like")
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct LikeWidget_Previews: PreviewProvider {
    static var previews: some View {
        LikeWidget(isLiked: true) {
            print("Liked toggled")
        }
        .frame(width: 44, height: 44)
    }
}
