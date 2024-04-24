//
//  ProfileLikedExploresView.swift
//  Amigo
//
//  Created by Jack Liu on 7/6/22.
//

import SwiftUI

struct ProfileLikedExploresView: View {
    @StateObject var moments = MomentPostViewModel()
    
    @EnvironmentObject var userViewModel : UserViewModel
    @EnvironmentObject var userLikedExploresViewModel : UserLikedExploresViewModel
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
                    userLikedExploresViewModel.removeLikedExplores(exploreID: id)
                    MomentIndividualPostViewModel.staticSubtractLike(momentID: id)
                    moments.list = moments.list.filter({$0.id != id})
                    userLikedExploresViewModel.likedExploresList = userLikedExploresViewModel.likedExploresList.filter({$0.id != id})
                }
            }
        }
        .listStyle(PlainListStyle())
        .padding(.horizontal)
        .onAppear(){
            userLikedExploresViewModel.getLikedExplores()
            if firstTime {
                moments.getMomentsWithArray(momentArray: userLikedExploresViewModel.likedExploresList.map({return $0.id}))
                firstTime = false
            }
        }
        .onChange(of: userLikedExploresViewModel.likedExploresList) { V in
            if firstTimeUpdate {
                moments.getMomentsWithArray(momentArray: userLikedExploresViewModel.likedExploresList.map({return $0.id}))
                firstTimeUpdate = false
            }
        }
    }
}

