//
//  ControlsWidget.swift
//  RadioCar
//
//  Created by Maestro Master on 29/07/2025.
//

import SwiftUI

import SwiftUI

struct ControlsWidget: View {
    var onBluetoothTap: (() -> Void)?
    var onSettingsTap: (() -> Void)?

    var body: some View {
        VStack(spacing: 6) {
            Spacer()

           /* ControlIconButton(systemName: "bluetooth", color: AppColors.blue) {
                print("📡 Bluetooth button tapped")
                onBluetoothTap?()
            }*/
            ControlImageButton(imageName: "bluetooth_24dp", backgroundColor: AppColors.blue) {
                print("📡 Bluetooth button tapped")
                onBluetoothTap?()
            }
            Spacer()
            ControlIconButton(systemName: "map.fill", color: AppColors.green) {
                openMapsApp()
            }
            Spacer()
            ControlIconButton(systemName: "gearshape.fill", color: AppColors.gray) {
                print("⚙️ Settings button tapped")
                onSettingsTap?()
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
