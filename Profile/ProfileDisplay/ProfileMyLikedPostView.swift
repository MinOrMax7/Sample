//
//  MyLikedPostView.swift
//  Amigo
//
//  Created by Mingxin Xie on 9/21/22.
//

import SwiftUI

struct ProfileMyLikedPostView: View {
    @StateObject var moments = MomentPostViewModel()
    
    @EnvironmentObject var userLikedExploresViewModel : UserLikedExploresViewModel
    @EnvironmentObject var userFavoriteExploresViewModel : UserFavoriteExploresViewModel
    
    @EnvironmentObject var userViewModel : UserViewModel
    
    @State var firstTime = true
    @State var firstTimeUpdate = true
    @State var myPost = false
    //The variable to decide the number of columns to be displayed
    var columnGrid: [GridItem] = [GridItem(.flexible(), spacing: 2),
                                  GridItem(.flexible(), spacing: 2),
                                  GridItem(.flexible(), spacing: 2)]
    
    var body: some View {
        ScrollView {
            if (moments.list.count == 0) {
                VStack (spacing: 10) {
                    Text("Favorite Post")
                        .font(.system(size: 18))
                        .foregroundColor(Color.black)
                        
                    Text("Your favorite post will appear here")
                        .font(.system(size: 14))
                        .foregroundColor(Color("colors/999999"))
                }
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.35)
            } else {
                LazyVGrid(columns: columnGrid, spacing: 2){
                    ForEach($moments.list) { $moment in
                        ProfilePostView(post: $moment, myPost: $myPost)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .frame(height: UIScreen.main.bounds.size.height * 0.32)
        // favorite posts
        .onAppear(){
            userFavoriteExploresViewModel.getFavoriteExplores()
            if firstTime {
                moments.getMomentsWithArray(momentArray: userFavoriteExploresViewModel.favoriteExploresList.map({return $0.id}))
                firstTime = false
            }
        }
        .onChange(of: userFavoriteExploresViewModel.favoriteExploresList) { V in
            moments.getMomentsWithArray(momentArray: userFavoriteExploresViewModel.favoriteExploresList.map({return $0.id}))
        }
    }
}
