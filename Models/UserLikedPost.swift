//
//  UserLikedPost.swift
//  Amigo
//
//  Created by Mingxin Xie on 11/14/22.
//

import SwiftUI
import Foundation

struct UserLikedPost: Identifiable, Equatable, Hashable {
    var id: String = UUID().uuidString
    var userID : String
    var postID: String
}
