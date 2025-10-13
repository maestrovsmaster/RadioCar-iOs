//
//  ControlIconButton.swift
//  RadioCar
//
//  Created by Maestro Master on 29/07/2025.
//

import SwiftUI

struct ControlIconButton: View {
    let systemName: String
    var color : Color = .blue
    let action: () -> Void


    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding()
                .background(Circle().fill(color))
        }
    }
}

