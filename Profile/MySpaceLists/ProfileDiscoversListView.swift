//
//  ProfileDiscoversListView.swift
//  Amigo
//
//  Created by Jack Liu on 7/10/22.
//

import SwiftUI

struct ProfileDiscoversListView: View {
    @StateObject var discovers = HoleViewModel()
    
    @EnvironmentObject var userDiscoversViewModel : UserDiscoversViewModel
    @State var firstTime = true
    @State var firstTimeUpdate = true
    
    
    var body: some View {
        List{
            ForEach($discovers.list) { $discover in
                VStack{
                    HolePostView(hole: $discover)
//                    NavigationLink(destination: discover.isAsk ? AnyView(HoleDetailAnswerView(holeID: .constant(discover.id))) : AnyView(HoleDetailView(holeID: .constant(discover.id)))) {
//                        HolePostView(hole: $discover, showQList: .constant(false))
//                    }
//                    .buttonStyle(PlainButtonStyle())
                    .frame(width: UIScreen.main.bounds.size.width / 1.11, alignment: .leading)
                }
                .padding(.bottom, 30)
            }
            .onDelete { (indexSet) in
                indexSet.forEach{ (i) in
                    let id = discovers.list[i].id
                    userDiscoversViewModel.removeDiscovers(discoverID: id)
                    discovers.removeDiscover(discoverID: id)
                    discovers.list = discovers.list.filter({$0.id != id})
                    userDiscoversViewModel.discoversList = userDiscoversViewModel.discoversList.filter({$0.id != id})
                }
            }
        }
        .listStyle(PlainListStyle())
        .padding(.horizontal)
        .onAppear(){
            userDiscoversViewModel.getDiscovers()
            userDiscoversViewModel.discoversList.sort{
                $0.createdDate.compare($1.createdDate as Date) == .orderedDescending
                
            }
        }
    }
}

