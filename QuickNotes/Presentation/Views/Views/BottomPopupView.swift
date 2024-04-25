//
//  BottomPopupView.swift
//  QuickNotes
//
//  Created by Khoa Mai on 25/4/24.
//

import Foundation
import SwiftUI

struct BottomPopupView<Content: View>: View {
    
    let content: Content
    @State private var animationAmount = 1.0

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                content
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    .background(Color.white)
                    .cornerRadius(radius: 16, corners: [.topLeft, .topRight])
            }
            .edgesIgnoringSafeArea([.bottom])
        }
        .animation(.linear, value: 0)
    }
}
