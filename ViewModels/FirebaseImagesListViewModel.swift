//
//  FirebaseImagesListViewModel.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/22/21.
//

import Foundation
import Firebase
import SwiftUI

class FirebaseImagesListViewViewModel: ObservableObject{
    @Published var images = [UIImage]()
    
    func getData(imageURLs: [String]){
            self.images = imageURLs.map({ imageURL in
                
                let ref = Storage.storage().reference(forURL: imageURL)
                
                var image : UIImage = UIImage(named: "")!
                
                ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        print("Error: Image could not download!")
                    } else {
                        if let data = data{
                            image = UIImage(data: data)!
                        }
                    }
                }
                
                return image
            })
    }
}
