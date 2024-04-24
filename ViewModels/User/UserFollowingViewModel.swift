//
//  UserFollowingViewModel.swift
//  Amigo
//
//  Created by Jack Liu on 8/11/22.
//

import Foundation
import Firebase

class UserFollowingViewModel: ObservableObject {
    @Published var followingList = [UserFollowing]()
    let userID: String
    let db = Firestore.firestore()
    init(id: String){
        self.userID = id
    }
    func getFollowing(){
        db.collection("users").document(userID).collection("following").getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.followingList = snapshot.documents.map({ d in
                            let date = d["followingSince"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
                            return UserFollowing(id: d.documentID, followingSince: date.dateValue())
                        })
                    }
                }
            }
        }
    }
    
    func addFollowing(followingID: String){
        guard followingList.filter({$0.id == followingID}).isEmpty else {
            return
        }
        db.collection("users").document(userID).collection("following").document(followingID).setData([
            "followerSince": Date()
        ])
        //update followingCount
        let ref = db.collection("users").document(userID)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("followingCount") as? Int ?? 0
                    ref.updateData([
                        "followingCount" : FieldValue + Int(1)
                    ])
                }
            }
        }
    }
    
    func removeFollowing(followingID: String){
        db.collection("users").document(userID).collection("following").document(followingID).delete()
        let ref = db.collection("users").document(userID)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("followingCount") as? Int ?? 1
                    ref.updateData([
                        "followingCount" : FieldValue - Int(1)
                    ])
                }
            }
        }
    }
}

class UserFollowingSearchViewModel: ObservableObject {
    @Published var following : Bool? = nil
    var userID: String? = nil
    let db = Firestore.firestore()
    func searchFollowing(searchID: String){
        if let userID = userID {
            db.collection("users").document(userID).collection("following").document(searchID).addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    if let snapshot = snapshot, snapshot.exists {
                        self.following = true
                    } else {
                        self.following = false
                    }
                }
            }
        }
    }
}

