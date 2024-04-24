//
//  Image.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/21/21.
//

import Foundation

struct ContentImage: Identifiable {
    let id: UUID
    var imageURL: String
    
    init(id: UUID = UUID(), imageURL: String){
        self.id = id
        self.imageURL = imageURL
    }
}
