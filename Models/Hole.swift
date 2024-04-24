//
//  HoleModel.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 4/3/22.
//

import Foundation
import SwiftUI
struct Hole: Identifiable {
    var id: String
    var creator: String
    var title: String
    var content: String
    var imageCount: Int
    var createdDate: NSDate
    var answers: Int // TODO: Not sure needed
    var views: Int
    var isAsk: Bool
    var upvotes: Int
    var downvotes: Int
    var favorites: Int
    
    var answerList: [HoleAnswer]
}

struct HoleDisplay: Identifiable,Equatable {
    let id: String
    var creator: String
    var title: String
    var createdDate: NSDate
    var content: String
    var answers: Int
    var views: Int
    var upvotes: Int
    var imageCount: Int
    var isAsk: Bool
    var favorites: Int
    var reported: Bool
}

struct HoleSubComment: Identifiable, Hashable {
    let id: String
    let comment: String //id of HoleAnswer that the subcomment is under
    let toComment : Bool
    let at: String //id of person @
    var user: String
    var content: String
    var createdDate: NSDate
    var reported: Bool
}

struct HoleAnswer: Identifiable {
    let id: String
    var user: String
    var content: String
    var imageCount: Int
    var createdDate: NSDate
    var upvotes: Int
    var downvotes: Int
    var reported: Bool
}
