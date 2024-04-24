//
//  MomentsCommentView.swift
//  Amig Pet IOS App
//
//  Created by Xiaoxue Wang on 6/6/22.
//

import SwiftUI
import Popovers

struct MomentCommentingView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var currentUser : UserViewModel
    @ObservedObject var moment : MomentIndividualPostViewModel
    @StateObject var comments = MomentCommentViewModel()
    @State var currentUserComment = "";
    
    @State var shareContent : ShareContent?
    
    @State var presentMenu = false;
    @State var reportingProblem = false
    @State var reportingID = "";
    
    @State var muted = false;
    @State var pageSelection = 0
    @State var action2: Int? = 0
    
    let imageWidth = UIScreen.main.bounds.size.width
    let pfpWidth = UIScreen.main.bounds.size.width / 11
    let textWidth = UIScreen.main.bounds.size.width / 5 * 3
    let marginPadding = UIScreen.main.bounds.size.width * 0.04
    @State var width = UIScreen.main.bounds.size.width
    @State var height = UIScreen.main.bounds.size.width / 4 * 5
    
    var body: some View {
        NavigationLink(destination: MomentCommentProblemReportingView(comment: comments, commentID: $reportingID), isActive: $reportingProblem) { EmptyView() }
        
        ZStack(alignment: .top){
            Rectangle()
                .fill(Color("colors/FEA3AC"))
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 8)
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        })
                        Spacer()
                        Text("Post")
                            .font(.system(size: 18, weight: .bold, design: .default))
                        Spacer()
                        Image(systemName: "xmark")
                            .font(.system(size: 18))
                            .hidden()
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color("colors/FEA3AC"))
                
                ScrollView{
                    VStack(alignment: .leading, spacing: 10){
                        HStack{
                            NavigationLink(destination: NewOtherUserView(id: moment.moment.user)) {
                                
                                ImageDownloadView(imagePullURL: .constant("users/\(moment.moment.user)/pfp.jpeg"))
                                    .scaledToFill()
                                    .frame(width: pfpWidth, height: pfpWidth)
                                    .clipShape(Capsule())
                                    .padding(.trailing)
                                
                            }
                            UserNameView(userid: moment.moment.user)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 15)
                        
                        VStack(alignment: .leading, spacing: 5){
                            if (moment.moment.imageCount > 0){
                                TabView(selection: $pageSelection){
                                    ForEach(0...moment.moment.imageCount-1, id: \.self){ imageNum in
                                        if(moment.moment.imageType[imageNum]){ //Image
                                            ImageDownloadView(imagePullURL: .constant("explores/\(moment.moment.id)/\(imageNum+1).jpeg"))
                                                .scaledToFill()
                                                .frame(width: width, height: height)
                                                .clipped()
                                        } else {
                                            MomentPostVideoView(videoPullURL: .constant("explores/\(moment.moment.id)/\(imageNum+1).mp4"), mute: $muted, width: $width, height: $height)
                                        }
                                    }
                                }
                                .frame(width: width, height: height, alignment: .center)
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 5){
                                HStack(){
                                    HStack(spacing: 4){
                                        Image(systemName: "ellipsis.bubble")
                                            .frame(alignment: .leading)
                                            .foregroundColor(Color.black)
                                        
                                        NumberCountView(num: moment.moment.commentsCount)
                                            .font(.system(size: 14))
                                            .padding(.trailing, 14)
                                        
                                        
                                        HeartLikeView(moment: self.moment)
                                        
                                        NumberCountView(num: moment.moment.likes)
                                            .font(.system(size: 14))
                                            .padding(.trailing)
                                        
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    
                                    if(moment.moment.imageCount > 1){
                                        PageControl(maxPages: moment.moment.imageCount, currentPage: pageSelection)
                                            .frame(width: UIScreen.main.bounds.size.width / 4)
                                    }
                                    
                                    HStack(spacing: 10) {
                                        HStack(spacing: 20) {
                                            StarFavoriteView(moment: moment)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                            
                                            Button{
                                                // modify the url to match our frontend domain as below:
                                                let postURL = URL(string: "https://traini.app/post/\(moment.moment.user)/\(moment.moment.id)")
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
                                //.padding(.vertical)
                                
                                VStack (alignment: .leading, spacing: 5) {
                                    NavigationLink(destination: LikedUsersView(postID: moment.moment.id), tag: 2, selection: $action2) {
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
                                .offset(x: -marginPadding)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 25)
                    
                    
                    Divider()
                        .padding()
                    
                    VStack{
                        HStack(alignment: .center, spacing: 10){
                            ImageDownloadView(imagePullURL: .constant("users/\(currentUser.user.id)/pfp.jpeg"))
                                .scaledToFill()
                                .frame(width: pfpWidth, height: pfpWidth)
                                .clipShape(Capsule())
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: .constant("commenting brings good luck~"))
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("colors/999999"))
                                    .disabled(true)
                                
                                TextEditor(text: $currentUserComment)
                                    .font(.system(size: 14))
                                    .opacity(currentUserComment.isEmpty ? 0.25 : 1)
                            }
                            .padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            
                            Button(action: {
                                if(currentUserComment != ""){
                                    comments.addComment(user: currentUser.user.id, content: currentUserComment)
                                    moment.addCommentsCount()
                                    currentUserComment = ""
                                }
                            }, label: {
                                Image(systemName: "paperplane")
                            })
                        }.padding(.bottom, 10)
                        
                        ForEach($comments.comments){ $comment in
                            if comment.content != "" && (!comment.reported || comment.user == currentUser.user.id){
                                HStack(alignment: .top, spacing: 10){
                                    NavigationLink(destination: NewOtherUserView(id: comment.user)) {
                                        ImageDownloadView(imagePullURL: .constant("users/\(comment.user)/pfp.jpeg"))
                                            .scaledToFill()
                                            .frame(width: pfpWidth, height: pfpWidth)
                                            .clipShape(Capsule())
                                    }
                                    
                                    UserNameView(userid: comment.user, displayLocation: false, content: comment.content, size: 14)
                                    
                                    Spacer()
                                    
                                    if(comment.user == currentUser.user.id){
                                        Button(action: {
                                            comments.deleteComment(id: comment.id)
                                            moment.subtractCommentsCount()
                                        }, label: {
                                            Image(systemName: "trash")
                                        })
                                    } else {
                                        Templates.Menu {
                                            Templates.MenuButton(title: "Report a problem") {
                                                self.reportingID = comment.id
                                                self.reportingProblem = true
                                            }
                                        } label: { fade in
                                            Image(systemName: "ellipsis")
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            
                        }
                    }
                    .padding(.horizontal, 15)
                }
            }
        }
        .onAppear(){
            comments.momentID = moment.moment.id
            comments.getData()
        }
        .navigationBarHidden(true)
    }
}
