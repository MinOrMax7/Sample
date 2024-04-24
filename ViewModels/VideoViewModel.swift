//
//  VideoViewModel.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 1/16/22.
//

import Foundation
import FirebaseStorage
import SwiftUI
import AVKit

class VideoViewModel: ObservableObject{
    @Published var url = "";
    @Published var size = 1.0;
    
    func downloadVideoFromStorage(videoPullURL: String, preload: Bool = false){
        let storageRef = Storage.storage().reference()
        let storage = storageRef.child(videoPullURL)
        storage.getMetadata {(metadata, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            } else {
                if let metadata = metadata {
                    //                    print(metadata)
                }
            }
        }
        storage.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            if let url = url {
                DispatchQueue.main.async {
                    self.url = url.absoluteString
                }
            }
        }
    }
    
    func uploadVideoToStorage(videoURL: URL, path: String, name: String = "video", completion: @escaping (StorageUploadTask?) -> Void) {
        let videoCompresor = VideoCompresser()
        videoCompresor.compressFile(videoURL) { (compressedURL) in
            do {
                let data = try Data(contentsOf: compressedURL)
                let storageRef = Storage.storage().reference().child("\(path)/\(name).mp4")
                let metaData = StorageMetadata()
                metaData.contentType = "video/mp4"
                let uploadTask = storageRef.putData(data, metadata: metaData)
                uploadTask.observe(.success) { snapshot in
                    videoCompresor.removeUrlFromFileManager(compressedURL)
                }
                uploadTask.observe(.failure) { snapshot in
                    videoCompresor.removeUrlFromFileManager(compressedURL)
                }
                completion(uploadTask)
            } catch {
                completion(nil)
            }
        }
        
    }
    
    func getVideoResolution() {
        Task.detached {
            guard let track = AVURLAsset(url: URL(string: self.url)!).tracks(withMediaType: AVMediaType.video).first else { return }
            let size = track.naturalSize.applying(track.preferredTransform)
            DispatchQueue.main.async {
                self.size = abs(size.height) / abs(size.width)
            }
        }
    }
}
