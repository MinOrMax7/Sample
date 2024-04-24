//
//  UserViewModel.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/30/21.
//
import Foundation
import Firebase
import SwiftUI

class UserViewModel: ObservableObject{
    @Published var user : User
    @Published var firstTime = true;
    @Published var finishedLoading = false;
    
    let db = Firestore.firestore()
    
    init(id: String, cleanUp: Bool = false){
        self.user = User(id: id, displayedID: "", role: "user", createdTime: NSDate(), firstName: "", lastName: "", displayedName: "", bio: "", petName: "", petGender: true, breed: "", petBirthDate: Date(), togetherDate: Date(), questions: [], followersCount: 0, followingCount: 0,
//                         followers: [], following: [], explores: [], likedExplores: [], favoriteExplores: [], discovers: [],
                         chats: [], payed: 0)
        
        self.getUserData(cleanUp: cleanUp)
    }
    
    func getUserData(cleanUp: Bool) {
        guard user.id != "" else {
            return
        }
        
        db.collection("users").document(user.id).addSnapshotListener{ snapshot, error in
            if error == nil{
                if let snapshot = snapshot, snapshot.exists{
                    DispatchQueue.main.async {
                        guard let data = snapshot.data() else {
                            self.finishedLoading = true
                            return
                        }
                        self.user.displayedID = data["displayedID"] as? String ?? ""
                        self.user.role = data["role"] as? String ?? "user"
                        var timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                        self.user.createdTime = timestamp.dateValue() as NSDate
                        
                        guard let firstName = data["firstName"] as? String,
                              let lastName = data["lastName"] as? String,
                              let petName = data["petName"] as? String,
                              //let phoneNumber = data["phoneNumber"] as? String,
                              let questions = data["questions"] as? [Int] else {
                            self.firstTime = true
                            self.finishedLoading = true
                            return
                        }
                        self.user.firstName = firstName
                        self.user.lastName = lastName
                        //self.user.phoneNumber = phoneNumber
                        self.user.displayedName = data["displayedName"] as? String ?? ""
                        if self.user.displayedName == "" { self.user.displayedName = "\(firstName) \(lastName)"}
                        self.user.bio = data["bio"] as? String ?? ""
                        self.user.petName = petName
                        self.user.petGender = data["petGender"] as? Bool ?? true
                        self.user.breed = data["breed"] as? String ?? ""
                        timestamp = data["petBirthDate"] as? Timestamp ?? Timestamp()
                        self.user.petBirthDate = timestamp.dateValue() as Date
                        timestamp = data["togetherDate"] as? Timestamp ?? Timestamp()
                        self.user.togetherDate = timestamp.dateValue() as Date
                        self.user.questions = questions
                        self.user.followersCount = data["followersCount"] as? Int ?? 0
                        self.user.followingCount = data["followingCount"] as? Int ?? 0
                        self.user.payed = data["payed"] as? Int ?? 0
                        
                        self.firstTime = false;
                        self.finishedLoading = true
                        
                        if(cleanUp){
                            self.cleanUp(data: data)
                        }
                    }
                } else {
                    self.firstTime = true;
                    self.finishedLoading = true
                }
            }
            else {
                
            }
        }
    }
    
    func createUser(){
        db.collection("users").document(user.id).setData([
            "displayedID" : "user\(UserViewModel.randomStringWithLength(len: 12))",
            "role": "user",
            "timestamp": Timestamp(),
            //"phoneNumber": user.phoneNumber,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "displayedName": "\(user.firstName) \(user.lastName)",
            "bio": "",
            
            "petName": user.petName,
            "petGender": user.petGender,
            "breed": user.breed,
            "petBirthDate": user.petBirthDate,
            "togetherDate": user.togetherDate,
            
            "questions": user.questions,
            
            "followersCount": user.followersCount,
            "followingCount": user.followingCount,
            "payed": user.payed
        ])
    }
    
    func updateStringField(field: String, value: String){
        db.collection("users").document(user.id).updateData([
            field: value
        ])
    }
    
    func updatePayedStatus(payed: Int){
        db.collection("users").document(user.id).updateData([
            "payed": payed
        ])
    }
    
    func deleteUser(){ //not completed
        ImageViewModel.deleteFolderFromStorage(path: "users/\(user.id)")
        db.collection("users").document(user.id).delete()
    }
    
    static func randomStringWithLength(len: Int) -> NSString {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomString : NSMutableString = NSMutableString(capacity: len)
        for _ in 1...len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        return randomString
    }
}

class UserListViewModel: ObservableObject{
    @Published var userList = [User]()
    
    func getUserWithID(id: String){
        guard id != "" else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").whereField("displayedID", isEqualTo: id).getDocuments { snapshot, error in
            if error == nil, let snapshot = snapshot{
                DispatchQueue.main.async {
                    self.userList = snapshot.documents.map({ d in
                        let timestamp = d["timestamp"] as? Timestamp ?? Timestamp()
                        let timestamp2 = d["petBirthDate"] as? Timestamp ?? Timestamp()
                        let timestamp3 = d["togetherDate"] as? Timestamp ?? Timestamp()
                        return User(id: d.documentID,
                                    displayedID: id,
                                    role: d["role"] as? String ?? "user",
                                    createdTime: timestamp.dateValue() as NSDate,
                                    //phoneNumber: d["phoneNumber"] as? String ?? "",
                                    firstName: d["firstName"] as? String ?? "",
                                    lastName: d["lastName"] as? String ?? "",
                                    displayedName: d["displayedName"] as? String ?? "",
                                    bio: d["bio"] as? String ?? "",
                                    petName: d["petName"] as? String ?? "Unknown Pet",
                                    petGender: d["petGender"] as? Bool ?? true,
                                    breed: d["breed"] as? String ?? "",
                                    petBirthDate: timestamp2.dateValue() as Date,
                                    togetherDate: timestamp3.dateValue() as Date,
                                    questions: [],
                                    followersCount: d["followersCount"] as? Int ?? 0,
                                    followingCount: d["followingCount"] as? Int ?? 0,
                                    chats: [],
                                    payed: d["payed"] as? Int ?? 0)
                    })
                }
            }
        }
    }
}

// Chats
extension UserViewModel {
    func getChats(){
        db.collection("users").document(user.id).collection("chats").addSnapshotListener { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.user.chats = snapshot.documents.map({ d in
                            let date = d["lastRead"] as? Timestamp ?? Timestamp()
                            return UserChat(id: d.documentID, lastRead: date.dateValue())
                        })
                    }
                }
            }
        }
    }
    
    func addChat(chatID: String, lastRead: Timestamp = Timestamp()){
        let db = Firestore.firestore()
        
        db.collection("users").document(user.id).collection("chats").document(chatID).setData(["lastRead": lastRead])
    }
    
    static func staticAddChat(userID: String, chatID: String, lastRead: Timestamp = Timestamp()){
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).collection("chats").document(chatID).setData(["lastRead": lastRead])
    }
    
    func removeChat(chatID: String){
        let db = Firestore.firestore()
        
        db.collection("users").document(user.id).collection("chats").document(chatID).delete()
    }
}

// CleanUp
extension UserViewModel {
    func cleanUp(data: [String : Any]) {
        let ref = db.collection("users").document(user.id)
        if let previousFollowers = data["followers"] as? [String] {
            for follower in previousFollowers {
                let userFollowersViewModel = UserFollowersViewModel(id: self.user.id)
                userFollowersViewModel.addFollower(followerID: follower)
            }
            ref.updateData([
                "followers": FieldValue.delete(),
                "followersCount": previousFollowers.count
            ])
        }
        if let previousFollowing = data["following"] as? [String] {
            for following in previousFollowing {
                let userFollowingViewModel = UserFollowingViewModel(id: self.user.id)
                userFollowingViewModel.addFollowing(followingID: following)
            }
            ref.updateData([
                "following": FieldValue.delete(),
                "followingCount": previousFollowing.count
            ])
        }
        if let previousExplores = data["explores"] as? [String] {
            for explore in previousExplores {
                let userExploresViewModel = UserExploresViewModel(id: self.user.id)
                userExploresViewModel.addExplores(exploreID: explore)
            }
            ref.updateData([
                "explores": FieldValue.delete(),
            ])
        }
        if let previousLikedExplores = data["likedExplores"] as? [String] {
            for explore in previousLikedExplores {
                let userLikedExploreViewModel = UserLikedExploresViewModel(id: self.user.id)
                userLikedExploreViewModel.addLikedExplores(exploreID: explore)
            }
            ref.updateData([
                "likedExplores": FieldValue.delete(),
            ])
        }
        if let previousFavoriteExplores = data["favorites"] as? [String] {
            for explore in previousFavoriteExplores {
                let userFavoriteExploreViewModel = UserFavoriteExploresViewModel(id: self.user.id)
                userFavoriteExploreViewModel.addFavoriteExplores(exploreID: explore)
            }
            ref.updateData([
                "favorites": FieldValue.delete(),
            ])
        }
        if let previousDiscovers = data["discovers"] as? [String] {
            for discover in previousDiscovers {
                let userDiscoversViewModel = UserDiscoversViewModel(id: self.user.id)
                userDiscoversViewModel.addDiscovers(discoverID: discover)
            }
            ref.updateData([
                "discovers": FieldValue.delete(),
            ])
        }
        if let previousDiscovers = data["favoriteDiscovers"] as? [String] {
            for discover in previousDiscovers {
                let userFavoriteDiscoversViewModel = UserFavoriteDiscoversViewModel(id: self.user.id)
                userFavoriteDiscoversViewModel.addFavoriteDiscovers(discoverID: discover)
                userFavoriteDiscoversViewModel.addUpvotesDiscovers(discoverID: discover)
            }
            ref.updateData([
                "discovers": FieldValue.delete(),
                "discovers": FieldValue.delete(),
            ])
        }
        if let previousCourseHistory = data["courseHistory"] as? [String] {
            for courseHistory in previousCourseHistory {
                let userCourseHistoryViewModel = UserCourseHistoryViewModel(id: self.user.id)
                userCourseHistoryViewModel.addCourseHistory(courseID: courseHistory)
            }
            ref.updateData([
                "courseHistory": FieldValue.delete(),
            ])
        }
    }
}

// Get Fields
class UserFieldsViewModel: ObservableObject {
    @Published var firstName = "";
    @Published var lastName = "";
    
    func getFirstName(id: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document(id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    self.firstName = document.get("firstName") as? String ?? ""
                }
            }
        }
    }
    
    func getLastName(id: String) {
        let db = Firestore.firestore()
        
        db.collection("users").document(id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    self.lastName = document.get("lastName") as? String ?? ""
                }
            }
        }
    }
}
