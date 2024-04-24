//
//  ProfileFavoriteExploresView.swift
//  Amigo
//
//  Created by Jack Liu on 7/10/22.
//

import SwiftUI

struct ProfileFavoriteExploresView: View {
    @StateObject var moments = MomentPostViewModel()
    
    @EnvironmentObject var userFavoriteExploresViewModel : UserFavoriteExploresViewModel
    @State var firstTime = true
    @State var firstTimeUpdate = true
    
    var body: some View {
        List{
            ForEach($moments.list) { $moment in
                VStack{
                    ProfileMomentPostView(post: $moment)
                }
                .padding(.bottom, 30)
                
            }
            .onDelete { (indexSet) in
                indexSet.forEach{ (i) in
                    let id = moments.list[i].id
                    userFavoriteExploresViewModel.removeFavorites(exploreID: id)
                    MomentIndividualPostViewModel.staticSubtractFavorite(momentID: id)
                    moments.list = moments.list.filter({$0.id != id})
                    userFavoriteExploresViewModel.favoriteExploresList =  userFavoriteExploresViewModel.favoriteExploresList.filter({$0.id != id})
                }
            }
        }
        .listStyle(PlainListStyle())
        .padding(.horizontal)
        .onAppear(){
            userFavoriteExploresViewModel.getFavoriteExplores()
            if firstTime {
                moments.getMomentsWithArray(momentArray: userFavoriteExploresViewModel.favoriteExploresList.map({return $0.id}))
                firstTime = false
            }
        }
        .onChange(of: userFavoriteExploresViewModel.favoriteExploresList) { V in
            if firstTimeUpdate {
                moments.getMomentsWithArray(momentArray: userFavoriteExploresViewModel.favoriteExploresList.map({return $0.id}))
                firstTimeUpdate = false
            }
        }
    }
}

