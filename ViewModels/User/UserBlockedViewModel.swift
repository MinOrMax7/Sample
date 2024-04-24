//
//  UserBlockedUsersViewModel.swift
//  Amigo
//
//  Created by Jack Liu on 8/12/22.
//

import Foundation
import Firebase

class UserBlockedViewModel: ObservableObject {
    @Published var blockedList = [UserBlock]()
    let userID: String
    let db = Firestore.firestore()
    init(id: String){
        self.userID = id
    }
    func getBlocked(){
        db.collection("users").document(userID).collection("blocked").getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.blockedList = snapshot.documents.map({ d in
                            return UserBlock(id: d.documentID)
                        })
                    }
                }
            }
        }
    }
    
    func addBlocked(blockedID: String){
        guard blockedList.filter({$0.id == blockedID}).isEmpty else {
            return
        }
        db.collection("users").document(userID).collection("blocked").document(blockedID).setData([
            "exist": true
        ])
    }
    
    func removeBlocked(blockedID: String){
        db.collection("users").document(userID).collection("blocked").document(blockedID).delete()
    }
}
