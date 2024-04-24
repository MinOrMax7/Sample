//
//  AuthViewModel.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/28/21.
//

import Foundation
import FirebaseAuth
import Firebase
import GoogleSignIn

class AuthViewModel: ObservableObject{
    let auth = Auth.auth()
    @Published var signedIn = false
    @Published var hasError = false
    @Published var name = PersonNameComponents()
    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
    func signInWithGoogle() {
        // 1
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let configuration = GIDConfiguration(clientID: clientID)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        }
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
      if let error = error {
        print(error.localizedDescription)
        return
      }
      guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      auth.signIn(with: credential) { [unowned self] (_, error) in
        if let error = error {
            print(error.localizedDescription)
        } else {
            DispatchQueue.main.async {
                self.signedIn = true
            }
        }
      }
    }
    
    func signInWithApple(credential: AuthCredential, fullName: PersonNameComponents?){
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
                print(error?.localizedDescription as Any)
                return
            }
            DispatchQueue.main.async {
                if let fullName = fullName {
                    self.name = fullName
                }
                self.signedIn = true
            }
        }
    }
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                DispatchQueue.main.async {
                    self?.hasError = true
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signUp(email: String, password: String){
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        
        try? auth.signOut()
        
        self.signedIn = false
    }
    
    func deleteAccount(){
        let user = auth.currentUser
        user?.delete { error in
          if let error = error {
              print(error.localizedDescription)
          } else {
            // Account deleted.
          }
        }
        self.signedIn = false
    }
    
}
