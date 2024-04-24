//
//  MomentPostViewModel.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 12/22/21.
//

import Foundation
import Firebase
import SwiftUI

class MomentPostViewModel: ObservableObject{
    @Published var list = [MomentPost]()
    @Published var isLoadingPage = false
    @Published var canLoadMore = true
    private var lastLoad : DocumentSnapshot? = nil
    private var firstLoad : DocumentSnapshot? = nil
    
    func reset(){
        list = [MomentPost]()
        isLoadingPage = false
        canLoadMore = true
        lastLoad = nil
        firstLoad = nil
    }
    
    func loadNewestPosts() {
        guard let firstLoad = firstLoad else {
            return
        }
        let db = Firestore.firestore()
        db.collection("explores").order(by: "timestamp", descending: true).end(beforeDocument: firstLoad).limit(to: 10).getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        var newList = [MomentPost]()
                        if let fl = snapshot.documents.first {
                            self.firstLoad = fl
                        }
                        for d in snapshot.documents {
                            let timestamp = d["timestamp"] as! Timestamp
                            let imageCount = d["imageCount"] as? Int ?? 0
                            newList.append(MomentPost(id: d.documentID,
                                                      user: d["user"] as? String ?? "",
                                                      content: d["content"] as? String ?? "",
                                                      likes: d["likes"] as? Int ?? 0,
                                                      favorites: d["favorites"] as? Int ?? 0,
                                                      commentsCount: d["commentsCount"] as? Int ?? 0,
                                                      createdDate: timestamp.dateValue() as NSDate,
                                                      imageCount: imageCount,
                                                      imageType: d["imageType"] as? [Bool] ?? [Bool](repeating: true, count: imageCount),
                                                      reported: d["reported"] as? Bool ?? false
                                                     ))
                        }
                        self.list = newList + self.list
                    }
                }
            }
            else {
                
            }
        }
        
    }
    
    func loadMorePostsIfNeeded(currentPost: MomentPost?){
        guard let currentPost = currentPost else {
            getMorePosts()
            return
        }
        let thresholdIndex = list.index(list.endIndex, offsetBy: -5)
        if list.firstIndex(where: { $0.id == currentPost.id }) == thresholdIndex {
            getMorePosts()
        }
    }
    
    func getMorePosts(){
        let db = Firestore.firestore()
        if let lastLoad = lastLoad {
            db.collection("explores").order(by: "timestamp", descending: true).start(afterDocument: lastLoad).limit(to: 10).getDocuments{ snapshot, error in
                if error == nil{
                    if let snapshot = snapshot{
                        DispatchQueue.main.async {
                            if(snapshot.documents.count < 10){
                                self.canLoadMore = false
                            }
                            
                            for d in snapshot.documents {
                                let timestamp = d["timestamp"] as? Timestamp ?? Timestamp()
                                let imageCount = d["imageCount"] as? Int ?? 0
                                self.list.append(MomentPost(id: d.documentID,
                                                            user: d["user"] as? String ?? "",
                                                            content: d["content"] as? String ?? "",
                                                            likes: d["likes"] as? Int ?? 0,
                                                            favorites: d["favorites"] as? Int ?? 0,
                                                            commentsCount: d["commentsCount"] as? Int ?? 0,
                                                            createdDate: timestamp.dateValue() as NSDate,
                                                            imageCount: imageCount,
                                                            imageType: d["imageType"] as? [Bool] ?? [Bool](repeating: true, count: imageCount),
                                                            reported: d["reported"] as? Bool ?? false
                                                           ))
                            }
                            self.lastLoad = snapshot.documents.last
                            self.isLoadingPage = false
                        }
                    }
                }
            }
        } else {
            db.collection("explores").order(by: "timestamp", descending: true).limit(to: 10).getDocuments{ snapshot, error in
                if error == nil{
                    if let snapshot = snapshot{
                        DispatchQueue.main.async {
                            if(snapshot.documents.count < 15){
                                self.canLoadMore = false
                            }
                            
                            for d in snapshot.documents {
                                let timestamp = d["timestamp"] as? Timestamp ?? Timestamp()
                                let imageCount = d["imageCount"] as? Int ?? 0
                                self.list.append(MomentPost(id: d.documentID,
                                                            user: d["user"] as? String ?? "",
                                                            content: d["content"] as? String ?? "",
                                                            likes: d["likes"] as? Int ?? 0,
                                                            favorites: d["favorites"] as? Int ?? 0,
                                                            commentsCount: d["commentsCount"] as? Int ?? 0,
                                                            createdDate: timestamp.dateValue() as NSDate,
                                                            imageCount: imageCount,
                                                            imageType: d["imageType"] as? [Bool] ?? [Bool](repeating: true, count: imageCount),
                                                            reported: d["reported"] as? Bool ?? false
                                                           ))
                            }
                            self.lastLoad = snapshot.documents.last
                            self.isLoadingPage = false
                            
                            self.firstLoad = snapshot.documents.first
                        }
                    }
                }
            }
        }
        
    }
    
    func getMomentsWithArray(momentArray: [String]){
        guard momentArray.count > 0 else {
            return
        }
        let db = Firestore.firestore()
        self.list = []
        for id in momentArray {
            db.collection("explores").document(id).getDocument { snapshot, error in
                if error == nil{
                    if let snapshot = snapshot{
                        DispatchQueue.main.async {
                            let d = snapshot.data()
                            if let d = d {
                                let timestamp = d["timestamp"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
                                let imageCount = d["imageCount"] as? Int ?? 0
                                self.list.append(MomentPost(id: id,
                                                  user: d["user"] as? String ?? "",
                                                  content: d["content"] as? String ?? "",
                                                  likes: d["likes"] as? Int ?? 0,
                                                  favorites: d["favorites"] as? Int ?? 0,
                                                  commentsCount: d["commentsCount"] as? Int ?? 0,
                                                  createdDate: timestamp.dateValue() as NSDate,
                                                  imageCount: imageCount,
                                                  imageType: d["imageType"] as? [Bool] ?? [Bool](repeating: true, count: imageCount),
                                                  reported: d["reported"] as? Bool ?? false
                                                 ))
                                
                                self.list.sort{
                                    $0.createdDate.compare($1.createdDate as Date) == .orderedDescending
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //TODO: delete subcollections
    
    func removePost(postID: String){
        let db = Firestore.firestore()
        db.collection("explores").document(postID).delete()
    }
    
    func getPost(){
        let db = Firestore.firestore()
        db.collection("explores").order(by: "timestamp", descending: true).limit(to: 10).getDocuments{ snapshots, error in
            if error == nil{
                if let snapshots = snapshots{
                    DispatchQueue.main.async {
                        self.list = snapshots.documents.map({ d in
                            let timestamp = d["timestamp"] as! Timestamp
                            let imageCount = d["imageCount"] as? Int ?? 0
                            return (MomentPost(id: d.documentID,
                                               user: d["user"] as? String ?? "",
                                               content: d["content"] as? String ?? "",
                                               likes: d["likes"] as? Int ?? 0,
                                               favorites: d["favorites"] as? Int ?? 0,
                                               commentsCount: d["commentsCount"] as? Int ?? 0,
                                               createdDate: timestamp.dateValue() as NSDate,
                                               imageCount: imageCount,
                                               imageType: d["imageType"] as? [Bool] ?? [Bool](repeating: true, count: imageCount),
                                               reported: d["reported"] as? Bool ?? false
                                              ))
                        })
                    }
                }
            }
            else {}
        }
    }
    
    static func addPost(user: String, content: String, imageCount: Int, imageType: [Bool]) -> String{
        let db = Firestore.firestore()
        
        let newDoc = db.collection("explores").addDocument(data: [ "content": content, "imageCount": imageCount, "imageType": imageType, "user": user, "views": 0, "likes": 0, "favorites": 0, "commentsCount": 0, "timestamp": Timestamp()])
        
        return newDoc.documentID
    }
    
    static func addPost(postID: String, user: String, content: String, imageCount: Int, imageType: [Bool]){
        let db = Firestore.firestore()
        db.collection("explores").document(postID).setData(["content": content, "imageCount": imageCount, "imageType": imageType, "user": user, "views": 0, "likes": 0, "favorites": 0, "commentsCount": 0, "timestamp": Timestamp()])
    }
}

class MomentDetailViewModel : ObservableObject {
    @Published var moment = MomentPost(id: "", user: "", content: "", likes: 0, favorites: 0, commentsCount: 0, createdDate: Timestamp().dateValue() as NSDate, imageCount: 0, imageType: [], reported: false)
    
    @Published var loading = true
    
    func getData() {
        let db = Firestore.firestore()
        db.collection("explores").document(moment.id).getDocument { snapshot, error in
            if error == nil{
                if let snapshot = snapshot, snapshot.exists{
                    DispatchQueue.main.async {
                        let data = snapshot.data()
                        
                        let timestamp = data?["timestamp"] as! Timestamp
                        let imageCount = data?["imageCount"] as? Int ?? 0
                        
                        self.moment.user = data?["user"] as? String ?? ""
                        self.moment.content = data?["content"] as? String ?? ""
                        self.moment.likes = data?["likes"] as? Int ?? 0
                        self.moment.favorites = data?["favorites"] as? Int ?? 0
                        self.moment.commentsCount = data?["commentsCount"] as? Int ?? 0
                        self.moment.createdDate = timestamp.dateValue() as NSDate
                        self.moment.imageCount = imageCount
                        self.moment.imageType = data?["imageType"] as? [Bool] ?? [Bool](repeating: true, count: imageCount)
                        self.moment.reported = data?["reported"] as? Bool ?? false
                        
                        self.loading = false
                    }
                }
            } else {
                //
            }
        }
    }
    
    func addFavorite() {
        let db = Firestore.firestore()
        self.moment.favorites += 1
        let ref = db.collection("explores").document(moment.id)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("favorites") as? Int ?? 0
                    ref.updateData([
                        "favorites" : FieldValue + Int(1)
                    ])
                }
            }
        }
    }
    
    func subtractFavorite(){
        let db = Firestore.firestore()
        self.moment.favorites -= 1
        let ref = db.collection("explores").document(moment.id)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("favorites") as? Int ?? 0
                    ref.updateData([
                        "favorites" : FieldValue - Int(1)
                    ])
                }
            }
        }
    }
    
    static func staticSubtractFavorite(momentID: String){
        let db = Firestore.firestore()
        let ref = db.collection("explores").document(momentID)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("favorites") as? Int ?? 0
                    ref.updateData([
                        "favorites" : FieldValue - Int(1)
                    ])
                }
            }
        }
    }
    
    func addLike(){
        let db = Firestore.firestore()
        self.moment.likes += 1
        let ref = db.collection("explores").document(moment.id)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("likes") as? Int ?? 0
                    ref.updateData([
                        "likes" : FieldValue + Int(1)
                    ])
                }
            }
        }
    }
    
    func subtractLike(){
        let db = Firestore.firestore()
        moment.likes -= 1
        let ref = db.collection("explores").document(moment.id)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("likes") as? Int ?? 0
                    ref.updateData([
                        "likes" : FieldValue - Int(1)
                    ])
                }
            }
        }
    }
        
    static func staticSubtractLike(momentID: String){
        let db = Firestore.firestore()
        let ref = db.collection("explores").document(momentID)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("likes") as? Int ?? 0
                    ref.updateData([
                        "likes" : FieldValue - Int(1)
                    ])
                }
            }
        }
    }
    
    func addCommentsCount(){
        let db = Firestore.firestore()
        moment.commentsCount += 1
        let ref = db.collection("explores").document(moment.id)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("commentsCount") as? Int ?? 0
                    ref.updateData([
                        "commentsCount" : FieldValue + Int(1)
                    ])
                }
            }
        }
    }
    
    func subtractCommentsCount(){
        let db = Firestore.firestore()
        moment.commentsCount -= 1
        let ref = db.collection("explores").document(moment.id)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("commentsCount") as? Int ?? 0
                    ref.updateData([
                        "commentsCount" : FieldValue - Int(1)
                    ])
                }
            }
        }
    }
}
    
//TODO: distributed counters
class MomentIndividualPostViewModel: ObservableObject {
    @Published var moment : MomentPost
    
    init(moment: MomentPost){
        self.moment = moment
    }
    
    func addLike(){
        let db = Firestore.firestore()
        self.moment.likes += 1
        let ref = db.collection("explores").document(moment.id)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("likes") as? Int ?? 0
                    ref.updateData([
                        "likes" : FieldValue + Int(1)
                    ])
                }
            }
        }
    }
    
    func subtractLike(){
        let db = Firestore.firestore()
        moment.likes -= 1
        let ref = db.collection("explores").document(moment.id)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("likes") as? Int ?? 0
                    ref.updateData([
                        "likes" : FieldValue - Int(1)
                    ])
                }
            }
        }
    }
        
    static func staticSubtractLike(momentID: String){
        let db = Firestore.firestore()
        let ref = db.collection("explores").document(momentID)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("likes") as? Int ?? 0
                    ref.updateData([
                        "likes" : FieldValue - Int(1)
                    ])
                }
            }
        }
    }
    
    func addFavorite() {
        let db = Firestore.firestore()
        self.moment.favorites += 1
        let ref = db.collection("explores").document(moment.id)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("favorites") as? Int ?? 0
                    ref.updateData([
                        "favorites" : FieldValue + Int(1)
                    ])
                }
            }
        }
    }
    
    func subtractFavorite(){
        let db = Firestore.firestore()
        moment.favorites -= 1
        let ref = db.collection("explores").document(moment.id)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("favorites") as? Int ?? 0
                    ref.updateData([
                        "favorites" : FieldValue - Int(1)
                    ])
                }
            }
        }
    }
    
    static func staticSubtractFavorite(momentID: String){
        let db = Firestore.firestore()
        let ref = db.collection("explores").document(momentID)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("favorites") as? Int ?? 0
                    ref.updateData([
                        "favorites" : FieldValue - Int(1)
                    ])
                }
            }
        }
    }
    
    
    func addCommentsCount(){
        let db = Firestore.firestore()
        moment.commentsCount += 1
        let ref = db.collection("explores").document(moment.id)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("commentsCount") as? Int ?? 0
                    ref.updateData([
                        "commentsCount" : FieldValue + Int(1)
                    ])
                }
            }
        }
    }
    
    func subtractCommentsCount(){
        let db = Firestore.firestore()
        moment.commentsCount -= 1
        let ref = db.collection("explores").document(moment.id)
        ref.getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("commentsCount") as? Int ?? 0
                    ref.updateData([
                        "commentsCount" : FieldValue - Int(1)
                    ])
                }
            }
        }
    }
    
    func reportPost(content: String, user: String){
        let db = Firestore.firestore()
        let ref = db.collection("explores").document(moment.id)
        ref.updateData([
            "reported" : true,
        ])
        
        //add report to the reports collection
        db.collection("explores").document(moment.id).collection("reports").addDocument(data: ["user" : user, "content": content, "timestamp": Timestamp()])
        
    }
}

class MomentCommentViewModel: ObservableObject{
    @Published var comments = [MomentComment]()
    var momentID = ""
    
    func getData(limit: Int = 50){
        let db = Firestore.firestore()
        db.collection("explores").document(momentID).collection("comments").order(by: "timestamp", descending: false).limit(to: limit).getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.comments = snapshot.documents.map { d in
                            let timestamp = d["timestamp"] as! Timestamp
                            return MomentComment(id: d.documentID,
                                                 user: d["user"] as? String ?? "",
                                                 content: d["content"] as? String ?? "",
                                                 createdDate: timestamp.dateValue() as NSDate,
                                                 reported: d["reported"] as? Bool ?? false
                            )
                        }
                    }
                }
            }
        }
    }
    
    func addComment(user: String, content: String){
        let db = Firestore.firestore()
        comments.append(MomentComment(id: UUID().uuidString, user: user, content: content, createdDate: Date() as NSDate, reported: false))
        db.collection("explores").document(momentID).collection("comments").addDocument(data: ["user" : user, "content": content, "timestamp": Timestamp(), "reported": false])
    }
    
    func deleteComment(id: String){
        let db = Firestore.firestore()
        self.comments = self.comments.filter(){$0.id != id}
        db.collection("explores").document(momentID).collection("comments").document(id).delete()
    }
    
    func reportComment(id: String, content: String, user: String){
        let db = Firestore.firestore()
        let ref = db.collection("explores").document(momentID).collection("comments").document(id)
        ref.updateData([
            "reported" : true,
        ])
        
        //add report to the reports collection
        db.collection("explores").document(momentID).collection("comments").document(id).collection("reports").addDocument(data: ["user" : user, "content": content, "timestamp": Timestamp()])
    }
}
