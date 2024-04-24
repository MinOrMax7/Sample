//
//  ProfileMyPostDisplayView.swift
//  Amigo
//
//  Created by Jason on 9/13/22.
//  Edited by Mingxin Xie on 09/19/2022.
//

import SwiftUI

/*
    View page of users' posts
 */
struct ProfileMyPostDisplayView: View {

    @EnvironmentObject var userExploresViewModel : UserExploresViewModel
    
    @State var myPost = true
    
    //The variable to decide the number of columns to be displayed
    var columnGrid: [GridItem] = [GridItem(.flexible(), spacing: 2),
                                  GridItem(.flexible(), spacing: 2),
                                  GridItem(.flexible(), spacing: 2)]
    
    var body: some View {
        ScrollView {
            if ($userExploresViewModel.exploresList.count == 0) {
                VStack (spacing: 10) {
                    Text("Post")
                        .font(.system(size: 18))
                        .foregroundColor(Color.black)
                        
                    Text("Your post will appear here")
                        .font(.system(size: 14))
                        .foregroundColor(Color("colors/999999"))
                }
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.35)
            } else {
                LazyVGrid(columns: columnGrid, spacing: 2){
                    ForEach($userExploresViewModel.exploresList) { $moment in
                        ProfilePostView(post: $moment, myPost: $myPost)
                    }
                    }
            }
        }
        .frame(height: UIScreen.main.bounds.size.height * 0.35)
        .navigationBarHidden(true)
        .onAppear(){
            userExploresViewModel.getExplores()
        }
    }
}
