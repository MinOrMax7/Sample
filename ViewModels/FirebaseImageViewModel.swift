//
//  FirebaseImageViewModel.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/22/21.
//

import Foundation
import Firebase
import SwiftUI

class FirebaseImageViewModel: ObservableObject{
    func getData(imageURL: String) -> UIImage{
        
        var image = UIImage(named: "")
        
        let ref = Storage.storage().reference(forURL: imageURL)
        
        
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("Error: Image could not download!")
            } else {
                if let data = data{
                    DispatchQueue.main.async {
                        image = UIImage(data: data)!
                    }
                }
            }
        }
        return image!
    }
}
