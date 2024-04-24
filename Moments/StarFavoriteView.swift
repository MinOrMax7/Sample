//
//  StarFavoriteView.swift
//  Amig Pet IOS App
//
//  Created by Xiaoxue Wang on 6/7/22.
//

//
//  StarFavoriteView.swift
//  Amig Pet IOS App
//
//  Created by Xiaoxue Wang on 6/7/22.
//

import SwiftUI

struct StarFavoriteView: View {
    @ObservedObject var moment: MomentIndividualPostViewModel
    
    var body: some View{
        VStack {
            starButton(moment: self.moment)
        }
    }
    
}

struct starButton: View{
    @ObservedObject var moment: MomentIndividualPostViewModel
    @EnvironmentObject var currentUser : UserViewModel
    @EnvironmentObject var userFavoriteExploresViewModel : UserFavoriteExploresViewModel
    
    @StateObject var userFavoriteExploresSearchViewModel = UserFavoriteExploresSearchViewModel()
    
    private let animationDuration: Double = 0.1
    private var animationScale: CGFloat {
        userFavoriteExploresSearchViewModel.favorite ?? false ? 0.7 : 1.3
    }
    var body: some View {
        VStack{
            if userFavoriteExploresSearchViewModel.favorite != nil {
                Button(action: {
                    if (userFavoriteExploresSearchViewModel.favorite!) { //if already liked
                        self.moment.subtractFavorite()
                        userFavoriteExploresViewModel.removeFavorites(exploreID: moment.moment.id)
                    }
                    else {
                        self.moment.addFavorite()
                        userFavoriteExploresViewModel.addFavoriteExplores(exploreID: moment.moment.id)
                    }
                },label:{
                    Image(systemName: userFavoriteExploresSearchViewModel.favorite! ? "star.fill" : "star")
                        .foregroundColor( userFavoriteExploresSearchViewModel.favorite! ? .yellow : .black)
                } )
            } else {
                Image(systemName: "star")
                    .foregroundColor(.black)
            }
        }
        .onAppear(){
            userFavoriteExploresSearchViewModel.userID = currentUser.user.id
            userFavoriteExploresSearchViewModel.searchFavoriteExplores(searchID: moment.moment.id)
        }
    }
}
