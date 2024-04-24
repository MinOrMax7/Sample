//
//  MyShareQAListView.swift
//  Amigo
//
//  Created by Mingxin Xie on 9/21/22.
//

import SwiftUI

struct MyShareQAListView: View {
    @EnvironmentObject var user : UserViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var userDiscoversViewModel : UserDiscoversViewModel
    
    @StateObject var discovers = HoleViewModel()

    @State var firstTime = true
    @State var firstTimeUpdate = true
    @State var myDiscover = true
    @State var showQList = true
    @State var deletePost = true
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10){
                VStack(alignment: .leading){
                    HStack (alignment: .center) {
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(Color.black)
                        })
                        Text("My Discover")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                        Spacer()
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color.black)
                            .hidden()
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
                        MyContentDiscoverQAList(hole: $discover, deletePost: $deletePost)
                    }
                    .padding(.top, 10)
                    .background(Color.white)
                }
                //scrollTo
            }
        }
        .navigationBarHidden(true)
        .onAppear(){
            userDiscoversViewModel.getDiscovers()
            userDiscoversViewModel.discoversList.sort{
                $0.createdDate.compare($1.createdDate as Date) == .orderedDescending
            }
        }
    }
}
