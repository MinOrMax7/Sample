

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var email = ""
    @State var password = ""
    @State var showAlert = false
    @State var alertMessage = ""
    
    @State var expanding = false // popup animation
    
    var body: some View {
        ScrollView{
            VStack{
                
                TextField("  Email Address", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color("colors/EEEEEE"), lineWidth: 1)
                    )
                    .padding(.vertical)
                
                SecureField("  Password", text: $password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color("colors/EEEEEE"), lineWidth: 1)
                    )
                    .padding(.vertical)
                
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        alertMessage = "Email or password cannot be empty"
                        showAlert = true
                        return
                    }
                    
                    guard textFieldValidatorEmail(email) else {
                        alertMessage = "Email is invalid"
                        showAlert = true
                        return
                    }
                    
                    guard password.count >= 6 else {
                        alertMessage = "Password must be at least six characters long"
                        showAlert = true
                        return
                    }
                    
                    authViewModel.signUp(email: email, password: password)
                }, label: {
                    Text("Create Account")
                        .foregroundColor(Color.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color("colors/FE7D7C"))
                        .clipShape(Capsule())
                    
                })
                    .padding(.top, 200)
            }
            .padding(.horizontal)
            .padding(.top, 100)
            .popover(
                present: $showAlert,
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
                AlertPopupView(present: $showAlert, expanding: $expanding, text: alertMessage)
            } background: {
                Color.black.opacity(0.1)
            }
        }
        .navigationTitle("Create Account")
    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
