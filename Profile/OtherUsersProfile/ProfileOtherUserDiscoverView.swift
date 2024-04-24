//
//  ProfileOtherUserDiscover.swift
//  Amigo
//
//  Created by Futing Shan on 10/30/22.
//
import SwiftUI

/*
    View page of the scrolling list of questions and discover post
 */
struct ProfileOtherUserDiscoverView: View {
    @StateObject var user : UserViewModel
    // fetching data for discovers post
    @StateObject var userDiscoversViewModel : UserDiscoversViewModel
    
    @State var myDiscover = true
    
    var ID:String
    var userName:String
    
    init(ID: String,userName:String){
        _user = StateObject(wrappedValue: UserViewModel(id: ID))
        self.ID = ID
        self.userName = userName
        _userDiscoversViewModel = StateObject(wrappedValue: UserDiscoversViewModel(id: ID))
    }
    
    
    
    var body: some View {
        VStack (alignment: .leading, spacing: UIScreen.main.bounds.size.height * 0.02) {
            ScrollView {
                if ($userDiscoversViewModel.discoversList.count == 0) {
                    VStack (spacing: 10) {
                        Text("Discover")
                            .font(.system(size: 18))
                            .foregroundColor(Color.black)
                            
                        Text("His/Her discover will appear here")
                            .font(.system(size: 14))
                            .foregroundColor(Color("colors/999999"))
                    }
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.35)
                } else {
                    ForEach($userDiscoversViewModel.discoversList) { $discover in
                        OtherDiscoverView(ID:ID,userName: userName,hole: $discover, myDiscover: $myDiscover)
                    }
                }
            }
        }
        .frame(height: UIScreen.main.bounds.size.height * 0.35)
        .onAppear(){
            userDiscoversViewModel.getDiscovers()
        }
        .onChange(of: userDiscoversViewModel.discoversList) { V in
        }
    }
}
