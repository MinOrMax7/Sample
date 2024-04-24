//
//  ProfileMyDiscoverDisplayView.swift
//  Amigo
//
//  Created by Jack Liu on 9/13/22.
//  Edited by Mingxin Xie on 9/14/22.
//

import SwiftUI

/*
    View page of the scrolling list of questions and discover post
 */
struct ProfileMyDiscoverView: View {
    @EnvironmentObject var user : UserViewModel
    
    // fetching data for discovers post
    @StateObject var discovers = HoleViewModel()
    
    @EnvironmentObject var userDiscoversViewModel : UserDiscoversViewModel
    
    @State var firstTime = true
    @State var firstTimeUpdate = true
    @State var myDiscover = true
    
    var body: some View {
        VStack (alignment: .leading, spacing: UIScreen.main.bounds.size.height * 0.02) {
            ScrollView {
                if ($userDiscoversViewModel.discoversList.count == 0) {
                    VStack (spacing: 10) {
                        Text("Discover")
                            .font(.system(size: 18))
                            .foregroundColor(Color.black)
                            
                        Text("Your discover will appear here")
                            .font(.system(size: 14))
                            .foregroundColor(Color("colors/999999"))
                    }
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.35)
                } else {
                    ForEach($userDiscoversViewModel.discoversList) { $discover in
                        ProfileDiscoverView(discovers: discovers, hole: $discover, myDiscover: $myDiscover)
                        .padding(.bottom, UIScreen.main.bounds.size.height * 0.015)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .frame(height: UIScreen.main.bounds.size.height * 0.35)
        .onAppear(){
                userDiscoversViewModel.getDiscovers()
        }
    }
}
