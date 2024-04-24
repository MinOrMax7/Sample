//
//  NameChangeView.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 1/9/22.
//

import SwiftUI

struct NameChangeView: View {
    @EnvironmentObject var user: UserViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    
    @State var firstName : String = ""
    @State var lastName : String = ""
    @State var bio : String = ""
    @State var displayedName : String = ""
    
    var body: some View {
        ScrollView{
            VStack{
                TextField("  First Name", text: $firstName)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding()
                TextField("  Last Name", text: $lastName)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding()
                TextField("  Displayed Name", text: $displayedName)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding()
                Text("a short bio...")
                    .multilineTextAlignment(.leading)
                TextEditor(text: $bio)
                    .frame(height: 200)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(Color.gray, lineWidth: 1)
                    ).padding()
                Spacer()
                Button(action: {
                    
                    guard !firstName.isEmpty, !lastName.isEmpty else {
                        return
                    }
                    
                    user.updateStringField(field: "firstName", value: firstName)
                    user.updateStringField(field: "lastName", value: lastName)
                    user.updateStringField(field: "bio", value: bio)
                    user.updateStringField(field: "displayedName", value: displayedName)
                    self.mode.wrappedValue.dismiss()
                    
                }, label: {
                    Text("Update")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .background(Color("themePink"))
                        .cornerRadius(8)
                    
                })
            }
        }
        .onAppear {
            firstName = user.user.firstName
            lastName = user.user.lastName
            bio = user.user.bio
            displayedName = user.user.displayedName
        }
    }
}

struct NameChangeView_Previews: PreviewProvider {
    static var previews: some View {
        NameChangeView()
    }
}
