//
//  Pet.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 1/16/22.
//
import Foundation

struct Pet: Identifiable{
    let id: String
    let ownerID: String
    let addedDate: NSDate
    var birthday: NSDate = NSDate()
    var name: String = ""
    var breed: String = ""
}
