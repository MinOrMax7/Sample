//
//  LikedDiscover.view.swift
//  Amigo
//
//  Created by Mingxin Xie on 9/20/22.
//

import SwiftUI
/*
    View page of the scrolling list of questions and discover post
    specifically use it for likedPostQA page
 */
struct ProfileMyLikedDiscoverView: View {
    @EnvironmentObject var user : UserViewModel
    @StateObject var discovers = HoleViewModel()
    
    // should be a different ViewModel
    @EnvironmentObject var userDiscoversViewModel : UserDiscoversViewModel
    @EnvironmentObject var userFavoriteDiscoversViewModel : UserFavoriteDiscoversViewModel
    
    @State var firstTime = true
    @State var firstTimeUpdate = true
    @State var myDiscover = false
    
    var body: some View {
        VStack (alignment: .leading) {
            ScrollView {
                if (discovers.list.count == 0) {
                    VStack (spacing: 10) {
                        Text("Favorite Discover")
                            .font(.system(size: 18))
                            .foregroundColor(Color.black)
                            
                        Text("Your favorite discover will appear here")
                            .font(.system(size: 14))
                            .foregroundColor(Color("colors/999999"))
                    }
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.35)
                } else {
                    ForEach($discovers.list) { $discover in
                        ProfileDiscoverView(discovers: discovers, hole: $discover, myDiscover: $myDiscover)
                            .padding(.bottom, UIScreen.main.bounds.size.height * 0.015)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .frame(height: UIScreen.main.bounds.size.height * 0.32)
        .onAppear(){
            userFavoriteDiscoversViewModel.getFavoriteDiscovers()
            if firstTime {
                discovers.getHolesWithArray(holeArray: userFavoriteDiscoversViewModel.favoriteDiscoversList.map({return $0.id}))
                firstTime = false
            }
        }
        .onChange(of: userFavoriteDiscoversViewModel.favoriteDiscoversList) { V in
            discovers.getHolesWithArray(holeArray: userFavoriteDiscoversViewModel.favoriteDiscoversList.map({return $0.id}))
        }
    }
}
