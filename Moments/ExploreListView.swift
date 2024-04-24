//
//  MomentsListView.swift.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/21/21.
//

import SwiftUI

struct ExploreListView: View {
    @StateObject var moments = MomentPostViewModel()
    @EnvironmentObject var currentUser : UserViewModel
    @EnvironmentObject var userBlockedViewModel : UserBlockedViewModel
    @EnvironmentObject var deepLink: DeepLinkShare
    @State var muted = false
    @Binding var delete : Bool
    @Binding var inProfile : Bool
    @Binding var shareID : String
    @Binding var userID: String
    let pfpWidth = UIScreen.main.bounds.size.width / 11
    let imageWidth = UIScreen.main.bounds.size.width / 1.1

    
    
    var body: some View {
        ScrollView{
            PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                moments.reset()
                moments.getMorePosts()
            }
            VStack(alignment: .leading) {
                ForEach($moments.list) { $moment in
                    ExploreListLoadingView(moments: moments, muted: $muted, delete: $delete, inProfile: $inProfile, shareID: $shareID, userID: $userID, moment: moment).environmentObject(self.deepLink)
                }
                if moments.isLoadingPage {
                    ProgressView()
                }
            }
            .padding(.top, 10)
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .coordinateSpace(name: "pullToRefresh")
        .onAppear(){
            if(moments.list.count == 0){
                moments.getMorePosts()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.submitNewPost)) { _ in
            moments.reset()
        }
    }
}

struct ExploreListLoadingView: View {
    @ObservedObject var moments : MomentPostViewModel
    @EnvironmentObject var currentUser : UserViewModel
    @EnvironmentObject var userBlockedViewModel : UserBlockedViewModel
    @EnvironmentObject var deepLink: DeepLinkShare
    @Binding var muted : Bool
    @Binding var delete : Bool
    @Binding var inProfile : Bool
    @Binding var shareID: String
    @Binding var userID: String
    var moment: MomentPost
    
    @State var checked = false
    
    let screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View {
        VStack{
            if((!moment.reported || moment.user == currentUser.user.id) && !userBlockedViewModel.blockedList.contains(where: {$0.id == moment.user})){ //check if the post is flagged as reported and if it is blocked
                
                MomentPostView(moment: moment, muted: $muted, delete: $delete, shareID: $shareID, userID: $userID).environmentObject(self.deepLink)
                    .padding(.bottom, 23)
            }
            GeometryReader { geo in
                EmptyView()
                    .onChange(of: geo.frame(in: .global).maxY) { newValue in
                        if(geo.frame(in: .global).midY > 0 && geo.frame(in: .global).midY < screenHeight) { //if visible
                            if (!inProfile) { // loadmore from moments only in post view, not in profile my post page
                                if(!checked){
                                    checked = true
                                    moments.loadMorePostsIfNeeded(currentPost: moment)
                                }
                            }
                        }
                    }
            }
        }
    }
}
