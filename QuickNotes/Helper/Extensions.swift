//
//  Extensions.swift
//  QuickNotes
//
//  Created by Khoa Mai on 24/4/24.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
    
    func cornerRadius(radius: CGFloat, corners: UIRectCorner = .allCorners) -> some View {
        clipShape(RoundedCornersShape(radius: radius, corners: corners))
    }
}
