//
//  OtherContentPostView.swift
//  Amigo
//
//  Created by Futing Shan on 10/24/22.
//

import SwiftUI
import Popovers
import AVKit
import VideoPlayer

struct OtherContentPostView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var moments = MomentPostViewModel()
    @State var content = ""
    
    @StateObject var userExploresViewModel : UserExploresViewModel
    
    @State var presentMenu = false;
    @State var reportingProblem = true
    @State var delete = false // delete available only in user's profile post page
    
    var userName : String
    var id: String
    let pfpWidth = UIScreen.main.bounds.size.width / 11
    
    init(id:String,userName:String){
        self.userName=userName
        self.id=id
        _userExploresViewModel = StateObject(wrappedValue: UserExploresViewModel(id: id))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color("colors/FEA3AC"))
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 7.5)  //OG VALUE 100
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10){
                VStack(alignment: .leading){
                    HStack (spacing: UIScreen.main.bounds.size.width / 4) {
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(Color.black)
                        })
                        Text(userName+"'s Post")
                            .font(.system(size: 20, weight: .bold, design: .default))
                    }
                    .padding(.horizontal)
                }
                .background(Color("colors/FEA3AC"))
                
                MyPostListView(moments: moments, delete: $delete)
            }
        }
        .navigationBarHidden(true)
        .onAppear(){
            userExploresViewModel.getExplores()
                //moments.getMomentsWithArray(momentArray: userExploresViewModel.exploresList.map({return $0.id}))

        }
        .onChange(of: userExploresViewModel.exploresList) { V in
                //moments.getMomentsWithArray(momentArray: userExploresViewModel.exploresList.map({return $0.id}))
                
        }
    }
}
