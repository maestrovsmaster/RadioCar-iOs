//
//  Colors.swift
//  RadioCar
//
//  Created by Maestro Master on 24/07/2025.
//

import SwiftUICore


enum AppColors {
    // Base colors
    static let white = Color.white
    static let black = Color.black

    // Primary blue colors - matching Android
    static let baseBlue = Color(red: 0x64/255.0, green: 0xB5/255.0, blue: 0xF6/255.0, opacity: 1.0) // #64B5F6
    static let blue = Color(red: 0x9A/255.0, green: 0xD7/255.0, blue: 0xF5/255.0, opacity: 1.0) // #9AD7F5
    static let blueCold = Color(red: 0x05/255.0, green: 0xDC/255.0, blue: 0xE3/255.0, opacity: 1.0) // #05DCE3
    static let darkBlue = Color(red: 0x04/255.0, green: 0x24/255.0, blue: 0x85/255.0, opacity: 1.0) // #042485

    // Primary colors for UI elements
    static let primary = Color(red: 0x4E/255.0, green: 0x68/255.0, blue: 0x7E/255.0, opacity: 1.0) // #4E687E
    static let primaryLight = Color(red: 0x57/255.0, green: 0x8A/255.0, blue: 0xB3/255.0, opacity: 1.0) // #578AB3
    static let primaryDark = Color(red: 0x2D/255.0, green: 0x2A/255.0, blue: 0x2D/255.0, opacity: 1.0) // #2D2A2D
    static let primaryDark2 = Color(red: 0x13/255.0, green: 0x13/255.0, blue: 0x13/255.0, opacity: 1.0) // #131313

    // Background colors
    static let background = Color(red: 0x12/255.0, green: 0x12/255.0, blue: 0x12/255.0, opacity: 1.0) // #121212
    static let surface = Color(red: 0x1E/255.0, green: 0x1E/255.0, blue: 0x1E/255.0, opacity: 1.0) // #1E1E1E
    static let darkBrush = Color(red: 0x02/255.0, green: 0x00/255.0, blue: 0x00/255.0, opacity: 1.0)

    // Gradient colors
    static let grad1 = Color(red: 0x3A/255.0, green: 0x4A/255.0, blue: 0x57/255.0, opacity: 1.0)
    static let grad2 = Color(red: 0x1E/255.0, green: 0x2A/255.0, blue: 0x34/255.0, opacity: 1.0)

    // Text colors
    static let textPrimary = Color.white // #FFFFFF
    static let textSecondary = Color(red: 0xB3/255.0, green: 0xB3/255.0, blue: 0xB3/255.0, opacity: 1.0) // #B3B3B3

    // Gray colors
    static let gray = Color(red: 0xC4/255.0, green: 0xC6/255.0, blue: 0xC7/255.0, opacity: 1.0) // #C4C6C7
    static let grayLight = Color(red: 0xD1/255.0, green: 0xD2/255.0, blue: 0xD3/255.0, opacity: 1.0) // #D1D2D3
    static let grayDark = Color(red: 0x38/255.0, green: 0x38/255.0, blue: 0x38/255.0, opacity: 1.0) // #383838
    static let divider = Color(red: 0x2C/255.0, green: 0x2C/255.0, blue: 0x2C/255.0, opacity: 1.0) // #2C2C2C

    // Accent colors
    static let tintColor = Color(red: 176/255, green: 220/255, blue: 245/255, opacity: 0.95)
    static let pink = Color(red: 0x57/255.0, green: 0x8A/255.0, blue: 0xB3/255.0, opacity: 1.0) // #578AB3
    static let pinkGray = Color(red: 0x7D/255.0, green: 0x70/255.0, blue: 0xA1/255.0, opacity: 1.0) // #7D70A1
    static let green = Color(red: 0xB6/255.0, green: 0xE9/255.0, blue: 0x1E/255.0, opacity: 1.0) // #B6E91E
    static let teal = Color(red: 0x1E/255.0, green: 0xE9/255.0, blue: 0x84/255.0, opacity: 1.0) // #1EE984
    static let red = Color(red: 0xE9/255.0, green: 0x39/255.0, blue: 0x1E/255.0, opacity: 1.0) // #E9391E
    static let error = Color(red: 0xCF/255.0, green: 0x66/255.0, blue: 0x79/255.0, opacity: 1.0) // #CF6679
    static let secondary = Color(red: 0xFF/255.0, green: 0xEB/255.0, blue: 0x3B/255.0, opacity: 1.0) // #FFEB3B

    // Track and thumb colors for sliders
    static let trackTintColor = Color(red: 0xD3/255.0, green: 0xD3/255.0, blue: 0xD3/255.0, opacity: 1.0) // #D3D3D3
    static let thumbTintColor = Color(red: 0xFF/255.0, green: 0xC1/255.0, blue: 0x07/255.0, opacity: 1.0) // #FFC107

    static let transparent = Color.clear
}
