//
//  ShareHeartLikeView.swift
//  Amigo
//
//  Created by Mingxin Xie on 10/26/22.
//

import SwiftUI

import SwiftUI

struct ShareHeartLikeView: View {
    @ObservedObject var moment: MomentDetailViewModel
    
    var body: some View{
        VStack {
            ShareHeartButton(moment: self.moment)
        }
    }
    
}

struct ShareHeartButton: View{
    @State var isLiked = false
    @ObservedObject var moment: MomentDetailViewModel
    @EnvironmentObject var currentUser : UserViewModel
    @EnvironmentObject var userLikedExploresViewModel : UserLikedExploresViewModel
    
    @StateObject var userLikedExploresSearchViewModel = UserLikedExploresSearchViewModel()
    
    private let animationDuration: Double = 0.1
    private var animationScale: CGFloat {
        isLiked ? 0.7 : 1.3
    }
    var body: some View {
        VStack{
            if userLikedExploresSearchViewModel.liked != nil {
                Button(action: {
                    if (userLikedExploresSearchViewModel.liked!) { //if already liked
                        self.moment.subtractLike()
                        userLikedExploresViewModel.removeLikedExplores(exploreID: moment.moment.id)
                    }
                    else {
                        self.moment.addLike()
                        userLikedExploresViewModel.addLikedExplores(exploreID: moment.moment.id)
                    }
                },label:{
                    Image(systemName: userLikedExploresSearchViewModel.liked! ? "heart.fill" : "heart")
                        .foregroundColor( userLikedExploresSearchViewModel.liked! ? .red : .black)
                } )
            } else {
                Image(systemName: "heart")
                    .foregroundColor(.black)
            }
        }
        .onAppear(){
            userLikedExploresSearchViewModel.userID = currentUser.user.id
            userLikedExploresSearchViewModel.searchLikedExplores(searchID: moment.moment.id)
        }
    }
}
