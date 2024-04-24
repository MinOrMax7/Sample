//
//  File.swift
//  Amigo
//
//  Created by Jack Liu on 6/25/22.
//

import Foundation

struct Chat: Identifiable {
    let id : String
    let users: [String]
    let chatName: String
    var lastActiveTime: Date
}

struct Message: Identifiable {
    let id: String
    let sender: String
    let type: String
    let text: String
    let timeStamp: Date
}
