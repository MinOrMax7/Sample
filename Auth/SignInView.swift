

import SwiftUI
import Popovers


struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var email = ""
    @State var password = ""
    @State private var selection: String? = nil
    
    
    @State var expanding = false // for popup animation
    @State private var showEmptyAlert = false
    
    let imageWidth = UIScreen.main.bounds.size.width / 4 * 3
    let buttonWidth = UIScreen.main.bounds.size.width / 10 * 9
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView{
                    VStack{
                        Image("Logo2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth, height: imageWidth)
                            .padding(.bottom, UIScreen.main.bounds.size.height / 250) //og value: 50
                        
                        TextField("  Email Address", text: $email)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color("colors/EEEEEE"), lineWidth: 1)
                            )
                            .padding(.bottom, 10)
                        SecureField("  Password", text: $password)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color("colors/EEEEEE"), lineWidth: 1)
                            )
                            .padding(.bottom, 10)
                        
                        
                        Button(action: {
                            
                            guard !email.isEmpty, !password.isEmpty else {
                                self.showEmptyAlert = true
                                return
                            }
                            authViewModel.signIn(email: email, password: password)
                        }, label: {
                            Text("Log In")
                                .foregroundColor(Color.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(Color("colors/FE7D7C"))
                                .clipShape(Capsule())
                        })
                        .padding(.bottom, 5)
                        
                        Divider()
                            .padding()
                        
                        Button(action: {
                            authViewModel.signInWithGoogle()
                        }, label: {
                            HStack{
                                Image("google")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                                Text("Google")
                                    .foregroundColor(Color.white)
                            }
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .clipShape(Capsule())
                        })
                        .padding(.bottom, 5)
                        
                        SignInWithAppleView()
                            .clipShape(Capsule())
                            .padding(.bottom, 5)
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("Create Account")
                                .foregroundColor(Color.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(Color("colors/FE7D7C"))// might change color
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal)
                    .popover(
                        present: $showEmptyAlert,
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
                        AlertPopupView(present: $showEmptyAlert, expanding: $expanding, text: "Please enter your Email and password")
                    } background: {
                        Color.black.opacity(0.1)
                    }
                    .popover(
                        present: $authViewModel.hasError,
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
                        AlertPopupView(present: $authViewModel.hasError, expanding: $expanding, text: "authentication failed")
                    } background: {
                        Color.black.opacity(0.1)
                    }
                }
                
                Spacer()
                
                VStack{
                    Text("By creating an account you agree to Traini's")
                    HStack{
                        Link(destination: URL(string: "https://docs.google.com/document/d/e/2PACX-1vS9Sl0Xf6kdAiBJBpS16Q15zZK0wIn9cjrH2b27U-J5wudYKSjOJFZmNz43R6V0zbMmObceg68Lx24T/pub")!) {
                            Text("Privacy Policy")
                                .underline()
                                .foregroundColor(Color("colors/666666"))
                        }
                        Text("and")
                        Link(destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!){
                            Text("Terms and Conditions")
                                .underline()
                                .foregroundColor(Color("colors/666666"))
                        }
                    }
                }
                .foregroundColor(Color("colors/666666"))
                .font(.system(size: 10, weight: .regular, design: .default))
                .ignoresSafeArea()
            }
            .navigationBarHidden(true)
        }
    }
}
