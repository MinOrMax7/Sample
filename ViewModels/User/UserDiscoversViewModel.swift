//
//  UserDiscoversViewModel.swift
//  Amigo
//
//  Created by Jack Liu on 8/11/22.
//

import Foundation
import Firebase

class UserDiscoversViewModel: ObservableObject {
    @Published var discoversList = [HoleDisplay]()
    let userID: String
    let db = Firestore.firestore()
    init(id: String){
        self.userID = id
    }
    func getDiscovers() {
        db.collection("holes").whereField("creator", isEqualTo: userID).getDocuments(){(snapshot, err )in
            if err == nil{
                DispatchQueue.main.async {
                    self.discoversList = snapshot!.documents.map({ d in
                        HoleDisplay(id: d.documentID,
                                           creator: d["creator"] as? String ?? "",
                                           title: d["title"] as? String ?? "",
                                           createdDate: (d["timestamp"] as! Timestamp).dateValue() as NSDate,
                                           content: d["content"] as? String ?? "",
                                           answers: d["answers"] as? Int ?? 0,
                                           views: d["views"] as? Int ?? 0,
                                           upvotes: d["upvotes"] as? Int ?? 0,
                                           imageCount: d["imageCount"] as? Int ?? 0,
                                           isAsk: d["isAsk"] as? Bool ?? false,
                                           favorites:d["favorites"] as? Int ?? 0,
                                           reported: d["reported"] as? Bool ?? false
                        )})
                    self.discoversList.sort{
                        $0.createdDate.compare($1.createdDate as Date) == .orderedDescending
                    }                    
                }
                
            }
        }
        
    }
    
    func addDiscovers(discoverID: String){
        db.collection("users").document(userID).collection("discovers").document(discoverID).setData([
            "archive": false
        ])
    }
    
    
    func removeDiscovers(discoverID: String){
        db.collection("users").document(userID).collection("discovers").document(discoverID).delete()
    }
}

class UserFavoriteDiscoversViewModel: ObservableObject {
    @Published var favoriteDiscoversList = [UserFavoriteDiscover]()
    let userID: String
    let db = Firestore.firestore()
    init(id: String){
        self.userID = id
    }
    
    func getFavoriteDiscovers() {
        db.collection("users").document(userID).collection("favoriteDiscovers").getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.favoriteDiscoversList = snapshot.documents.map({ d in
                            return UserFavoriteDiscover(id: d.documentID)
                        })
                    }
                }
            }
        }
    }
    func addUpvotesDiscovers(discoverID: String){
        let upvoteID = discoverID + "up"
        db.collection("users").document(userID).collection("favoriteDiscovers").document(upvoteID).setData([
            "exist": true
        ])
    }
    
    func removeUpvotes(discoverID: String){
        let upvoteID = discoverID + "up"
        db.collection("users").document(userID).collection("favoriteDiscovers").document(upvoteID).delete()
    }
    
    func addDownvotesDiscovers(discoverID: String){
        let upvoteID = discoverID + "down"
        db.collection("users").document(userID).collection("favoriteDiscovers").document(upvoteID).setData([
            "exist": true
        ])
    }
    
    func removeDownvotes(discoverID: String){
        let upvoteID = discoverID + "down"
        db.collection("users").document(userID).collection("favoriteDiscovers").document(upvoteID).delete()
    }
    
    func addFavoriteDiscovers(discoverID: String){
        db.collection("users").document(userID).collection("favoriteDiscovers").document(discoverID).setData([
            "exist": true
        ])
    }
    
    func removeFavorites(discoverID: String){
        db.collection("users").document(userID).collection("favoriteDiscovers").document(discoverID).delete()
    }
    
    
}

class UserFavoriteDiscoversSearchViewModel: ObservableObject {
    @Published var favorite : Bool? = nil
    @Published var upvote : Bool? = nil
    @Published var downvote : Bool? = nil
    @Published var upvoteAns : Bool? = nil
    @Published var downvoteAns : Bool? = nil
    
    var userID: String? = nil
    let db = Firestore.firestore()
    
    func searchFavoriteDiscovers(searchID: String){
        if let userID = userID {
            db.collection("users").document(userID).collection("favoriteDiscovers").document(searchID).addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    if let snapshot = snapshot, snapshot.exists {
                        self.favorite = true
                    } else {
                        self.favorite = false
                    }
                }
            }
        }
    }
    
    func searchUpvoteDiscovers(searchID: String){
        let newSearchID = searchID + "up"
        let newSearchID2 = searchID + "down"
        if let userID = userID {
            db.collection("users").document(userID).collection("favoriteDiscovers").document(newSearchID).addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    if let snapshot = snapshot, snapshot.exists {
                        self.upvote = true
                    } else {
                        self.upvote =  false
                    }
                }
            }
            
            db.collection("users").document(userID).collection("favoriteDiscovers").document(newSearchID2).addSnapshotListener { snapshot, error in
                DispatchQueue.main.async {
                    if let snapshot = snapshot, snapshot.exists {
                        self.downvote = true
                    } else {
                        self.downvote =  false
                    }
                }
            }
        }
    }
}
