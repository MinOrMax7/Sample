//
//  HeartLikeVIew.swift
//  Amig Pet IOS App
//
//  Created by Xiaoxue Wang on 6/5/22.
//

import SwiftUI

struct HeartLikeView: View {
    @ObservedObject var moment: MomentIndividualPostViewModel
    
    var body: some View{
        VStack {
            HeartButton(moment: self.moment)
        }
    }
    
}

struct HeartButton: View{
    @State var isLiked = false
    @ObservedObject var moment: MomentIndividualPostViewModel
    @EnvironmentObject var currentUser : UserViewModel
    @EnvironmentObject var userLikedExploresViewModel : UserLikedExploresViewModel
    
    @StateObject var userLikedExploresSearchViewModel = UserLikedExploresSearchViewModel()
    @StateObject var userLikedPostViewModel = UserLikedPostViewModel()
    
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
                        self.userLikedPostViewModel.deleteData(userID: currentUser.user.id, postID: moment.moment.id)
                    }
                    else {
                        self.moment.addLike()
                        userLikedExploresViewModel.addLikedExplores(exploreID: moment.moment.id)
                        self.userLikedPostViewModel.addNewData(userID: currentUser.user.id, postID: moment.moment.id)
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
