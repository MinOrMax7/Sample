//
//  ProfileLikeDiscoverView.swift
//  Amigo
//
//  Created by Mingxin Xie on 9/14/22.
//

import SwiftUI

/*
    View page of liked posts, questionos and discover posts
 */
struct ProfileLikedPostQAView: View {
    @StateObject var discovers = HoleViewModel()
    
    @EnvironmentObject var userLikedExploresViewModel : UserLikedExploresViewModel
    @EnvironmentObject var userFavoriteExploresViewModel : UserFavoriteExploresViewModel
    @EnvironmentObject var userDiscoversViewModel : UserDiscoversViewModel
    @EnvironmentObject var userFavoriteDiscoversViewModel : UserFavoriteDiscoversViewModel
    
    @EnvironmentObject var userViewModel : UserViewModel
    @State var firstTimeUpdate = true
    @State var firstTime = true
    @State var myDiscover = false
    @State var myPost = true
    
    var body: some View {
        let marginPadding3 =  UIScreen.main.bounds.size.width * 0.05  // title left
        
        VStack (alignment: .leading, spacing: UIScreen.main.bounds.size.width * 0.02) {
            HStack {
                Button {
                    myPost = true
                    myDiscover = false
                } label : {
                    if !myDiscover {
                        Text("Post \($userFavoriteExploresViewModel.favoriteExploresList.count)")
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                            .foregroundColor(Color.black)
                    }else {
                        Text("Post \($userFavoriteExploresViewModel.favoriteExploresList.count)")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.049, brightness: 0.556))
                    }
                }

                Button {
                    myPost = false
                    myDiscover = true
                } label : {
                    if !myPost {
                        Text("Discover \($userFavoriteDiscoversViewModel.favoriteDiscoversList.count)")
                            .font(.system(size: 14))
                            .fontWeight(.regular)
                            .foregroundColor(Color.black)
                    } else {
                        Text("Discover \($userFavoriteDiscoversViewModel.favoriteDiscoversList.count)")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.049, brightness: 0.556))
                    }
                }
            }
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
            .padding(.leading, marginPadding3)
            
            if (!myDiscover) {
                ProfileMyLikedPostView()
            } else if (!myPost) {
                ProfileMyLikedDiscoverView()
            }else {
                // no opts
            }
        }
        .frame(height: UIScreen.main.bounds.size.height * 0.35)
    }
}
