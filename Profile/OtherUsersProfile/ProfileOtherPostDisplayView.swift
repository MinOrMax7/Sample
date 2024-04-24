//
//  ProfileOtherPostDisplayView.swift
//  Amigo
//
//  Created by Futing Shan on 10/24/22.
//

import SwiftUI
struct ProfileOtherPostDisplayView: View {
    var targetID:String
    var userName:String
    
    @StateObject var moments = MomentPostViewModel()
    @StateObject var userExploresViewModel : UserExploresViewModel
    
    @State var firstTime = true
    @State var firstTimeUpdate = true

    
    init(targetID: String,userName:String){
        self.targetID = targetID
        self.userName = userName
        _userExploresViewModel = StateObject(wrappedValue: UserExploresViewModel(id: targetID))
    }
    
    
    //The variable to decide the number of columns to be displayed
    var columnGrid: [GridItem] = [GridItem(.flexible(), spacing: 2),
                                  GridItem(.flexible(), spacing: 2),
                                  GridItem(.flexible(), spacing: 2)]
    
    var body: some View {
        ScrollView {
            if ($userExploresViewModel.exploresList.count == 0) {
                VStack (spacing: 10) {
                    Text("Post")
                        .font(.system(size: 18))
                        .foregroundColor(Color.black)
                        
                    Text("His/Her post will appear here")
                        .font(.system(size: 14))
                        .foregroundColor(Color("colors/999999"))
                }
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.35)
            } else {
                LazyVGrid(columns: columnGrid, spacing: 2){
                    ForEach($userExploresViewModel.exploresList) { $moment in
                        OtherPostView(id:targetID,userName: userName,post:$moment)
                    }
                }
            }
        }
        .onAppear(){
            userExploresViewModel.getExplores()
        }
        .onChange(of: userExploresViewModel.exploresList) { V in
        }
    }
}
