//
//  TrainingTypes.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 1/30/22.
//

import Foundation

struct TrainingTypes: Identifiable{
    let id: UUID
    let name: String
    let popular: Bool;
    
    init(id: UUID = UUID(), name: String){
        self.id = id
        self.name = name
        self.popular = false
    }
    
    init(id: UUID = UUID(), name: String, popular: Bool){
        self.id = id
        self.name = name
        self.popular = popular
    }
    
    static let trainingList : [Breed] =
    [
        Breed(name: "Sit", popular: true),
        Breed(name: "Eat", popular: true),
        Breed(name: "Sleep", popular: true),
        Breed(name: "Shake Hand", popular: true),
        Breed(name: "Catch", popular: true),
        Breed(name: "Poop", popular: true),
        Breed(name: "Lie Down"),
        Breed(name: "Math"),
    ]
    
}
