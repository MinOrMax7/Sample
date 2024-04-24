//
//  BusinessLocation.swift
//  Amig Pet IOS App
//
//  Created by Jack Liu on 4/24/22.
//

import MapKit
import Foundation

struct BusinessLocation: Identifiable {
    let id : String
    let name: String
    let coordinate: CLLocationCoordinate2D
    let address: String
    let rating: Float
}
