//
//  MomentPostView.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/21/21.
//
import SwiftUI
import Popovers
import AVKit
import VideoPlayer

struct MomentPostView: View {
    @EnvironmentObject var userExploresViewModel : UserExploresViewModel
    @EnvironmentObject var user : UserViewModel
    
    @StateObject var post: MomentIndividualPostViewModel
    @StateObject var moments = MomentPostViewModel()
    @StateObject var userLikedPostViewModel = UserLikedPostViewModel()
    

    @State var shareContent : ShareContent?
    @EnvironmentObject var deepLink: DeepLinkShare
    @State var presentMenu = false;
    @State var reportingProblem = false
    @State var deleteAction = false
    @Binding var muted : Bool
    @Binding var delete : Bool
    @State var pageSelection = 0
    @Binding var shareID: String
    @Binding var userID: String
    @State var action : String?
    @State var isPost : Bool = false
    @State var action2: Int? = 0
    
    @State var width = UIScreen.main.bounds.size.width
    @State var height = UIScreen.main.bounds.size.width
    
    init(moment: MomentPost, muted: Binding<Bool>, delete: Binding<Bool>, shareID: Binding<String>, userID: Binding<String>){
        _post = StateObject(wrappedValue: MomentIndividualPostViewModel(moment: moment))
        _muted = muted
        _delete = delete
        _shareID = shareID
        _userID = userID
    }
    
    let pfpWidth = UIScreen.main.bounds.size.width / 11
    
    
    var body: some View {
        VStack{
            NavigationLink(destination: MomentPostProblemReportingView(post: post), isActive: $reportingProblem) { EmptyView() }
            
            NavigationLink(destination: MomentsDetailView(moment: post, postID: $shareID, userID: $userID), tag: shareID, selection: $action) { EmptyView() }
            
            HStack{
                NavigationLink(destination: NewOtherUserView(id: post.moment.user)) {
                    
                    ImageDownloadView(imagePullURL: .constant("users/\(post.moment.user)/pfp.jpeg"))
                        .scaledToFill()
                        .frame(width: pfpWidth, height: pfpWidth)
                        .clipShape(Capsule())
                        .padding(.trailing)
                    
                }
                UserNameView(userid: post.moment.user)
                
                Spacer()
                
                Menu {
                    if (delete == true) {
                        Button("Report a problem", action: set1)
                        Button("Delete this post", action: deletePost)
                    }
                    else {
                        Button("Report a problem", action: set1)
                        //{self.reportingProblem = true}
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
                
                
            }
            .padding(.horizontal)
            
            if(user.user.role == "admin" && Developing.showDebugID){
                Text("\(post.moment.id)")
            }
            
            VStack(alignment: .leading){
                if (post.moment.imageCount > 0){
                    TabView(selection: $pageSelection){
                        ForEach(0...post.moment.imageCount-1, id: \.self){ imageNum in
                            if(post.moment.imageType[imageNum]){ //Image
                                ImageDownloadView(imagePullURL: .constant("explores/\(post.moment.id)/\(imageNum+1).jpeg"))
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
                                    .clipped()
                            } else {
                                MomentPostVideoView(videoPullURL: .constant("explores/\(post.moment.id)/\(imageNum+1).mp4"), mute: $muted, width: $width, height: $height)
                            }
                        }
                    }
                    .frame(width: width, height: height)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                }
                
                VStack(alignment: .leading){
                    HStack() {
                        HStack(spacing: 4){
                            NavigationLink(destination: MomentCommentingView(moment: post)) {
                                Image(systemName: "ellipsis.bubble")
                                    .frame(alignment: .leading)
                                    .foregroundColor(Color.black)
                            }
                            NumberCountView(num: post.moment.commentsCount)
                                .font(.system(size: 14))
                                .padding(.trailing, 14)
                            
                            
                            HeartLikeView(moment: self.post)
                            
                            NumberCountView(num: post.moment.likes)
                                .font(.system(size: 14))
                                .padding(.trailing)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        if(post.moment.imageCount > 1){
                            PageControl(maxPages: post.moment.imageCount, currentPage: pageSelection)
                                .frame(width: UIScreen.main.bounds.size.width / 4)
                        }
                        
                        HStack(spacing: 10) {
                            HStack(spacing: 30) {
                                StarFavoriteView(moment: post)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                
                                Button{
                                    // modify the url to match our frontend domain as below:
                                    let postURL = URL(string: "https://traini.app/post/\(post.moment.user)/\(post.moment.id)")
                                    //let postURL = URL(string: "http://10.0.0.143:5173/post/\(post.moment.user)/\(post.moment.id)")
                                    //let postURL = URL(string: "TrainiPet://post/\(post.moment.id)/\(post.moment.user)")
                                    shareContent = ShareContent(url: postURL!)
                                } label : {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.black)
                                }
                                .sheet(item: $shareContent){ shareContent in
                                    ActivityView(url: shareContent.url)
                                }
                            }
                            
                            
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.horizontal)
                VStack (alignment: .leading, spacing: 5) {
                    if(post.moment.content != ""){
                        UserNameView(userid: post.moment.user, displayLocation: false, content: post.moment.content, size: 14)
                            .padding(.horizontal)
                    }
                    
                    NavigationLink(destination: LikedUsersView(postID: post.moment.id), tag: 2, selection: $action2) {
                        EmptyView()
                    }
                    Text("View Likes")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hue: 1.0, saturation: 0.049, brightness: 0.556))
                        .padding(.horizontal)
                        .onTapGesture {
                            self.action2 = 2
                        }
                }
            }
            .onAppear(){
                if deepLink.loadingPost{
                    self.action = shareID
                    if (deepLink.isPost) {
                        self.isPost = true
                        //deepLink.isPost = false
                    }
                }
                deepLink.loadingPost = false
            }
            .onChange(of: deepLink.loadingPost) { _ in
                if deepLink.loadingPost {
                    self.action = shareID
                } else {

                }
                deepLink.loadingPost = false
            }
            .onChange(of: deepLink.isPost) { _ in
                if deepLink.isPost {
                    self.isPost = true
                } else {
                    self.isPost = false
                }
            }
        }
    }
    func set1() {
        self.reportingProblem = true
    }
    
    // delete post function
    func deletePost() {
        self.deleteAction = true
        let id = post.moment.id
        userExploresViewModel.removeExplores(exploreID: id)
        userExploresViewModel.exploresList = userExploresViewModel.exploresList.filter({$0.id != id})
        moments.removePost(postID: post.moment.id)
        moments.list = moments.list.filter({$0.id != id})
    }
}
