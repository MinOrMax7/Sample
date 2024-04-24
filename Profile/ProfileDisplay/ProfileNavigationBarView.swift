//
//  Navigation2View.swift
//  Amigo
//
//  Created by Mingxin Xie on 9/27/22.
//

import SwiftUI

struct ProfileNavigationBarView: View {
    @EnvironmentObject var user : UserViewModel

//    @Binding var index : Int
//    @Binding var offset : CGFloat
//    @Binding var offsetY : CGFloat
    
    var width = UIScreen.main.bounds.width
    @State var post = true
    @State var discover = false
    @State var likedPostDis = false
    
    var body: some View {
        VStack (alignment: .center, spacing: UIScreen.main.bounds.size.width * 0.04) {
            ZStack {
                HStack (spacing: 20){
                    // My post tab
                    Button (action: {
                        post = true
                        discover = false
                        likedPostDis = false
                        
                    }) {
                        VStack {
                            if (!discover && !likedPostDis) {
                                Image("ProfileDiscovers/boldGrid")
                            } else {
                                Image("ProfileDiscovers/grid")
                            }
                            
                            if (!discover && !likedPostDis) {
                                Rectangle()
                                    .fill(Color("colors/E65D75"))
                                    .frame(width: UIScreen.main.bounds.size.width * 0.13, height: 3.0)
                            }
                        }
                    }
                    Spacer()
                    
                    // My discover tab
                    Button (action: {
                        post = false
                        discover = true
                        likedPostDis = false
                    }) {
                        VStack {
                            if (!post && !likedPostDis) {
                                Image("ProfileDiscovers/boldQA")
                            } else {
                                Image("ProfileDiscovers/QA")
                            }
                            
                            if (!post && !likedPostDis) {
                                Rectangle()
                                    .fill(Color("colors/E65D75"))
                                    .frame(width: UIScreen.main.bounds.size.width * 0.13, height: 3.0)
                            }
                        }
                    }
                    Spacer()
                    
                    // Liked posts and discover
                    Button (action: {
                        post = false
                        discover = false
                        likedPostDis = true
                    }) {
                        VStack {
                            if (!discover && !post) {
                                Image("ProfileDiscovers/boldStar")
                            } else {
                                Image("ProfileDiscovers/star")
                            }
                            
                            if (!discover && !post) {
                                Rectangle()
                                    .fill(Color("colors/E65D75"))
                                    .frame(width: UIScreen.main.bounds.size.width * 0.13, height: 3.0)
                            }
                        }
                    }
                }
                .padding(.horizontal, 80)
                
                Rectangle()
                    .fill(Color("colors/CCB3B5").opacity(0.5))
                    .frame(width: UIScreen.main.bounds.size.width, height: 3.0)
                    .offset(y:  16)
            }
            if (!discover && !likedPostDis) {
                ProfileMyPostDisplayView()
                    .offset(y: -UIScreen.main.bounds.size.width * 0.04)
            }
            else if (!post && !likedPostDis) {
                ProfileMyDiscoverView()
            }
            else if (!post && !discover) {
                ProfileLikedPostQAView()
            }
            else {
                //
            }
        } .highPriorityGesture(DragGesture()
            .onEnded({ (value)  in
                if (value.translation.width > 60) {
                    self.changeView(left: false)
                }
                if (-value.translation.width > 60) {
                    self.changeView(left: true)
                }
            })
        )
    }
    
    func changeView(left : Bool) {
        if left {
            if (!discover && !likedPostDis) { // left swipe in My post --> my discover
                post = false
                discover = true
                likedPostDis = false
            }
            else if (!post && !likedPostDis) { // left swipe in My discover --> my LikedPostDis
                post = false
                discover = false
                likedPostDis = true
            }
            else if (!post && !discover) { // left swipe in My LikedPostDis --> my LikedPostDis
                post = false
                discover = false
                likedPostDis = true
            }
            else {
                //
            }
        } else {
            if (!discover && !likedPostDis) { // right swipe in My post --> my post
                post = true
                discover = false
                likedPostDis = false
            }
            else if (!post && !likedPostDis) { // right swipe in My discover --> my post
                post = true
                discover = false
                likedPostDis = false
            }
            else if (!post && !discover) { // right swipe in My LikedPostDis --> my discover
                post = false
                discover = true
                likedPostDis = false
            }
            else {
                //
            }
        }
    }
}
