//
//  LoadingView.swift
//  QuickNotes
//
//  Created by Khoa Mai on 25/4/24.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()

            Text("Loading...")
                .foregroundColor(.gray)
        }
    }
}
