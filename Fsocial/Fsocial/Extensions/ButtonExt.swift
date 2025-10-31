//
//  ButtonExt.swift
//  Fsocial
//
//  Created by HuyDuc.Dev on 31/10/25.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: configuration.isPressed)
    }
}
