//
//  FollowUserView.swift
//  Amigo
//
//  Created by 林之音 on 8/7/22.
//

import SwiftUI

struct FollowUserView: View {
    @EnvironmentObject var currentUser : UserFollowingViewModel
    @StateObject var user: UserFollowersViewModel
    @StateObject var currentUserSearch: UserFollowingSearchViewModel
    @StateObject var userFieldGetter: UserFieldsViewModel
    var date: NSDate
    init(userID: String, date: NSDate){
        _user = StateObject(wrappedValue: UserFollowersViewModel(id: userID))
        _currentUserSearch = StateObject(wrappedValue: UserFollowingSearchViewModel())
        self.date = date
        _userFieldGetter = StateObject(wrappedValue: UserFieldsViewModel())
    }
    
    let pfpWidth = UIScreen.main.bounds.size.width * 41 / 390
    
    var body: some View {
        HStack(spacing: 0){
            NavigationLink(destination: NewOtherUserView(id: user.userID)) {
                ImageDownloadView(imagePullURL: .constant("users/\(user.userID)/pfp.jpeg"))
                    .scaledToFill()
                    .frame(width: pfpWidth, height: pfpWidth)
                    .clipShape(Capsule())
                    .padding(.trailing, CGFloat(8))
            }
            
            VStack(alignment:.leading){
                HStack(spacing:0){
                    Text("\(userFieldGetter.firstName) \(userFieldGetter.lastName)")
                        .font(.system(size: CGFloat(18), weight: .bold))
                        .foregroundColor(Color("colors/000000").opacity(0.6))
                }
                
                Text("\(self.date.asString(style: .medium))")
                    .font(.system(size: CGFloat(14), weight: .medium))
                    .foregroundColor(Color("colors/000000").opacity(0.6))
            }
            
            
            Spacer()
            
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
                            Text("Follow Back")
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
            userFieldGetter.getFirstName(id: user.userID)
            userFieldGetter.getLastName(id: user.userID)
        }
    }
}

