//
//  OverlayModifier.swift
//  QuickNotes
//
//  Created by Khoa Mai on 25/4/24.
//

import Foundation
import SwiftUI

struct OverlayModifier<OverlayView: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    @ViewBuilder var overlayView: () -> OverlayView
    
    init(isPresented: Binding<Bool>, @ViewBuilder overlayView: @escaping () -> OverlayView) {
        self._isPresented = isPresented
        self.overlayView = overlayView
    }
    
    func body(content: Content) -> some View {
        content.overlay(isPresented ? overlayView() : nil)
    }
}

extension View {
    func popup<OverlayView: View>(isPresented: Binding<Bool>,
                                  radius: CGFloat = 3,
                                  @ViewBuilder overlayView: @escaping () -> OverlayView) -> some View {
        blur(radius: isPresented.wrappedValue ? radius : 0)
            .animation(.linear, value: 0)
            .modifier(OverlayModifier(isPresented: isPresented, overlayView: overlayView))
    }
}
