//
//  NotePopupView.swift
//  QuickNotes
//
//  Created by Khoa Mai on 25/4/24.
//

import Foundation
import SwiftUI

struct NotePopupView: View {
    
    @Binding var isPresented: Bool
    @State var text: String = ""
    var action: ((String)->Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Create Note")
                    .font(.system(size: 25, weight: .bold, design: .default))
                Spacer()
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .imageScale(.small)
                        .frame(width: 32, height: 32)
                        .background(.black.opacity(0.06))
                        .cornerRadius(16)
                        .foregroundColor(.black)
                })
            }
            TextField("Enter Your Note", text: $text)
                .frame(height: 36)
                .padding([.leading, .trailing], 10)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                    if !text.isEmpty {
                        action?(text)
                    }
                }, label: {
                    Text("Done")
                })
                .frame(width: 80, height: 36)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
    
}
