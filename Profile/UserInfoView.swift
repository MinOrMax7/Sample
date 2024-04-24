//
//  UserInfoView.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 1/16/22.
//

import SwiftUI
import Popovers


struct UserInfoView: View {
    
    @EnvironmentObject var user : UserViewModel
    @EnvironmentObject var subscriptionViewModel : SubscriptionViewModel
    
    @State private var showCopiedPopup = false
    @State var expanding = false
    
    
    let pfpWidth = UIScreen.main.bounds.size.width * 122 / 390
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(LinearGradient(
                    gradient: .init(colors: [Color("colors/EFABAC30"), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                  ))
                .frame(width: UIScreen.main.bounds.size.width)
                .frame(maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 25){
                HStack{
                    Text(user.user.petName)
                        .font(.system(size: 28, weight: .bold, design: .default))
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        Image("Profile/Settings")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                
                HStack(spacing: 15){
                    ImageDownloadView(imagePullURL: .constant("users/\(user.user.id)/pfp.jpeg"))
                        .scaledToFill()
                        .frame(width: pfpWidth, height: pfpWidth)
                        .cornerRadius(7)
                        .clipped()
                    
                    VStack(){
                        HStack(alignment: .top){
                            VStack(alignment: .leading){
                                HStack(spacing: 9){
                                    Text(user.user.breed)
                                        .font(.system(size: 18, weight: .semibold, design: .default))
                                    let diffs = Calendar.current.dateComponents([.year, .month], from: user.user.petBirthDate, to: Date())
                                    let formattedFloat = String(format: "%.1f", (Float(diffs.year!) + Float(diffs.month!)/12))
                                    Text("\(formattedFloat) YR")
                                        .font(.system(size: 18, weight: .semibold, design: .default))
                                }
                                .foregroundColor(Color("colors/666666"))
                                .padding(.bottom, 11)
                                
                                Text("ID: @\(user.user.displayedID)")
                                    .foregroundColor(Color("colors/333333"))
                                    .font(.system(size: 12, weight: .semibold, design: .default))
                                    .onLongPressGesture(minimumDuration: 0.5){
                                        UIPasteboard.general.string = user.user.displayedID
                                        showCopiedPopup=true
                                    }
                                
                                Text("Owned by \(user.user.displayedName)")
                                    .foregroundColor(Color("colors/999999"))
                                    .font(.system(size: 12, weight: .semibold, design: .default))
                            }
                            Spacer()
                            NavigationLink {
                                SubscriptionView()
                            } label: {
                                if(subscriptionViewModel.level > 0){
                                    Image("Profile/VIP")
                                        .resizable()
                                        .frame(width: 61, height: 27)
                                } else {
                                    Image("Profile/notVIP")
                                        .resizable()
                                        .frame(width: 61, height: 27)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        HStack{
                            NavigationLink {
                                FollowView(userID: user.user.id, displayFollowerFlag: true)
                            } label: {
                                VStack{
                                    Text("\(user.user.followersCount)")
                                        .foregroundColor(Color("colors/333333"))
                                        .font(.system(size: 16, weight: .bold, design: .default))
                                    Text("Followers")
                                        .foregroundColor(Color("colors/666666"))
                                        .font(.system(size: 12, weight: .regular, design: .default))
                                }
                            }
                            
                            Spacer()
                            Divider()
                            Spacer()
                            NavigationLink {
                                FollowView(userID: user.user.id, displayFollowerFlag: false)
                            } label: {
                                VStack{
                                    Text("\(user.user.followingCount)")
                                        .foregroundColor(Color("colors/333333"))
                                        .font(.system(size: 16, weight: .bold, design: .default))
                                    Text("Following")
                                        .foregroundColor(Color("colors/666666"))
                                        .font(.system(size: 12, weight: .regular, design: .default))
                                }
                            }
                            
                            Spacer()
                            Divider()
                            Spacer()
                            VStack{
                                Text("0")
                                    .foregroundColor(Color("colors/333333"))
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                Text("Likes")
                                    .padding(.horizontal, 12)
                                    .foregroundColor(Color("colors/666666"))
                                    .font(.system(size: 12, weight: .regular, design: .default))
                            }
                        }
                        .padding()
                        .background(Color("colors/D9D9D9"))
                        .cornerRadius(7)
                        .clipped()
                    }
                    .frame(height: pfpWidth)
                    
                }
                
                Text("**BIO**:  \(user.user.bio)")
                    .font(.system(size: 18))
                    .frame(width: UIScreen.main.bounds.size.width * 0.87, height: UIScreen.main.bounds.size.height * 0.12, alignment:.topLeading)
                    //.fixedSize(horizontal: false, vertical: true)
                    //.padding(.top, 15)
            }
            .padding()
        }
        .popover(
            present: $showCopiedPopup,
            attributes: {
                $0.blocksBackgroundTouches = true
                $0.rubberBandingMode = .none
                $0.position = .relative(
                    popoverAnchors: [
                        .center,
                    ]
                )
                $0.presentation.animation = .easeOut(duration: 0.15)
                $0.dismissal.mode = .none
                $0.onTapOutside = {
                    showCopiedPopup=false
                }
            }
        ) {
            AlertPopupView(present: $showCopiedPopup, expanding:$expanding, text: "The id is copied to the cilpboard!")
        } background: {
            Color.black.opacity(0.1)
        }
    }
}
