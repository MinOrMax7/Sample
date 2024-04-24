//
//  MomentPost.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/21/21.
//

import Foundation
import SwiftUI

struct MomentPost: Identifiable, Equatable, Hashable {
    var id: String
    var user: String
    var content: String
    var likes: Int
    var favorites: Int
    var commentsCount: Int
    var createdDate: NSDate
    var imageCount: Int
    var imageType: [Bool] //true is image, false is video. Should have 'imageCount' length
    var reported: Bool
}

struct MomentComment :Identifiable,Equatable {
    var id: String
    var user: String
    var content: String
    var createdDate: NSDate
    var reported: Bool
}

