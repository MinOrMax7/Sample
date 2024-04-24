//
//  Course.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 1/3/22.
//

import Foundation
import SwiftUI
struct Course: Identifiable, Hashable {
    let id: String
    var title: String
    var skill: Int
    var numSessions: Int
    var preparation: [PreparationItem]
    var prereq: [String]
    var totalTime: String
    var creator: String
    var category: String
    
    var uploadedTime: Date
    var isPremium: Bool
    var isRecommended: Bool
}

struct PreparationItem: Hashable {
    var name : String
    var description: String
}

struct CourseSession: Identifiable {
    let id: Int
    var title: String
    var hasVideo: Bool
    var overview: String
    var steps: [String]
    var stepTimestamps: [Int]
    var time: Int //in minute
    var endingQuestion: String
}
