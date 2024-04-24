//
//  LikedUsersView.swift
//  Amigo
//
//  Created by Mingxin Xie on 11/28/22.
//

import SwiftUI

struct LikedUsersView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @StateObject var userLikedPostViewModel = UserLikedPostViewModel()

    var postID: String
    
    init(postID: String) {
        self.postID = postID
    }
    
    let pfpWidth = UIScreen.main.bounds.size.width / 10
    let marginPadding =  UIScreen.main.bounds.size.width * 0.06
    @State var searchText: String = ""
    @State var showSearch : Bool = false;
    
    var body: some View {
        ZStack(alignment: .top){
            VStack(alignment: .leading, spacing: 10) {
                
                VStack(alignment: .leading){
                    HStack (alignment: .center) {
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                        }, label: {
                            Image("back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.size.width * 0.11, height: UIScreen.main.bounds.size.width * 0.11)
                        })
                        Spacer()
                        Text("Likes")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                        Spacer()
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.size.width * 0.11, height: UIScreen.main.bounds.size.width * 0.11)
                            .hidden()
                    }
                    .padding(.horizontal)
                }
                .background(Color.white)
                
                SearchBar(searchText: $searchText, initialText: "Search for users", toggler: $showSearch)
                
                ScrollView() {
                    VStack(alignment: .leading) {
                        ForEach(userLikedPostViewModel.userLikedPosts) { userLikedPost in
                            HStack() {
                                NavigationLink(destination: NewOtherUserView(id: userLikedPost.userID)) {
                                    HStack(spacing: 2) {
                                        ImageDownloadView(imagePullURL: .constant("users/\(userLikedPost.userID)/pfp.jpeg"))
                                            .scaledToFill()
                                            .frame(width: pfpWidth, height: pfpWidth)
                                            .clipShape(Capsule())
                                            .padding(.trailing)
                                            
                                        UserNameView(userid: userLikedPost.userID)
                                    }
                                }
                                Spacer()
                                
                                LikedFollowButton(userID: userLikedPost.userID)
                            }
                            .frame(width: UIScreen.main.bounds.size.width * 342 / 390)
                        }
                    }
                }
                .padding(.leading, marginPadding)
                .onAppear(){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.userLikedPostViewModel.getLikedUsers(postID: postID)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}
