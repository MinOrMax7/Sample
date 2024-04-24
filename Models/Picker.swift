//
//  Picker.swift
//  Amigo
//
//  Created by Jack Liu on 8/19/22.
//

import PhotosUI
import SwiftUI
import AVKit


struct PHPickerInput {
    var image: UIImage?
    
}


struct AnyPickerContent : Hashable{
    var isImage : Bool
    var URL: URL?
    var duration: Double?
    var image: UIImage //either image or thumbnail image of video
}

