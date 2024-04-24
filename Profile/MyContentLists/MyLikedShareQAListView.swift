//
//  MyLikedShareQAListView.swift
//  Amigo
//
//  Created by Mingxin Xie on 10/4/22.
//

import SwiftUI

struct MyLikedShareQAListView: View {
    @EnvironmentObject var user : UserViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var userFavoriteDiscoversViewModel : UserFavoriteDiscoversViewModel
    
    @StateObject var discovers = HoleViewModel()

    @State var firstTime = true
    @State var firstTimeUpdate = true
    @State var myDiscover = true
    @State var showQList = true
    @State var deletePost = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10){
                VStack(alignment: .leading){
                    HStack (spacing: UIScreen.main.bounds.size.width / 6.6) {
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                        }, label: {
                            Image("back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.size.width * 0.11, height: UIScreen.main.bounds.size.width * 0.11)
                        })
                        Text("Favorite Discover")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                    }
                    .padding(.horizontal)
                }
                .background(Color.white)
                
                ScrollView {
                    Rectangle()
                        .fill(Color.gray).opacity(0.1)
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.008)  //OG VALUE 100
                        .ignoresSafeArea()
                    ForEach($discovers.list) { $discover in
                        MyContentLikedDisQAList(hole: $discover, deletePost: $deletePost)
                    }
                    .padding(.top, 10)
                    .background(Color.white)
                }
                // scrollTo
            }
        }
        .navigationBarHidden(true)
        .onAppear(){
            userFavoriteDiscoversViewModel.getFavoriteDiscovers()
            if firstTime {
                discovers.getHolesWithArray(holeArray: userFavoriteDiscoversViewModel.favoriteDiscoversList.map({return $0.id}))
                firstTime = false
            }
        }
        .onChange(of: userFavoriteDiscoversViewModel.favoriteDiscoversList) { V in
            if firstTimeUpdate{
            discovers.getHolesWithArray(holeArray: userFavoriteDiscoversViewModel.favoriteDiscoversList.map({return $0.id}))
                firstTimeUpdate = false
            }
        }
    }
}
