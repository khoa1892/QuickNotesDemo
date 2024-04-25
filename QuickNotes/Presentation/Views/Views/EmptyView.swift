//
//  EmptyView.swift
//  QuickNotes
//
//  Created by Khoa Mai on 25/4/24.
//

import Foundation
import SwiftUI

struct EmptyDataView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("No Data")
                .font(.title)
                .foregroundColor(.gray)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}
