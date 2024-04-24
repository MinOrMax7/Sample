//
//  MyContentPostView.swift
//  Amigo
//
//  Created by Mingxin Xie on 9/26/22.
//

import SwiftUI
import Popovers
import AVKit
import VideoPlayer

struct MyContentPostView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var moments = MomentPostViewModel()
    @State var content = ""
    @State var shareID: String = ""
    @State var userID: String = ""
    @EnvironmentObject var userExploresViewModel : UserExploresViewModel
    @EnvironmentObject var deepLink: DeepLinkShare
    @Binding var postID : String
    @State var presentMenu = false;
    @State var reportingProblem = false
    @State var firstTime = true
    @State var firstTimeUpdate = true
    //@State var delete = true // delete available only in user's profile post page
    @State var muted = false
    @Binding var delete : Bool
    @State var inProfile = true
    let pfpWidth = UIScreen.main.bounds.size.width / 11
    
    
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
                        Spacer()
                        Text("My Post")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                        Spacer()
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color.black)
                            .hidden()
                    }
                    .padding(.horizontal)
                }
                .background(Color.white)
                
                ScrollViewReader { proxy1 in
                    ScrollView  {
                        Rectangle()
                            .fill(Color.gray).opacity(0.1)
                            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.008)  //OG VALUE 100
                            .ignoresSafeArea()
                        ForEach($moments.list) { $moment in
                            VStack {
                                ExploreListLoadingView(moments: moments, muted: $muted, delete: $delete, inProfile: $inProfile, shareID: $shareID, userID: $userID, moment: moment).environmentObject(self.deepLink)
                            }
                        }
                        .offset(y: -2)
                        .padding(.top, 2)
                        .background(Color.white)
                    }
                    .onAppear() {
                        userExploresViewModel.getExplores()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            proxy1.scrollTo(postID, anchor: .top)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear(){
            userExploresViewModel.getExplores()
            moments.list=userExploresViewModel.exploresList
        }
        .onChange(of: userExploresViewModel.exploresList) { V in
            moments.list=userExploresViewModel.exploresList
        }
    }
}
