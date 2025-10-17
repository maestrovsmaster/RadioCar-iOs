import SwiftUI

struct LikeWidget: View {
    var isLiked: Bool?
    var onLikeClick: () -> Void

    var body: some View {
        if let liked = isLiked {
            Button(action: onLikeClick) {
                Image(systemName: liked ? "heart.fill" : "heart")
                    .foregroundColor(AppColors.grayLight)
                    .accessibilityLabel("Like")
            }
            .buttonStyle(.plain)
        }
    }
}

struct LikeWidget_Previews: PreviewProvider {
    static var previews: some View {
        LikeWidget(isLiked: true) {
            print("Liked toggled")
        }
        .frame(width: 36, height: 36)
    }
}
