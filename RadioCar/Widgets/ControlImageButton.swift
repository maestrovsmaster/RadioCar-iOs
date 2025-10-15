//
//  ControlImageButton.swift
//  RadioCar
//
//  Created by Maestro Master on 15/10/2025.
//

import SwiftUICore
import SwiftUI

struct ControlImageButton: View {
    var imageName: String
    var backgroundColor: Color = .blue
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(imageName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .padding(12)
                .background(backgroundColor)
                .clipShape(Circle())          
        }
    }
}


