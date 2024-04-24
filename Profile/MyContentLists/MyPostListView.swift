//
//  MyPostListView.swift
//  Amigo
//
//  Created by Mingxin Xie on 9/21/22.
//

import SwiftUI

struct MyPostListView: View {
    @ObservedObject var moments : MomentPostViewModel
    @EnvironmentObject var currentUser : UserViewModel
    @EnvironmentObject var userBlockedViewModel : UserBlockedViewModel
    @EnvironmentObject var deepLink: DeepLinkShare
    @State var muted = false
    @Binding var delete : Bool
    @State var inProfile = true
    @State var shareID: String = ""
    @State var userID: String = ""
    let pfpWidth = UIScreen.main.bounds.size.width / 11
    let imageWidth = UIScreen.main.bounds.size.width / 1.1
    
    
    var body: some View {
        ScrollView  {
            ForEach($moments.list) { $moment in
                VStack {
                    ExploreListLoadingView(moments: moments, muted: $muted, delete: $delete, inProfile: $inProfile, shareID: $shareID, userID: $userID, moment: moment).environmentObject(self.deepLink)
                }
            }
            .padding(.top, 10)
            .background(Color.white)
        }
    }
}
