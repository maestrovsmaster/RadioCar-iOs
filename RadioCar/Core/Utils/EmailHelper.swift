//
//  EmailHelper.swift
//  RadioCar
//
//  Created by Maestro Master on 16/10/2025.
//

import Foundation
import UIKit
import MessageUI

struct EmailHelper {

    /// Opens email client to send report about station
    /// - Parameters:
    ///   - stationName: Name of the station to report
    ///   - subject: Email subject (default: "Report Station")
    static func sendReportEmail(stationName: String, subject: String = "Report Station") {
        let body = """
        Report Station: \(stationName)

        App Version: RadioCar \(AppConstants.appVersion)
        """

        sendEmail(to: AppConstants.contactEmail, subject: subject, body: body)
    }

    /// Opens email client with pre-filled data
    /// - Parameters:
    ///   - to: Recipient email address
    ///   - subject: Email subject
    ///   - body: Email body
    static func sendEmail(to: String, subject: String = "", body: String = "") {
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let mailto = "mailto:\(to)?subject=\(encodedSubject)&body=\(encodedBody)"

        guard let url = URL(string: mailto) else {
            print("❌ Failed to create email URL")
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url) { success in
                if success {
                    print("✅ Email client opened successfully")
                } else {
                    print("❌ Failed to open email client")
                }
            }
        } else {
            print("❌ Cannot open email URL - no email client configured")
        }
    }
}
