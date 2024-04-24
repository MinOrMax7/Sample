//
//  ImageViewModel.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/30/21.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseStorage

class ImageViewModel: ObservableObject{
    var imageCache = ImageCache.getImageCache()
    
    @Published var image = UIImage()
    @Published var success = false;
    
    
    func downloadImageFromStorage(imagePullURL: String, placeholder: Bool = true){
        if loadImageFromCache(urlString: imagePullURL) {
            self.success = true;
            return
        }
        
        let storageRef = Storage.storage().reference()
        let storage = storageRef.child(imagePullURL)
        storage.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error == nil {
                guard let loadedImage = UIImage(data: data!) else {
                    self.success = false;
                    return
                }
                self.success = true;
                self.image = loadedImage
                self.imageCache.set(forKey: imagePullURL, image: loadedImage)

            } else {
                self.success = false;
                if(placeholder){
                    self.image = UIImage(named: "newPlaceholder") ?? UIImage()
                }
            }
        }
    }
    
    func loadImageFromCache(urlString: String) -> Bool {
        
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        self.image = cacheImage
        return true
    }
    
    static func uploadImagesToStorage(path: String, localImages: [UIImage]){
        if(localImages.count > 0){
            for count in 1...localImages.count {
                let data = compressImage(image: localImages[count-1])
                let storageRef = Storage.storage().reference().child("\(path)/\(count).jpeg")
                storageRef.putData(data, metadata: nil)
                ImageCache.getImageCache().set(forKey: "\(path)/\(count).jpeg", image: localImages[count-1])
            }
        }
    }
    
    static func uploadImagesToStorage(path: String, localImages: [UIImage?]){
        if(localImages.count > 0){
            for count in 1...localImages.count {
                if let image = localImages[count-1] {
                    var data = compressImage(image: image)
                    let storageRef = Storage.storage().reference().child("\(path)/\(count).jpeg")
                    storageRef.putData(data, metadata: nil)
                    ImageCache.getImageCache().set(forKey: "\(path)/\(count).jpeg", image: image)
                }
            }
        }
    }
    
    static func uploadImagesToStorage(path: String, localImages: [UIImage], names: [String]){ //assume localImages and names have the same length
        if(localImages.count > 0){
            for count in 1...localImages.count {
                let data = compressImage(image: localImages[count-1])
                let thisPath = "\(path)/\(names[count-1]).jpeg"
                let storageRef = Storage.storage().reference().child(thisPath)
                storageRef.putData(data, metadata: nil)
                ImageCache.getImageCache().set(forKey: thisPath, image: localImages[count-1])
            }
        }
    }
    
    static func uploadImageToStorage(path: String, localImage: UIImage, imageName: String = "") -> StorageUploadTask{
        let data = compressImage(image: localImage)
        print(data.count)
        let path = (imageName != "") ? (path + "/" + imageName + ".jpeg") : (path + "/img.jpeg")
        let storageRef = Storage.storage().reference().child(path)
        ImageCache.getImageCache().set(forKey: path, image: localImage)
        return storageRef.putData(data, metadata: nil)
    }
    
    static func deleteFolderFromStorage(path: String){
        let storageRef = Storage.storage().reference().child(path)
        storageRef.delete { error in
            
        }
//        storageRef.delete()
    }
    
    static func compressImage(image: UIImage) -> Data {
        let resizedImage = image.aspectFittedToHeight(200)
        return resizedImage.jpegData(compressionQuality: 0.5)! // Add this line
    }
}


class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
