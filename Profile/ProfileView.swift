//
//  ProfileView.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/30/21.
//

import SwiftUI
import Combine

struct ProfileView: View {
    @State var action2 : String?
    @Binding var shareID : String
    @EnvironmentObject var deepLink: DeepLinkShare
    @EnvironmentObject var user : UserViewModel
    
//    init() {
//        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("themePink"))
//        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
//    }
    
    var body: some View {
        VStack {
            UserInfoView()
                .navigationBarHidden(true)
            
            ProfileNavigationBarView()
        }
//        .onAppear(){
//            if deepLink.loadingShare {
//                self.action2 = shareID
//                deepLink.loadingShare = false
//            } else {
//
//            }
//        }
//        .onChange(of: deepLink.loadingShare) { _ in
//            if deepLink.loadingShare {
//                self.action2 = shareID
//            } else {
//
//            }
//        }
    }
}
