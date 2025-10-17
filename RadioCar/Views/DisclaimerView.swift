//
//  DisclaimerView.swift
//  RadioCar
//
//  Created by Maestro Master on 17/10/2025.
//

import SwiftUI

struct DisclaimerView: View {
    let onAccept: () -> Void

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    AppColors.darkBlue,
                    Color.black
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // App Icon
                Image("RadioCarLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 26))
                    .shadow(color: Color.white.opacity(0.3), radius: 10, x: 0, y: 4)

                // Title
                Text(AppStrings.disclaimerTitle)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 16)

                // Message
                ScrollView {
                    Text(AppStrings.disclaimerMessage)
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .lineSpacing(4)
                }
                .frame(maxHeight: 200)

                Spacer()

                // Accept Button
                Button(action: onAccept) {
                    Text(AppStrings.disclaimerAgree)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.grad1, AppColors.grad2]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .interactiveDismissDisabled(true) // Prevent swipe to dismiss
    }
}

struct DisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        DisclaimerView(onAccept: {
            print("Disclaimer accepted")
        })
    }
}
