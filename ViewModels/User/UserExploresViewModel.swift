//
//  UserExploresViewModel.swift
//  Amigo
//
//  Created by Jack Liu on 8/11/22.
//

import Foundation
import Firebase

class UserExploresViewModel: ObservableObject {
    @Published var exploresList = [MomentPost]()
    let userID: String
    let db = Firestore.firestore()
    init(id: String){
        self.userID = id
    }
    
    func getExplores() {
        db.collection("explores").whereField("user", isEqualTo: userID).getDocuments{ snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.exploresList = snapshot.documents.map({ d in
                            MomentPost(id: d.documentID,
                                       user: d["user"] as? String ?? "",
                                       content: d["content"] as? String ?? "",
                                       likes: d["likes"] as? Int ?? 0,
                                       favorites: d["favorites"] as? Int ?? 0,
                                       commentsCount: d["commentsCount"] as? Int ?? 0,
                                       createdDate: (d["timestamp"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))).dateValue() as NSDate,
                                       imageCount: d["imageCount"] as? Int ?? 0,
                                       imageType: d["imageType"] as? [Bool] ?? [Bool](repeating: true, count: d["imageCount"] as? Int ?? 0),
                                       reported: d["reported"] as? Bool ?? false
                            )
                        })
                        self.exploresList.sort{
                            $0.createdDate.compare($1.createdDate as Date) == .orderedDescending
                        }
                    }
                }
            }
            
        }
    }
        
        func addExplores(exploreID: String){
            db.collection("users").document(userID).collection("explores").document(exploreID).setData([
                "archive": false
            ])
        }
        
        
        func removeExplores(exploreID: String){
            db.collection("users").document(userID).collection("explores").document(exploreID).delete()
        }
    
}
    
    
    class UserLikedExploresViewModel: ObservableObject {
        @Published var likedExploresList = [UserLikedExplore]()
        let userID: String
        let db = Firestore.firestore()
        init(id: String){
            self.userID = id
        }
        
        func getLikedExplores() {
            db.collection("users").document(userID).collection("likedExplores").getDocuments { snapshot, error in
                if error == nil{
                    if let snapshot = snapshot{
                        DispatchQueue.main.async {
                            self.likedExploresList = snapshot.documents.map({ d in
                                return UserLikedExplore(id: d.documentID)
                            })
                        }
                    }
                }
            }
        }
        
        func addLikedExplores(exploreID: String){
            db.collection("users").document(userID).collection("likedExplores").document(exploreID).setData([
                "exist": true
            ])
        }
        
        func removeLikedExplores(exploreID: String){
            db.collection("users").document(userID).collection("likedExplores").document(exploreID).delete()
        }
    }
    
    class UserLikedExploresSearchViewModel: ObservableObject {
        @Published var liked : Bool? = nil
        var userID: String? = nil
        let db = Firestore.firestore()
        func searchLikedExplores(searchID: String){
            if let userID = userID {
                db.collection("users").document(userID).collection("likedExplores").document(searchID).addSnapshotListener { snapshot, error in
                    DispatchQueue.main.async {
                        if let snapshot = snapshot, snapshot.exists {
                            self.liked = true
                        } else {
                            self.liked = false
                        }
                    }
                }
            }
        }
    }
    
    
    class UserFavoriteExploresViewModel: ObservableObject {
        @Published var favoriteExploresList = [UserFavoriteExplore]()
        let userID: String
        let db = Firestore.firestore()
        init(id: String){
            self.userID = id
        }
        
        func getFavoriteExplores() {
            db.collection("users").document(userID).collection("favoriteExplores").getDocuments { snapshot, error in
                if error == nil{
                    if let snapshot = snapshot{
                        DispatchQueue.main.async {
                            self.favoriteExploresList = snapshot.documents.map({ d in
                                return UserFavoriteExplore(id: d.documentID)
                            })
                        }
                    }
                }
            }
        }
        
        func addFavoriteExplores(exploreID: String){
            db.collection("users").document(userID).collection("favoriteExplores").document(exploreID).setData([
                "exist": true
            ])
        }
        
        func removeFavorites(exploreID: String){
            db.collection("users").document(userID).collection("favoriteExplores").document(exploreID).delete()
        }
    }
    
    class UserFavoriteExploresSearchViewModel: ObservableObject {
        @Published var favorite : Bool? = nil
        var userID: String? = nil
        let db = Firestore.firestore()
        func searchFavoriteExplores(searchID: String){
            if let userID = userID {
                db.collection("users").document(userID).collection("favoriteExplores").document(searchID).addSnapshotListener { snapshot, error in
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
    }

