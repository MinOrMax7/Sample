//
//  SettingsView.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 1/2/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var user : UserViewModel
    
    @State var showingOptions = false
    @State var expanding = false // for popup animation
    
    let pfpWidth = UIScreen.main.bounds.size.width / 6
    
    var body: some View {
        List{
            NavigationLink(destination: PFPChangeView()){
                HStack{
                    Text("Profile Photo: ")
                    
                    Spacer()
                    
                    ImageDownloadView(imagePullURL: .constant("users/\(user.user.id)/pfp.jpeg"))
                        .scaledToFill()
                        .frame(width: pfpWidth, height: pfpWidth)
                        .cornerRadius(5)
                        .clipped()
                        .padding(.trailing)
                }
            }
            .padding()
            
            NavigationLink(destination: NameChangeView()){
                HStack{
                    Text("Full Name")
                    
                    Spacer()
                    
                    Text(user.user.firstName + " " + user.user.lastName)
                        .fontWeight(.light)
                }
            }
            .padding()
            
            NavigationLink(destination: NameChangeView()){
                HStack{
                    Text("Displayed Name: ")
                    
                    Spacer()
                    
                    Text(user.user.displayedName)
                        .fontWeight(.light)
                }
            }
            .padding()
            
            NavigationLink(destination: NameChangeView()){
                VStack(alignment: .leading, spacing: 20){
                    Text("Bio: ")
                    
                    Text(user.user.bio)
                        .fontWeight(.light)
                }
            }
            .padding()
            
            NavigationLink(destination: SubscriptionView()){
                Text("Subscription")
            }
            .padding()
            
            if(user.user.role == "admin"){
                NavigationLink(destination: CourseAddView()){
                    Text("Add Courses")
                }
                .padding()
            }
            
            Button(action: {
                authViewModel.signOut()
            }, label: {
                Text("Sign Out")
            })
            .padding()
            
            Button(action: {
                showingOptions = true
            }, label: {
                Text("Delete Account")
            })
            .padding()
            .popover(
                present: $showingOptions,
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
                        withAnimation(.easeIn(duration: 0.15)) {
                            expanding = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeOut(duration: 0.4)) {
                                expanding = false
                            }
                        }
                    }
                }
            ) {
                AlertPopupView(present: $showingOptions, expanding: $expanding, text: "You cannot undo this action")
            } background: {
                Color.black.opacity(0.1)
            }

            
        }
        .listStyle(PlainListStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
