//
//  ProfileMomentPostView.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 2/20/22.
//

import SwiftUI

struct ProfileMomentPostView: View {
    @Binding var post : MomentPost
    
    let imageWidth = UIScreen.main.bounds.size.width / 5
    let pfpWidth = UIScreen.main.bounds.size.width / 10
    
    var items: [GridItem] {
      Array(repeating: .init(.fixed(imageWidth)), count: 3)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 5){
            ImageDownloadView(imagePullURL: .constant("users/\(post.user)/pfp.jpeg"))
                .scaledToFill()
                .frame(width: pfpWidth, height: pfpWidth)
                .clipped()
                .padding(.trailing)
            
            VStack(alignment: .leading, spacing: 10){
                UserNameView(userid: post.user)
                Text("\(post.content)")
                    .font(.system(size: 14))
                if(post.imageCount > 0){
                    LazyVGrid(columns: items, spacing: 10) {
                        ForEach(1...post.imageCount, id: \.self){ imageNum in
                            ImageDownloadView(imagePullURL: .constant("explores/\(post.id)/\(imageNum).jpeg"))
                                .scaledToFill()
                                .frame(width: imageWidth, height: imageWidth)
                                .clipped()
                        }
                    }
                }
            }
        }
        .padding(.top)
    }
}
