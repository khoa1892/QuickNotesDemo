//
//  UserInfo.swift
//  QuickNotes
//
//  Created by Khoa Mai on 23/4/24.
//

import Foundation

struct UserInfo: Codable {
    var userId: String = UUID().uuidString
    let username: String
    let createdAt: Date
    var formatDate: String {
        get {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormat.string(from: createdAt)
        }
    }
    public static func ==(lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.username == rhs.username && lhs.createdAt == rhs.createdAt
    }
}
