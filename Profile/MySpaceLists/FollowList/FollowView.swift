//
//  FollowView.swift
//  Amigo
//
//  Created by 林之音 on 8/7/22.
//

import SwiftUI

struct FollowView: View {
    @EnvironmentObject var currentUser : UserViewModel
    
    var displayFollowerFlag: Bool
    var userID : String
    @State var displayFollower : Bool
    @State var followerColor: Color
    @State var followingColor: Color
    init(userID: String, displayFollowerFlag: Bool){
        _displayFollower = State(wrappedValue: displayFollowerFlag)
        _followerColor = State(wrappedValue: Color("colors/E65D75"))
        _followingColor = State(wrappedValue: Color("colors/E65D75"))
        self.userID = userID
        self.displayFollowerFlag = displayFollowerFlag
    }
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            HStack(spacing: UIScreen.main.bounds.size.width * 100 / 390){
                Button { // Follower
                    displayFollower = true
                    followerColor = Color("colors/E65D75")
                    followingColor = .white
                } label: {
                    followButton(text: .constant("Follower"), fColor: .constant(Color("colors/000000").opacity(0.6)), rColor: .constant(followerColor))
                }
                
                Button { // Following
                    displayFollower = false
                    followerColor = .white
                    followingColor = Color("colors/E65D75")
                } label: {
                    followButton(text: .constant("Following"), fColor: .constant(Color("colors/000000").opacity(0.6)), rColor: .constant(followingColor))
                }
            }
                .padding(.horizontal)
                .onAppear{
                    followerColor = displayFollower ? Color("colors/E65D75") : .white
                    followingColor = displayFollower ? .white : Color("colors/E65D75")
                }
            
            ScrollView{
                FollowListView(userID: self.userID, displayFollower: displayFollower)
            }
            
        }
        
    }
}


