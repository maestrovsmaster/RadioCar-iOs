//
//  ControlsWidget.swift
//  RadioCar
//
//  Created by Maestro Master on 29/07/2025.
//

import SwiftUI

import SwiftUI

struct ControlsWidget: View {
    var body: some View {
        VStack(spacing: 6) {
            Spacer()
            
            ControlIconButton(systemName: "phone.fill", color: .green) {
                openDialer()
            }
            Spacer()
            ControlIconButton(systemName: "map.fill", color: .blue) {
                openMapsApp()
            }
            Spacer()
            ControlIconButton(systemName: "gearshape.fill",color: .gray) {
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            AppColors.grad1.opacity(0.9),
                            AppColors.darkBrush.opacity(0.8),
                            AppColors.grad2.opacity(1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    

}


private func openDialer() {
    if let url = URL(string: "telprompt://") {
        UIApplication.shared.open(url) { success in
            if !success {
                // Handle the case where the URL couldn't be opened
                print("Failed to open dialer with telprompt://")
                // Fallback to tel:// if telprompt:// isn't supported for some reason (very rare)
                if let telURL = URL(string: "tel://") {
                    UIApplication.shared.open(telURL) { success in
                        if !success {
                            print("Failed to open dialer with tel://")
                            // You might want to show an alert to the user here
                        }
                    }
                }
            }
        }
    }
}

private func openMapsApp() {
    if let url = URL(string: "http://maps.apple.com/") {
        UIApplication.shared.open(url)
    }
}


struct ControlsWidget_Previews: PreviewProvider {
    static var previews: some View {
        ControlsWidget()
        
    }
}
