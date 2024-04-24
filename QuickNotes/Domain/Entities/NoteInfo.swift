//
//  NoteInfo.swift
//  QuickNotes
//
//  Created by Khoa Mai on 20/4/24.
//

import Foundation

struct NoteInfo: Codable {
    let content: String
    let userName: String
    let userId: String
    let createdAt: Date
    var formatDate: String {
        get {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormat.string(from: createdAt)
        }
    }
    public static func ==(lhs: NoteInfo, rhs: NoteInfo) -> Bool {
        return lhs.content == rhs.content
        && lhs.formatDate == rhs.formatDate
        && lhs.userName == rhs.userName
    }
}
