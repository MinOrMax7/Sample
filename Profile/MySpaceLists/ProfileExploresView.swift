//
//  MyExploresView.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 2/20/22.
//

import SwiftUI

struct ProfileExploresView: View {
    @StateObject var moments = MomentPostViewModel()
    
    @EnvironmentObject var userExploresViewModel : UserExploresViewModel
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
                    userExploresViewModel.removeExplores(exploreID: id)
                    moments.removePost(postID: moments.list[i].id)
                    moments.list = moments.list.filter({$0.id != id})
                    userExploresViewModel.exploresList = userExploresViewModel.exploresList.filter({$0.id != id})
                }
            }
        }
        
        .listStyle(PlainListStyle())
        .padding(.horizontal)
        .onAppear(){
            userExploresViewModel.getExplores()
            if firstTime {
                moments.getMomentsWithArray(momentArray: userExploresViewModel.exploresList.map({return $0.id}))
                firstTime = false
            }
        }
        .onChange(of: userExploresViewModel.exploresList) { V in
            if firstTimeUpdate{
                moments.getMomentsWithArray(momentArray: userExploresViewModel.exploresList.map({return $0.id}))
                firstTimeUpdate = false
            }
        }
    }
}
