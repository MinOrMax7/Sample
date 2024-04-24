//
//  FollowListView.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 1/16/22.
//

import SwiftUI

struct FollowListView: View {
    
    var userID: String
    var displayFollower: Bool
    
    var body: some View {
        if(displayFollower){
            FollowersListView(userID: userID)
        } else {
            FollowingListView(userID: userID)
        }
    }
}

// TODO: add dynamic loading

struct FollowingListView: View {
    @StateObject var userFollowingViewModel : UserFollowingViewModel
    init(userID: String){
        _userFollowingViewModel = StateObject(wrappedValue: UserFollowingViewModel(id: userID))
    }
    private var privateDate: NSDate = NSDate()
    
    
    let pfpWidth = UIScreen.main.bounds.size.width / 9
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            ForEach(userFollowingViewModel.followingList){ following in
                FollowUserView(userID: following.id, date: privateDate)
            }
            .frame(width: UIScreen.main.bounds.size.width * 342 / 390, height: UIScreen.main.bounds.size.width * 70 / 390)
        }
        .padding(.horizontal)
        .onAppear(){
            userFollowingViewModel.getFollowing()
        }
    }
}

struct FollowersListView: View {
    @StateObject var userFollowersViewModel : UserFollowersViewModel
    init(userID: String){
        _userFollowersViewModel = StateObject(wrappedValue: UserFollowersViewModel(id: userID))
    }
    @State var followerDate: NSDate = NSDate()
    
    
    let pfpWidth = UIScreen.main.bounds.size.width / 9
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            ForEach(userFollowersViewModel.followersList){ follower in
                FollowUserView(userID: follower.id, date: followerDate)
            }
            .frame(width: UIScreen.main.bounds.size.width * 342 / 390, height: UIScreen.main.bounds.size.width * 70 / 390)
        }
        .padding(.horizontal)
        .onAppear(){
            userFollowersViewModel.getFollowers()
        }
    }
}


struct FollowListFromIDsView: View {
    
    var userIDList : [String]
    
    let pfpWidth = UIScreen.main.bounds.size.width / 9
    
    var body: some View {
            List{
                ForEach(userIDList, id: \.self){ userID in
                    HStack{
                        NavigationLink(destination: NewOtherUserView(id: userID)) {
                            ImageDownloadView(imagePullURL: .constant("users/\(userID)/pfp.jpeg"))
                                .scaledToFill()
                                .frame(width: pfpWidth, height: pfpWidth)
                                .cornerRadius(5)
                                .clipped()
                                .padding(.trailing)
                            
                            Text(userID)
                        }
                    }
                }
            }
    }
}
