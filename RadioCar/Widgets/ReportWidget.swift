import SwiftUI

struct ReportWidget: View {
    var onReportClick: () -> Void
    var body: some View {
        Button(action: onReportClick) {
            Image("flag_24dp_")
                .renderingMode(.template)
                .foregroundColor(AppColors.error)
                .accessibilityLabel("Report")
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct ReportWidget_Previews: PreviewProvider {
    static var previews: some View {
        ReportWidget {
            print("Report clicked")
        }
        .frame(width: 44, height: 44) 
    }
}
