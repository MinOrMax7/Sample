//
//  NewOtherUserView.swift
//  Amigo
//
//  Created by Futing Shan on 10/24/22.
//

import SwiftUI
import Popovers

struct NewOtherUserView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var currentUser : UserViewModel
    @EnvironmentObject var currenUserFollowingViewModel : UserFollowingViewModel
    @EnvironmentObject var userBlockedViewModel : UserBlockedViewModel
    
    @StateObject var user : UserViewModel
    @StateObject var userFollowersViewModel : UserFollowersViewModel
    
    @StateObject var userFollowingSearchViewModel = UserFollowingSearchViewModel()
    
    @State private var showBlockPopup = false
    @State private var showUnblockPopup = false
    @State private var showCopiedPopup = false
    @State private var showUnFollowPopup = false
    
    
    var width = UIScreen.main.bounds.width
    @State var post = true
    @State var discover = false
    @State var likedPostDis = false
    @State var expanding = false
    
    
    var id : String
    
    var blocked : Bool {
        return userBlockedViewModel.blockedList.contains(where: {$0.id == self.id})
    }
    
    init(id: String){
        _user = StateObject(wrappedValue: UserViewModel(id: id))
        _userFollowersViewModel = StateObject(wrappedValue: UserFollowersViewModel(id: id))
        self.id = id
    }
    
    let scrWidRatio = UIScreen.main.bounds.size.width/390
    let scrHigRatio = UIScreen.main.bounds.size.height/844
    
    let pfpWidth = UIScreen.main.bounds.size.width * 96 / 390
    
    var body: some View {
        VStack{
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
                
                VStack(alignment: .leading, spacing: scrWidRatio*16){
                    
                    VStack(alignment: .leading, spacing: scrWidRatio*16){
                        ZStack{
                            HStack(){
                                Button(action: {
                                    self.mode.wrappedValue.dismiss()
                                }, label: {
                                    Image("back")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height:35*scrHigRatio)
                                })
                                
                                Spacer()
                                
                                Templates.Menu {
                                    if(!blocked){
                                        Templates.MenuButton(title: "Block user") {self.showBlockPopup = true}
                                    }else{
                                        Templates.MenuButton(title: "Unlock user") {self.showUnblockPopup = true}
                                    }
                                } label: { fade in
                                    Image(systemName: "ellipsis")
                                }
                            }
                        }.padding(.top,5*scrHigRatio)
//                        HStack{
//                            Text(user.user.displayedName)
//                                .font(.system(size: 28, weight: .bold, design: .default))
//                            Spacer()
//                        }.padding(.top,scrWidRatio*8)
                        
                        HStack(alignment:.top,spacing:scrWidRatio*31){
                            ImageDownloadView(imagePullURL: .constant("users/\(id)/pfp.jpeg"))
                                .scaledToFill()
                                .frame(width: pfpWidth, height: pfpWidth)
                                .cornerRadius(16)
                                .clipped()
                            
                            VStack(alignment: .leading){
                                HStack(spacing: scrWidRatio*8){
//                                    Text(user.user.breed)
//                                        .foregroundColor(Color("colors/333333"))
//                                        .font(.system(size: 14, weight: .semibold, design: .default))
//                                    let diffs = Calendar.current.dateComponents([.year, .month], from: user.user.petBirthDate, to: Date())
//                                    let formattedFloat = String(format: "%.1f", (Float(diffs.year!) + Float(diffs.month!)/12))
//                                    Text("\(formattedFloat) YR")
//                                        .foregroundColor(Color("colors/333333"))
//                                        .font(.system(size: 14, weight: .semibold, design: .default))
                                    Text(user.user.displayedName)
                                        .foregroundColor(Color("colors/333333"))
                                        .font(.system(size: 18, weight: .bold, design: .default))
                                }
                                //.foregroundColor(Color("colors/666666"))
                                Text("ID: @\(user.user.displayedID)")
                                    .foregroundColor(Color("colors/666666"))
                                    .font(.system(size: 14, design: .default))
                                    .onLongPressGesture(minimumDuration: 0.5){
                                        UIPasteboard.general.string = user.user.displayedID
                                        showCopiedPopup=true
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
                                                .font(.system(size: 14, weight: .regular, design: .default))
                                        }
                                    }
                                    
                                    Spacer()
                                    Divider()
                                        .frame(width: 1.48*scrWidRatio,height:35*scrHigRatio)
                                        .foregroundColor(Color("colors/999999"))
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
                                                .font(.system(size: 14, weight: .regular, design: .default))
                                        }
                                    }
                                    Spacer()
                                    Divider()
                                        .frame(width: 1.48*scrWidRatio,height:35*scrHigRatio)
                                        .foregroundColor(Color("colors/999999"))
                                    Spacer()
                                    VStack{
                                        Text("0")
                                            .foregroundColor(Color("colors/333333"))
                                            .font(.system(size: 16, weight: .bold, design: .default))
                                        Text("Likes")
                                            .padding(.horizontal, 12*scrWidRatio)
                                            .foregroundColor(Color("colors/666666"))
                                            .font(.system(size: 14, weight: .regular, design: .default))
                                    }
                                }
                                .padding(.trailing,31*scrWidRatio)
                            }
                            .frame(height: pfpWidth)
                            
                        }
                        .frame(height:pfpWidth)
                        .padding(.bottom,16*scrWidRatio)
                        if(blocked){
                            Divider()
                                .foregroundColor(Color("colors/999999"))
                        }
                        else{
                            HStack(alignment: .top, spacing:23*scrWidRatio){
                                if(user.user.id != currentUser.user.id){
                                    if let following = userFollowingSearchViewModel.following{
                                        if following == true {
                                            Button(action: {
                                                showUnFollowPopup = true
                                            }, label: {
                                                Text("Unfollow")
                                                    .font(.system(size:14,weight:.semibold))
                                                    .padding()
                                                    .foregroundColor(Color.white)
                                            })
                                            .frame(width: 266*scrWidRatio, height: 32*scrHigRatio)
                                            .background(Color.gray)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray, lineWidth: 2)
                                            )
                                        } else {
                                            Button(action: {
                                                currenUserFollowingViewModel.addFollowing(followingID: user.user.id)
                                                userFollowersViewModel.addFollower(followerID: currentUser.user.id)
                                            }, label: {
                                                Text("Follow")
                                                    .font(.system(size:14,weight:.semibold))
                                                    .padding()
                                                    .foregroundColor(Color.white)
                                            })
                                            .frame(width: 266*scrWidRatio, height: 32*scrHigRatio)
                                            .background(Color("colors/E65D75"))
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color("colors/E65D75"), lineWidth: 2)
                                            )
                                        }
                                        Button(action: {
                                            // TODO: CHAT API
                                        }, label: {
                                            Text("Chat")
                                            .font(.system(size:14,weight:.semibold))
                                            .foregroundColor(Color("colors/E65D75"))
                                            .padding()
                                        })
                                        .frame(width: 76*scrWidRatio, height: 32*scrHigRatio)
                                        .background(Color("colors/E5E5E5"))
                                        .cornerRadius (8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color("colors/E65D75"), lineWidth: 2)
                                        )
                                        
                                    }
                                    
                                }
                            }
                            
                            VStack(alignment: .leading,spacing:11*scrHigRatio){
                                Text("**BIO**:")
                                    .font(.system(size: 16,weight: .bold))
                                Text("\(user.user.bio)")
                                    .font(.system(size: 16))
                                    .frame(width: 336*scrWidRatio, height: 60*scrHigRatio, alignment:.topLeading)
                            }
                            
                            
                        }
                    }
                    .padding(.horizontal)
                    //ProfileNavigationBarView()
                    if(blocked){
                    }
                    else{
                        VStack (alignment: .center, spacing: UIScreen.main.bounds.size.width * 0.04){
                            ZStack {
                                HStack (spacing: 20){
                                    // My post tab
                                    Button (action: {
                                        post = true
                                        discover = false
                                        likedPostDis = false
                                        
                                    }) {
                                        VStack {
                                            if (!discover && !likedPostDis) {
                                                Image("ProfileDiscovers/boldGrid")
                                            } else {
                                                Image("ProfileDiscovers/grid")
                                            }
                                            
                                            if (!discover && !likedPostDis) {
                                                Rectangle()
                                                    .fill(Color("colors/E65D75"))
                                                    .frame(width: UIScreen.main.bounds.size.width * 0.13, height: 3.0)
                                            }
                                        }
                                    }
                                    Spacer()
                                    
                                    // My discover tab
                                    Button (action: {
                                        post = false
                                        discover = true
                                        likedPostDis = false
                                    }) {
                                        VStack {
                                            if (!post && !likedPostDis) {
                                                Image("ProfileDiscovers/boldQA")
                                            } else {
                                                Image("ProfileDiscovers/QA")
                                            }
                                            
                                            if (!post && !likedPostDis) {
                                                Rectangle()
                                                    .fill(Color("colors/E65D75"))
                                                    .frame(width: UIScreen.main.bounds.size.width * 0.13, height: 3.0)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 80)
                                
                                Rectangle()
                                    .fill(Color("colors/CCB3B5").opacity(0.5))
                                    .frame(width: UIScreen.main.bounds.size.width, height: 3.0)
                                    .offset(y:  16)
                            }
                            if (!discover && !likedPostDis) {
                                ProfileOtherPostDisplayView(targetID:user.user.id,userName:user.user.displayedName)
                                    .offset(y: -UIScreen.main.bounds.size.width * 0.04)
                            }
                            else if (!post && !likedPostDis) {
                                ProfileOtherUserDiscoverView(ID: user.user.id, userName: user.user.displayedName)
                            }
                        }.highPriorityGesture(DragGesture()
                            .onEnded({ (value)  in
                                if (value.translation.width > 60) {
                                    self.changeView(left: false)
                                }
                                if (-value.translation.width > 60) {
                                    self.changeView(left: true)
                                }
                            })
                        )}
                    Spacer()
                }
            }
            .onAppear(){
                userFollowingSearchViewModel.userID = currentUser.user.id
                userFollowingSearchViewModel.searchFollowing(searchID: self.id)
            }
//            .toolbar {
//                Templates.Menu {
//                    if(blocked){
//                        Templates.MenuButton(title: "Unblock User") {self.showUnblockPopup = true}
//
//                    } else {
//                        Templates.MenuButton(title: "Block User") {self.showBlockPopup = true}
//                    }
//                } label: { fade in
//                    Image(systemName: "ellipsis")
//                }
//            }
            .popover(
                present: $showBlockPopup,
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
                }
            ) {
                VStack(spacing: 0) {
                    VStack(spacing: 6) {
                        Text("By blocking this user you will not be able to see their posts, discovers, comments, and chats")
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    Divider()
                    
                    Button {
                        userBlockedViewModel.addBlocked(blockedID: self.id)
                        userBlockedViewModel.blockedList.append(UserBlock(id: self.id))
                        showBlockPopup = false
                    } label: {
                        Text("Yes")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(Templates.AlertButtonStyle())
                    
                    Button {
                        showBlockPopup = false
                    } label: {
                        Text("No")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(Templates.AlertButtonStyle())
                }
                .background(Color.white)
                .cornerRadius(16)
                .popoverShadow(shadow: .system)
                .frame(width: 260)
            } background: {
                Color.black.opacity(0.1)
            }
            .popover(
                present: $showUnblockPopup,
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
                }
            ) {
                VStack(spacing: 0) {
                    VStack(spacing: 6) {
                        Text("Are you sure you want to unblock this user?")
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    Divider()
                    
                    Button {
                        userBlockedViewModel.removeBlocked(blockedID: self.id)
                        userBlockedViewModel.blockedList = userBlockedViewModel.blockedList.filter({$0.id != self.id})
                        showUnblockPopup = false
                    } label: {
                        Text("Yes")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(Templates.AlertButtonStyle())
                    
                    Divider()
                    
                    Button {
                        showUnblockPopup = false
                    } label: {
                        Text("No")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(Templates.AlertButtonStyle())
                }
                .background(Color.white)
                .cornerRadius(16)
                .popoverShadow(shadow: .system)
                .frame(width: 260)
            } background: {
                Color.black.opacity(0.1)
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
            .popover(
                present: $showUnFollowPopup,
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
                }
            ) {
                VStack(spacing: 0) {
                    VStack(spacing: 6) {
                        Text("Are you sure you want to unfollow this user?")
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    Divider()
                    
                    Button {
                        currenUserFollowingViewModel.removeFollowing(followingID: self.id)
                        userFollowersViewModel.removeFollower(followerID: currentUser.user.id)
                        showUnFollowPopup = false
                    } label: {
                        Text("Yes")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(Templates.AlertButtonStyle())
                    
                    Divider()
                    
                    Button {
                        showUnFollowPopup = false
                    } label: {
                        Text("No")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(Templates.AlertButtonStyle())
                }
                .background(Color.white)
                .cornerRadius(16)
                .popoverShadow(shadow: .system)
                .frame(width: 260)
            } background: {
                Color.black.opacity(0.1)
            }
            
            
            
            
        }
        .navigationBarHidden(true)
        
    }
    
    
    func changeView(left : Bool) {
        if left {
            if (!discover) { // left swipe in My post --> my discover
                post = false
                discover = true
            }
            else {
                //
            }
        } else {
            if (!discover && !likedPostDis) { // right swipe in My post --> my post
                post = true
                discover = false
            }
            else if (!post && !likedPostDis) { // right swipe in My discover --> my post
                post = true
                discover = false
            }
            else {
                //
            }
        }
    }
}
