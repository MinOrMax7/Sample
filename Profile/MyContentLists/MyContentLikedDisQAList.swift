//
//  MyContentLikedDisQAList.swift
//  Amigo
//
//  Created by Mingxin Xie on 10/4/22.
//

import SwiftUI

struct MyContentLikedDisQAList: View {
    @Binding var hole : HoleDisplay
    @StateObject var holeCounts = HoleDetailCountViewModel()
    @EnvironmentObject var userFavoriteDiscoversViewModel : UserFavoriteDiscoversViewModel
    @StateObject var discovers = HoleViewModel()

    @State var reportingProblem = false
    
    let pfpWidth = UIScreen.main.bounds.size.width / 21
    let imageWidth = UIScreen.main.bounds.size.width / 1.15
    let imageHeight = (UIScreen.main.bounds.size.width / 1.15) * 196 / 337
    
    @State private var privateDate: NSDate = NSDate()
    @Binding var deletePost : Bool
    @State var deleteAction = false
    @State var firstTime = true
    @State var firstTimeUpdate = true
    
    var body: some View {
        VStack(alignment: .leading){
            NavigationLink(destination: HolePostProblemReportingView(hole: $hole), isActive: $reportingProblem) { EmptyView() }
            
            VStack(alignment: .leading, spacing: 6){
                if (hole.isAsk && holeCounts.answersCount == 0){
                    Text("A question suggested for you:")
                        .font(.system(size: 12))
                        .foregroundColor(Color("colors/000000").opacity(0.3))
                }
                
                Text(hole.title)
                    .font(.system(size: 16, weight: .bold))
            }
            .padding(.top, 18)
            .padding(.bottom, (holeCounts.answersCount != 0 || !hole.isAsk) ? 6 : 2)
            
            if (!hole.isAsk){
                VStack(alignment: .leading){
                    HoleFrontPageUserView(id: hole.creator, displayFollow: true, displayDate: false, date: privateDate, frontPage: true)
                        .padding(.top, 6)
                    
                    if (hole.imageCount > 0){
                        ImageDownloadView(imagePullURL: .constant("holes/\(hole.id)/1.jpeg"))
                            .scaledToFill()
                            .frame(
                                maxWidth: imageWidth,
                                maxHeight: imageHeight
                            )
                            .clipped()
                    }
                    
                    if (hole.content != ""){
                        Text("\(hole.content)")
                            .padding(.trailing)
                            .font(.system(size: 14))
                            .lineLimit(3)
                    }
                }
            }
            
            if (holeCounts.answersCount > 0){
                VStack(alignment: .leading){
                    if let firstAnswer = holeCounts.firstAnswer{
                        if firstAnswer.content != "" {
                            HoleFrontPageUserView(id: firstAnswer.user, displayFollow: true, displayDate: false, date: privateDate, frontPage: true)
                                .padding(.top, 6)
                            
                            Text(firstAnswer.content)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            
                        }
                    }
                }
            }
            
            HStack {
                if (hole.isAsk == true){
                    Text("\(holeCounts.answersCount) answers")
                        .padding(.trailing)
                }
                else {
                    Text("\(holeCounts.commentsCount) comments")
                        .padding(.trailing)
                }
                
                Text("\(holeCounts.viewsCount) views")
                    .padding(.trailing)
                
                Spacer()
                
                Menu {
                    if (deletePost == true) {
                        Button("Report a problem", action: set1)
                    }
                    else {
                        Button("Report a problem", action: set1)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .offset(x: -UIScreen.main.bounds.size.width * 0.07)
                
            }
            .font(.system(size: 12))
            .foregroundColor(.gray)
            .padding(.bottom, 12)
            .padding(.top, (holeCounts.answersCount != 0 || !hole.isAsk) ? 4 : 0)
        }
        //.frame(width: imageWidth)
        .padding(.trailing)
        .padding(.leading, 25)
        .onAppear(){
            holeCounts.getCounts(holeID: hole.id)
        }
        .onAppear(){
            userFavoriteDiscoversViewModel.getFavoriteDiscovers()
            if firstTime {
                discovers.getHolesWithArray(holeArray: userFavoriteDiscoversViewModel.favoriteDiscoversList.map({return $0.id}))
                firstTime = false
            }
        }
        .onChange(of: userFavoriteDiscoversViewModel.favoriteDiscoversList) { V in
            if firstTimeUpdate{
            discovers.getHolesWithArray(holeArray: userFavoriteDiscoversViewModel.favoriteDiscoversList.map({return $0.id}))
                firstTimeUpdate = false
            }
        }
    }
    
    func set1() {
        self.reportingProblem = true
    }
}
