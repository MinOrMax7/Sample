//
//  MomentsViewWrapper.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 1/16/22.
//

import SwiftUI

struct MomentsView: View {
    @State var content = ""
    @State var localContentList = [AnyPickerContent]()
    // user can only delete their own post in their profile
    // so delete is always false
    @State var delete = false // delete indicator
    @State var inProfile = false
    @State var muted = false
    @Binding var shareID : String
    @Binding var userID: String
    @EnvironmentObject var deepLink: DeepLinkShare
    @State var action2 : String?
    @State var action : Int?
    
    let pfpWidth = UIScreen.main.bounds.size.width / 11
    let imageWidth = UIScreen.main.bounds.size.width / 1.1
    let topColor = Color("themeRed") // Color.init(red: 1, green: 0.64, blue: 0.68) // #FFA4AE, 1
    let bottomColor = Color.init(red: 0.94, green: 0.81, blue: 0.81) // #F0D0D0, 1
    
    var body: some View {
        ZStack(alignment: .top){
            Rectangle()
                .fill(Color("colors/FEA3AC"))
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 8)
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        Text("Post")
                            .font(.system(size: 24, weight: .bold, design: .default))
                        Spacer()
                        NavigationLink(destination: MomentsAddView(content: $content, pickerContentList: $localContentList, muted: $muted)) {
                            Image(systemName: "camera.fill.badge.ellipsis")
                                .foregroundColor(Color.black)
                                .padding(.trailing)
                        }
                        .padding(.trailing, 10)
                        Image(systemName: "bell")
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color("colors/FEA3AC"))
                
                ExploreListView(delete: $delete, inProfile: $inProfile, shareID: $shareID, userID: $userID).environmentObject(self.deepLink)
            }
//            .onAppear(){
//                if deepLink.loadingShare {
//                    self.action2 = shareID
//                    deepLink.loadingShare = false
//                } else {
//
//                }
//            }
//            .onChange(of: deepLink.loadingShare) { _ in
//                if deepLink.loadingShare {
//                    self.action2 = shareID
//                } else {
//
//                }
//            }

            
        }
        .navigationBarHidden(true)
    }
}
