//
//  OtherShareQALIstView.swift
//  Amigo
//
//  Created by Futing Shan on 10/30/22.
//
import SwiftUI

struct OtherShareQAListView: View {
    @StateObject var user : UserViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var userDiscoversViewModel : UserDiscoversViewModel
    
    @StateObject var discovers = HoleViewModel()

    @State var firstTime = true
    @State var firstTimeUpdate = true
    @State var myDiscover = true
    @State var showQList = true
    @State var deletePost = true
    
    
    var ID:String
    var userName:String
    
    init(ID: String,userName:String){
        self.ID = ID
        self.userName = userName
        _user = StateObject(wrappedValue: UserViewModel(id: ID))
        _userDiscoversViewModel = StateObject(wrappedValue: UserDiscoversViewModel(id: ID))
    }
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color("colors/FEA3AC"))
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 7.5)  //OG VALUE 100
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10){
                VStack(alignment: .leading){
                    HStack (spacing: UIScreen.main.bounds.size.width / 4.9) {
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(Color.black)
                        })
                        Text(userName+"'s Discover")
                            .font(.system(size: 20, weight: .bold, design: .default))
                    }
                    .padding(.horizontal)
                }
                .background(Color("colors/FEA3AC"))
                
                ScrollView {
                    ForEach($discovers.list) { $discover in
                        //MyContentDiscoverQAList(hole: $discover, deletePost: $deletePost)
                    }
                    .padding(.top, 10)
                    .background(Color.white)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear(){
            userDiscoversViewModel.getDiscovers()
            userDiscoversViewModel.discoversList.sort{
                $0.createdDate.compare($1.createdDate as Date) == .orderedDescending
                
            }
        }
    }
}
