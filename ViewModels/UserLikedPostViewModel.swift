//
//  UserLikedPostViewModel.swift
//  Amigo
//
//  Created by Mingxin Xie on 11/14/22.
//

import SwiftUI
import Foundation
import Firebase

class UserLikedPostViewModel: ObservableObject {
    @Published var userLikedPosts = [UserLikedPost]()
    @StateObject var userLikedPostViewModel = UserLikedPostViewModel()
    
    func getAllData() {
        let db = Firestore.firestore()
        db.collection("userLikedPost").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.userLikedPosts = documents.map { (queryDocumentSnapshot) -> UserLikedPost in
                let data = queryDocumentSnapshot.data()
                let userID = data["userID"] as? String ?? ""
                let postID = data["postID"] as? String ?? ""
                return UserLikedPost(userID: userID, postID: postID)
            }
        }
    }
    
    func addNewData(userID: String, postID: String){
        let db = Firestore.firestore()
        db.collection("userLikedPost").addDocument(data: ["userID": userID, "postID": postID])
    }
    
    func deleteData(userID: String, postID: String) {
        // call the content collection
        let db = Firestore.firestore()
        db.collection("userLikedPost").whereField("userID", isEqualTo: userID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let deleteUID = data["userID"] as? String ?? ""
                    let deletePID = data["postID"] as? String ?? ""
                    
                    if (deletePID == postID && deleteUID == userID) {
                        let docID = document.documentID
                        db.collection("userLikedPost").document(docID).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    } else {
                        //
                    }
                }
            }
        }
    }
    
    func getLikedUsers(postID: String){
        let db = Firestore.firestore()
        db.collection("userLikedPost").whereField("postID", isEqualTo: postID).getDocuments() {
            (querySnapshot, err) in
            if let err = err {
                print("Error geeting documennts: \(err)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.userLikedPosts = documents.map { (queryDocumentSnapshot) -> UserLikedPost in
                    let data = queryDocumentSnapshot.data()
                    let likedUID = data["userID"] as? String ?? ""
                    let likedPID = data["postID"] as? String ?? ""
                    return UserLikedPost(userID: likedUID, postID: likedPID)
                }
            }
        }
    }
}
