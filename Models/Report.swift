//
//  Report.swift
//  Amigo
//
//  Created by Jack Liu on 8/5/22.
//

import Foundation

struct Report :Identifiable {
    let id: String
    var user: String
    var content: String
    var createdDate: NSDate
}
