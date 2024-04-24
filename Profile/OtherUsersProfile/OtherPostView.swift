//
//  OtherPostView.swift
//  Amigo
//
//  Created by Futing Shan on 10/24/22.
//

import SwiftUI
import AVKit
import CoreMedia
import AVFoundation
import FirebaseStorage

struct OtherPostView: View {
    @StateObject private var videoViewModel = VideoViewModel()
    
    @Binding var post : MomentPost
    
    var userName:String
    var id:String
    var thumbnail: UIImage?
    
    init(id:String,userName:String,post:Binding<MomentPost>){
        self.id=id
        self.userName=userName
        self._post=post
        
    }
    
    var body: some View {
        
        //NavigationLink(destination: OtherContentPostView(id: id, userName: userName)) {
            HStack(alignment: .top, spacing: 5){
                // check the type of post, if it is video, place a
                // video sign over the thumbnail image
                // else place a picture sign
                if (post.imageType.isEmpty || post.imageType[0]) {
                    ImageDownloadView(imagePullURL:
                                        // only fetching the first picture of the post
                        .constant("explores/\(post.id)/\(1).jpeg"))
                    .scaledToFill()
                    .frame(width: (UIScreen.main.bounds.width/3)-2, height: (UIScreen.main.bounds.width/3)-2)
                    .clipped()
                } else {
                    ImageDownloadView(imagePullURL:
                                        // only fetching the thumbnail of the video post
                        .constant("explores/\(post.id)/\(10).jpeg"))
                    .scaledToFill()
                    .frame(width: (UIScreen.main.bounds.width/3)-2, height: (UIScreen.main.bounds.width/3)-2)
                    .clipped()
                }
            }
        //}
        
    }
}
