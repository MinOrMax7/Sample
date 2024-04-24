//
//  Program.swift
//  Amigo
//
//  Created by Jack Liu on 7/24/22.
//

import SwiftUI

struct Program: Identifiable, Hashable, Codable {
    let id: String
    var title: String
    var courses: [String]
    var creator: String
}
