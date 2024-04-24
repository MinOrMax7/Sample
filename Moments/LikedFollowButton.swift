//
//  LikedFollowButton.swift
//  Amigo
//
//  Created by Mingxin Xie on 11/28/22.
//

import SwiftUI

struct LikedFollowButton: View {
    @EnvironmentObject var currentUser : UserFollowingViewModel
    @StateObject var user: UserFollowersViewModel
    @StateObject var currentUserSearch: UserFollowingSearchViewModel
    
    init(userID: String){
        _user = StateObject(wrappedValue: UserFollowersViewModel(id: userID))
        _currentUserSearch = StateObject(wrappedValue: UserFollowingSearchViewModel())
    }
    
    let pfpWidth = UIScreen.main.bounds.size.width * 41 / 390
    
    var body: some View {
        HStack () {
            if (user.userID != currentUser.userID){
                if let unwrapped = currentUserSearch.following {
                    if unwrapped {
                        Button(action: {
                            currentUser.removeFollowing(followingID: user.userID)
                            user.removeFollower(followerID: currentUser.userID)
                        }, label: {
                            Text("Unfollow")
                                .foregroundColor(Color("colors/999999"))
                                .font(.system(size: 14, weight: .medium))
                                .frame(width: UIScreen.main.bounds.size.width * 94 / 390, height: UIScreen.main.bounds.size.width * 30 / 390, alignment: .center)
                                .border(Color("colors/999999"))
                        })
                    }
                    else{
                        Button(action: {
                            currentUser.addFollowing(followingID: user.userID)
                            user.addFollower(followerID: currentUser.userID)
                        }, label: {
                            Text("Follow")
                                .foregroundColor(Color.white)
                                .font(.system(size: 14, weight: .medium))
                                .frame(width: UIScreen.main.bounds.size.width * 94 / 390, height: UIScreen.main.bounds.size.width * 30 / 390, alignment: .center)
                                .background(Color("colors/E65D75"))
                        })
                    }
                }
            }
        }
        .onAppear(){
            currentUserSearch.userID = currentUser.userID
            currentUserSearch.searchFollowing(searchID: user.userID)
        }
    }
}
