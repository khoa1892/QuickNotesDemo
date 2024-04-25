//
//  ListNoteCell.swift
//  QuickNotes
//
//  Created by Khoa Mai on 24/4/24.
//

import Foundation
import SwiftUI

struct ListNoteCell: View {
    var note: NoteInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.content)
                .font(.body)
                .multilineTextAlignment(.leading)
            HStack {
                Text(note.userName)
                    .font(.subheadline)
                    .foregroundColor(.black)
                Spacer()
                Text(note.createdAt, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .opacity(0.8)
            }
            .padding(.top, 55)
        }
        .padding()
        .background(.yellow)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
