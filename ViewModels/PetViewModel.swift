//
//  PetViewModel.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 1/16/22.
//

import Foundation
import Firebase
import SwiftUI

class PetViewModel: ObservableObject{
    @Published var pets = [Pet]()
    
    func addPet(ownerID: String, birthday: NSDate, name: String, breed: String) -> String{
        let db = Firestore.firestore()
        
        let newDoc = db.collection("users").document(ownerID).collection("pets").addDocument(data: ["ownerID" : ownerID, "birthday": birthday, "name": name, "breed": breed, "addedDate": Timestamp()])
        
        getData(ownerID: ownerID)
        
        return newDoc.documentID
    }
    
    func removePet(ownerID: String, petID: String){
        let db = Firestore.firestore()
        
        db.collection("users").document(ownerID).collection("pets").document(petID).delete() { err in
            if let err = err {
              print("Error removing document: \(err)")
            }
            else {
              print("Document successfully removed!")
            }
        }
        
    }
    
    func getData(ownerID: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document(ownerID).collection("pets").order(by: "addedDate", descending: false).getDocuments(completion: { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        
                        self.pets = snapshot.documents.map { d in
                            
                            
                            let addedDate = d["addedDate"] as! Timestamp
                            let birthday = d["birthday"] as! Timestamp

                            return Pet(id: d.documentID,
                                       ownerID: ownerID,
                                       addedDate: addedDate.dateValue() as NSDate,
                                       birthday: birthday.dateValue() as NSDate,
                                       name: d["name"] as? String ?? "",
                                       breed: d["breed"] as? String ?? ""
                            )
                        }
                    }
                }
            }
            else {
                
            }
        })
    }
    
}
