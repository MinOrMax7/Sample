//
//  PostView.swift
//  Amigo
//
//  Created by Mingxin Xie on 9/20/22.
//

import SwiftUI
import AVKit
import CoreMedia
import AVFoundation
import FirebaseStorage

/*
    View page of single liked/favorite post
 */
struct ProfilePostView: View {
    @StateObject private var videoViewModel = VideoViewModel()
    @EnvironmentObject var deepLink: DeepLinkShare
    @Binding var post : MomentPost
    @Binding var myPost : Bool
    
    @State var action : Int? = 0
    @State var delete = false
    var thumbnail: UIImage?
    @State var delete2 = true
        
    var body: some View {
        if (self.myPost) {
            HStack(alignment: .top, spacing: 0){
                // check the type of post, if it is video, place a
                // video sign over the thumbnail image
                // else place a picture sign
                if (post.imageType.isEmpty || post.imageType[0]) {
                    NavigationLink(destination: MyContentPostView(postID: .constant(post.id), delete: $delete2).environmentObject(self.deepLink), tag: 1, selection: $action) {
                        EmptyView()
                    }
                    .navigationBarHidden(true)
                    
                    ImageDownloadView(imagePullURL:
                        // only fetching the first picture of the post
                        .constant("explores/\(post.id)/\(1).jpeg"))
                        .scaledToFill()
                        .frame(width: (UIScreen.main.bounds.width/3)-2, height: (UIScreen.main.bounds.width/3)-2)
                        .clipped()
                        .onTapGesture {
                            self.action = 1
                        }
                } else {
                    NavigationLink(destination: MyContentPostView(postID: .constant(post.id), delete: $delete2).environmentObject(self.deepLink), tag: 1, selection: $action) {
                        EmptyView()
                    }
                    .navigationBarHidden(true)

                    ImageDownloadView(imagePullURL:
                        // only fetching the first picture of the post
                        .constant("explores/\(post.id)/\(10).jpeg"))
                            .scaledToFill()
                            .frame(width: (UIScreen.main.bounds.width/3)-2, height: (UIScreen.main.bounds.width/3)-2)
                            .clipped()
                            .onTapGesture {
                                self.action = 1
                            }
                }
            }
        }
        else {
            HStack(alignment: .top, spacing: 0){
                // check the type of post, if it is video, place a
                // video sign over the thumbnail image
                // else place a picture sign
                if (post.imageType.isEmpty || post.imageType[0]) {
                    NavigationLink(destination: MyContentLikedPostView(postID: .constant(post.id), delete: $delete).environmentObject(self.deepLink), tag: 2, selection: $action) {
                        EmptyView()
                    }
                    .navigationBarHidden(true)
                    
                    ImageDownloadView(imagePullURL:
                                        // only fetching the first picture of the post
                        .constant("explores/\(post.id)/\(1).jpeg"))
                    .scaledToFill()
                    .frame(width: (UIScreen.main.bounds.width/3)-2, height: (UIScreen.main.bounds.width/3)-2)
                    .clipped()
                    .onTapGesture {
                        self.action = 2
                    }
                    
                } else {
                    NavigationLink(destination: MyContentLikedPostView(postID: .constant(post.id), delete: $delete).environmentObject(self.deepLink), tag: 2, selection: $action) {
                        EmptyView()
                    }
                    .navigationBarHidden(true)
                    
                    ImageDownloadView(imagePullURL:
                                        // only fetching the first picture of the post
                        .constant("explores/\(post.id)/\(10).jpeg"))
                    .scaledToFill()
                    .frame(width: (UIScreen.main.bounds.width/3)-2, height: (UIScreen.main.bounds.width/3)-2)
                    .clipped()
                    .onTapGesture {
                        self.action = 2
                    }
                }
            }
        }
    }
}
