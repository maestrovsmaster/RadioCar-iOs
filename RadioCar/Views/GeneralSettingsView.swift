//
//  GeneralSettingsView.swift
//  RadioCar
//
//  Created by Maestro Master on 15/10/2025.
//

import SwiftUI
import MessageUI

struct GeneralSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showMailComposer = false
    @State private var showMailAlert = false
    @ObservedObject private var settings = SettingsManager.shared

    var body: some View {
        ZStack {
            // Background gradient - black with dark blue
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

            VStack(spacing: 0) {
                // Header with back button and logo
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium))
                            .frame(width: 44, height: 44)
                    }

                    Spacer()

                    // App Icon Logo
                    Image("RadioCarLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 22))

                    Spacer()

                    // Placeholder for symmetry
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 10)

                ScrollView {
                    VStack(spacing: 0) {

                        // About App Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text(AppStrings.aboutApp)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)

                            Text(AppStrings.aboutAppDescription)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                                .italic()
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 16)

                        // Autoplay Setting
                        VStack(alignment: .leading, spacing: 8) {
                            Text(AppStrings.playbackSettings)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 4)

                            Toggle(isOn: $settings.autoplay) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(AppStrings.autoplay)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    Text(AppStrings.autoplayDescription)
                                        .font(.system(size: 13))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .tint(AppColors.grad1)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 16)

                        // Settings Links
                        VStack(spacing: 0) {
                            SettingsRowButton(title: AppStrings.privacyPolicy) {
                                openURL(AppConstants.privacyURL)
                            }

                            Divider()
                                .background(Color.gray.opacity(0.3))
                                .padding(.leading, 16)

                            SettingsRowButton(title: AppStrings.openAPI) {
                                openURL(AppConstants.aboutRadioURL)
                            }

                            Divider()
                                .background(Color.gray.opacity(0.3))
                                .padding(.leading, 16)

                            SettingsRowButton(title: AppStrings.contactUs) {
                                if MFMailComposeViewController.canSendMail() {
                                    showMailComposer = true
                                } else {
                                    showMailAlert = true
                                }
                            }

                            // Leave a review - hidden for now
                            // Divider()
                            //     .background(Color.gray.opacity(0.3))
                            //     .padding(.leading, 16)
                            //
                            // SettingsRowButton(title: AppStrings.leaveReview) {
                            //     openURL(AppConstants.appStoreURL)
                            // }
                        }
                        .padding(.vertical, 8)

                        // App Version
                        VStack(spacing: 8) {
                            Text("\(AppStrings.appVersion): \(AppConstants.appVersion)")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.top, 16)

                            Text(AppConstants.copyrightText)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showMailComposer) {
            MailComposeView(
                recipient: AppConstants.contactEmail,
                subject: "RadioCar app issue"
            )
        }
        .alert("Cannot Send Email", isPresented: $showMailAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please configure an email account in your device settings.")
        }
    }

    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

struct SettingsRowButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.leading, 16)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.5))
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.trailing, 16)
            }
        }
        .contentShape(Rectangle())
    }
}

struct MailComposeView: UIViewControllerRepresentable {
    let recipient: String
    let subject: String
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.setToRecipients([recipient])
        composer.setSubject(subject)
        composer.mailComposeDelegate = context.coordinator
        return composer
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView

        init(_ parent: MailComposeView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                    didFinishWith result: MFMailComposeResult,
                                    error: Error?) {
            parent.dismiss()
        }
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
