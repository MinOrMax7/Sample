//
//  UserFollwerViewModel.swift
//  Amigo
//
//  Created by Jack Liu on 8/11/22.
//

import Foundation
import Firebase

class UserFollowersViewModel: ObservableObject {
    @Published var followersList = [UserFollower]()
    let userID: String
    let db = Firestore.firestore()
    init(id: String){
        self.userID = id
    }
    func getFollowers(){
        db.collection("users").document(userID).collection("followers").getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.followersList = snapshot.documents.map({ d in
                            let date = d["followerSince"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
                            return UserFollower(id: d.documentID, followerSince: date.dateValue())
                        })
                    }
                }
            }
        }
    }
    
    func addFollower(followerID: String){
        guard followersList.filter({$0.id == userID}).isEmpty else {
            return
        }
        
        //add followers document
        db.collection("users").document(self.userID).collection("followers").document(followerID).setData([
            "followerSince": Date()
        ])
        
        //update followersCount
        let ref = db.collection("users").document(self.userID)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("followersCount") as? Int ?? 0
                    ref.updateData([
                        "followersCount" : FieldValue + Int(1)
                    ])
                }
            }
        }
    }
    
    func removeFollower(followerID: String){
        db.collection("users").document(self.userID).collection("followers").document(followerID).delete()
        let ref = db.collection("users").document(self.userID)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("followersCount") as? Int ?? 1
                    ref.updateData([
                        "followersCount" : FieldValue - Int(1)
                    ])
                }
            }
        }
    }
}
