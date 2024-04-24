//
//  OtherDiscoverView.swift
//  Amigo
//
//  Created by Futing Shan on 10/30/22.
//
import SwiftUI
import Popovers

/*
    View page of single discover
 */
struct OtherDiscoverView: View {
    @Binding var hole : HoleDisplay
    
    @StateObject var holeCounts = HoleDetailCountViewModel()
    @StateObject var discovers = HoleViewModel()
    @StateObject var userDiscoversViewModel : UserDiscoversViewModel
    
    @State var reportingProblem = false
    @State private var privateDate: NSDate = NSDate()
    @Binding var myDiscover : Bool
    @State var check = true
    @State var deleteAction = false
    
    var ID:String
    var userName:String
    
    init(ID: String,userName:String,hole:Binding<HoleDisplay>,myDiscover:Binding<Bool>){
        self.ID = ID
        self.userName = userName
        _userDiscoversViewModel = StateObject(wrappedValue: UserDiscoversViewModel(id: ID))
        self._hole=hole
        self._myDiscover=myDiscover
    }
    
    var body: some View {
        // UI display ratio
        let titleWidth = UIScreen.main.bounds.size.width * 0.87
        let tilleHeight = UIScreen.main.bounds.size.height * 0.04
        let contentWidth = UIScreen.main.bounds.size.width * 0.62
        let contentHeight = UIScreen.main.bounds.size.height * 0.07
        let imageWidth = UIScreen.main.bounds.size.width * 0.24
        let imageHeight = UIScreen.main.bounds.size.height * 0.07
        
        // margin ration
        let marginPadding =  UIScreen.main.bounds.size.width * 0.06   // left
        let marginPadding2 =  UIScreen.main.bounds.size.width * 0.07  // dot margin
        let marginPadding3 =  UIScreen.main.bounds.size.width * 0.05  // title left

        
        if (check) {
                VStack (alignment: .leading) {
                    //NavigationLink(destination: OtherShareQAListView(ID: ID, userName: userName)) {
                    NavigationLink(destination: HolePostProblemReportingView(hole: $hole), isActive: $reportingProblem) {EmptyView() }
                        VStack (alignment: .leading){
                            //NavigationLink(destination: EmptyView(), isActive: $deleteAction) { EmptyView() }
                            Text("\(hole.title)")
                                .font(.system(size: 14, weight: .bold))
                                .multilineTextAlignment(.leading)
                            //.fontWeight(.bold)
                                .foregroundColor(Color.black)
                                .frame(width: titleWidth, height: tilleHeight, alignment: .topLeading)
                                .padding(.leading, marginPadding3)
                            
                            HStack {
                                // input the content from firebase
                                Text("\(hole.content)")
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.black)
                                    .frame(width: contentWidth, height: contentHeight, alignment: .topLeading)
                                // input the Image by using imageCount
                                if (hole.imageCount > 0) {
                                    ImageDownloadView(imagePullURL: .constant("holes/\(hole.id)/1.jpeg"))
                                        .scaledToFill()
                                        .frame(width: imageWidth, height: imageHeight)
                                        .clipped()
                                }
                            }
                            .padding(.horizontal, marginPadding)
                        }
                    //}
                    VStack {
                        HStack() {
                            // input the viewed counts from firebase
                            Text("\(hole.views) viewed")
                                .font(.system(size: 10))
                                .foregroundColor(Color("colors/999999"))
                                .padding(.horizontal, marginPadding)
                            Text(" • ")
                                .font(.system(size: 10))
                                .foregroundColor(Color(hue: 1.0, saturation: 0.049, brightness: 0.556))
                                .padding(.leading, -marginPadding2)
                            // input the liked counts from firebase
                            if (hole.isAsk == true){
                                Text("\(holeCounts.answersCount) answers")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color("colors/999999"))
                                    .padding(.leading, -marginPadding + UIScreen.main.bounds.size.width * 0.02)
                            }
                            else {
                                Text("\(hole.upvotes) likes")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color("colors/999999"))
                                    .padding(.leading, -marginPadding + UIScreen.main.bounds.size.width * 0.07)
                            }
                            Spacer()
                            
                            Menu {
                                Button("Report this discover", action: reportDiscover)
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.049, brightness: 0.556))
                            }
                        }
                        .frame(width: UIScreen.main.bounds.size.width * 0.93)
                    }
                    Divider()
                        .padding(.horizontal, marginPadding)
                }
        }
    }
    
    func reportDiscover() {
        self.reportingProblem=true
    }
}
