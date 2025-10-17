import SwiftUI

struct ReportWidget: View {
    var onReportClick: () -> Void

    var body: some View {
        Button(action: onReportClick) {
            Image(systemName: "flag.fill") // ← SF Symbol
                .foregroundColor(AppColors.error)
                .accessibilityLabel("Report")
        }
        .buttonStyle(.plain)
    }
}


struct ReportWidget_Previews: PreviewProvider {
    static var previews: some View {
        ReportWidget {
            print("Report clicked")
        }
        .frame(width: 36, height: 36) 
    }
}
