//
//  ProfileView.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/30/21.
//

import SwiftUI
import Popovers

struct OtherUserView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var currentUser : UserViewModel
    @EnvironmentObject var currenUserFollowingViewModel : UserFollowingViewModel
    @EnvironmentObject var userBlockedViewModel : UserBlockedViewModel
    
    @StateObject var user : UserViewModel
    @StateObject var userFollowersViewModel : UserFollowersViewModel
    
    @StateObject var userFollowingSearchViewModel = UserFollowingSearchViewModel()
    
    @State private var showBlockPopup = false
    @State private var showUnblockPopup = false
    var id : String
    
    var blocked : Bool {
        return userBlockedViewModel.blockedList.contains(where: {$0.id == self.id})
    }
    
    init(id: String){
        _user = StateObject(wrappedValue: UserViewModel(id: id))
        _userFollowersViewModel = StateObject(wrappedValue: UserFollowersViewModel(id: id))
        self.id = id
    }
    
    let pfpWidth = UIScreen.main.bounds.size.width / 6
    
    var body: some View {
        VStack{
            HStack(alignment: .top, spacing: 5){
                ImageDownloadView(imagePullURL: .constant("users/\(id)/pfp.jpeg"))
                    .scaledToFill()
                    .frame(width: pfpWidth, height: pfpWidth)
                    .cornerRadius(5)
                    .clipped()
                    .padding(.trailing)
                
                VStack(alignment: .leading, spacing: 10){
                    HStack{
                        Text(user.user.displayedName)
                            .font(.title)
                        
                        Spacer()
                        if(!blocked){ //if not blocked
                            if(user.user.id != currentUser.user.id){
                                if let following = userFollowingSearchViewModel.following{
                                    if following == true {
                                        Button(action: {
                                            currenUserFollowingViewModel.removeFollowing(followingID: self.id)
                                            userFollowersViewModel.removeFollower(followerID: currentUser.user.id)
                                        }, label: {
                                            Text("Unfollow")
                                                .padding()
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.gray, lineWidth: 2)
                                                )
                                                .foregroundColor(Color.gray)
                                        })
                                    } else {
                                        Button(action: {
                                            currenUserFollowingViewModel.addFollowing(followingID: user.user.id)
                                            userFollowersViewModel.addFollower(followerID: currentUser.user.id)
                                        }, label: {
                                            Text("Follow")
                                                .padding()
                                                .foregroundColor(Color.white)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color("colors/E65D75"), lineWidth: 2)
                                                )
                                        })
                                    }
                                }
                            }
                        }
                    }
                    
                    Text("Account ID: \(user.user.displayedID)")
                    if (!blocked) {
                        Text("Bio:")
                        Text(user.user.bio)
                            .font(.system(size: 12))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
            
            if (!blocked) {
                HStack(spacing: 80){
                    VStack{
                        Text("\(user.user.followersCount)")
                            .font(.system(size: 14))
                        Text("Followers")
                            .font(.system(size: 14))
                    }
                    
                    VStack{
                        Text("\(user.user.followingCount)")
                            .font(.system(size: 14))
                        Text("Following")
                            .font(.system(size: 14))
                    }
                }
                .padding()
            }
            
            Spacer()
            
        }
        .padding()
        .onAppear(){
            userFollowingSearchViewModel.userID = currentUser.user.id
            userFollowingSearchViewModel.searchFollowing(searchID: self.id)
        }
        .toolbar {
            Templates.Menu {
                if(blocked){
                    Templates.MenuButton(title: "Unblock User") {self.showUnblockPopup = true}
                    
                } else {
                    Templates.MenuButton(title: "Block User") {self.showBlockPopup = true}
                }
            } label: { fade in
                Image(systemName: "ellipsis")
            }
        }
        .popover(
            present: $showBlockPopup,
            attributes: {
                $0.blocksBackgroundTouches = true
                $0.rubberBandingMode = .none
                $0.position = .relative(
                    popoverAnchors: [
                        .center,
                    ]
                )
                $0.presentation.animation = .easeOut(duration: 0.15)
                $0.dismissal.mode = .none
            }
        ) {
            VStack(spacing: 0) {
                VStack(spacing: 6) {
                    Text("By blocking this user you will not be able to see their posts, discovers, comments, and chats")
                        .multilineTextAlignment(.center)
                }
                .padding()

                Divider()

                Button {
                    userBlockedViewModel.addBlocked(blockedID: self.id)
                    userBlockedViewModel.blockedList.append(UserBlock(id: self.id))
                    showBlockPopup = false
                } label: {
                    Text("Yes")
                        .foregroundColor(.blue)
                }
                .buttonStyle(Templates.AlertButtonStyle())
                
                Button {
                    showBlockPopup = false
                } label: {
                    Text("No")
                        .foregroundColor(.gray)
                }
                .buttonStyle(Templates.AlertButtonStyle())
            }
            .background(Color.white)
            .cornerRadius(16)
            .popoverShadow(shadow: .system)
            .frame(width: 260)
        } background: {
            Color.black.opacity(0.1)
        }
        .popover(
            present: $showBlockPopup,
            attributes: {
                $0.blocksBackgroundTouches = true
                $0.rubberBandingMode = .none
                $0.position = .relative(
                    popoverAnchors: [
                        .center,
                    ]
                )
                $0.presentation.animation = .easeOut(duration: 0.15)
                $0.dismissal.mode = .none
            }
        ) {
            VStack(spacing: 0) {
                VStack(spacing: 6) {
                    Text("Are you sure you want to unblock this user?")
                        .multilineTextAlignment(.center)
                }
                .padding()

                Divider()

                Button {
                    userBlockedViewModel.removeBlocked(blockedID: self.id)
                    userBlockedViewModel.blockedList = userBlockedViewModel.blockedList.filter({$0.id != self.id})
                    showBlockPopup = false
                } label: {
                    Text("Yes")
                        .foregroundColor(.blue)
                }
                .buttonStyle(Templates.AlertButtonStyle())
                
                Divider()
                
                Button {
                    showBlockPopup = false
                } label: {
                    Text("No")
                        .foregroundColor(.gray)
                }
                .buttonStyle(Templates.AlertButtonStyle())
            }
            .background(Color.white)
            .cornerRadius(16)
            .popoverShadow(shadow: .system)
            .frame(width: 260)
        } background: {
            Color.black.opacity(0.1)
        }
        
    }
}
