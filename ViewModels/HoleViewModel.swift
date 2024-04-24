//
//  HoleViewModel.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 4/3/22.
//

import Foundation
import Firebase
import SwiftUI

class HoleViewModel: ObservableObject{
    @Published var list = [HoleDisplay]()
    @Published var isLoadingPage = false
    @Published var canLoadMore = true
    private var lastLoad : DocumentSnapshot? = nil
    private var firstLoad : DocumentSnapshot? = nil
    
    func reset(){
        list = [HoleDisplay]()
        isLoadingPage = false
        canLoadMore = true
        lastLoad = nil
        firstLoad = nil
        loadMoreHoles()
    }
    
    
    func loadMostPopular(limit: Int){
        let db = Firestore.firestore()
        var dayComponent = DateComponents()
        dayComponent.day = -15
        let calendar = Calendar.current
        let start =  calendar.date(byAdding: dayComponent, to: Date())!
        
        db.collection("holes")
            .whereField("imageCount", in: [1, 2, 3, 4, 5, 6, 7, 8, 9])
            .whereField("timestamp", isGreaterThan: start)
            .limit(to: limit)
            .getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.list = snapshot.documents.map({ d in
                            let timestamp = d["timestamp"] as! Timestamp
                            return HoleDisplay(id: d.documentID,
                                               creator: d["creator"] as? String ?? "",
                                               title: d["title"] as? String ?? "",
                                               createdDate: timestamp.dateValue() as NSDate,
                                               content: d["content"] as? String ?? "",
                                               answers: d["answers"] as? Int ?? 0,
                                               views: d["views"] as? Int ?? 0,
                                               upvotes: d["upvotes"] as? Int ?? 0,
                                               imageCount: d["imageCount"] as? Int ?? 0,
                                               isAsk: d["isAsk"] as? Bool ?? false,
                                               favorites: d["favorites"] as? Int ?? 0,
                                               reported: d["reported"] as? Bool ?? false
                            )
                        })
                        
                        self.list.sort{
                            $0.views > $1.views
                        }
                    }
                }
            }
            else {
                print("\n\n \(error?.localizedDescription) \n\n")
            }
        }
    }
    
    func loadNewestHoles() {
        guard let firstLoad = firstLoad else {
            return
        }
        let db = Firestore.firestore()
        db.collection("holes").order(by: "timestamp", descending: true).end(beforeDocument: firstLoad).limit(to: 10).getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        var newList = [HoleDisplay]()
                        if let fl = snapshot.documents.first {
                            self.firstLoad = fl
                        }
                        for d in snapshot.documents {
                            let timestamp = d["timestamp"] as! Timestamp
                            newList.append(HoleDisplay(id: d.documentID,
                                                       creator: d["creator"] as? String ?? "",
                                                       title: d["title"] as? String ?? "",
                                                       createdDate: timestamp.dateValue() as NSDate,
                                                       content: d["content"] as? String ?? "",
                                                       answers: d["answers"] as? Int ?? 0,
                                                       views: d["views"] as? Int ?? 0,
                                                       upvotes: d["upvotes"] as? Int ?? 0,
                                                       imageCount: d["imageCount"] as? Int ?? 0,
                                                       isAsk: d["isAsk"] as? Bool ?? false,
                                                       favorites: d["favorites"] as? Int ?? 0,
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
    
    func loadMoreHoles(){
        guard !isLoadingPage && canLoadMore else {
            return
        }
        isLoadingPage = true
        
        let db = Firestore.firestore()
        if let lastLoad = lastLoad {
            db.collection("holes").order(by: "timestamp", descending: true).start(afterDocument: lastLoad).limit(to: 10).getDocuments { snapshot, error in
                if error == nil{
                    if let snapshot = snapshot{
                        DispatchQueue.main.async {
                            if(snapshot.documents.count < 10){
                                self.canLoadMore = false
                            }
                            
                            for d in snapshot.documents {
                                let timestamp = d["timestamp"] as! Timestamp
                                self.list.append(HoleDisplay(id: d.documentID,
                                                             creator: d["creator"] as? String ?? "",
                                                             title: d["title"] as? String ?? "",
                                                             createdDate: timestamp.dateValue() as NSDate,
                                                             content: d["content"] as? String ?? "",
                                                             answers: d["answers"] as? Int ?? 0,
                                                             views: d["views"] as? Int ?? 0,
                                                             upvotes: d["upvotes"] as? Int ?? 0,
                                                             imageCount: d["imageCount"] as? Int ?? 0,
                                                             isAsk: d["isAsk"] as? Bool ?? false,
                                                             favorites: d["favorites"] as? Int ?? 0,
                                                             reported: d["reported"] as? Bool ?? false
                                                            ))
                            }
                            self.lastLoad = snapshot.documents.last
                            self.isLoadingPage = false
                        }
                    }
                }
                else {
                    
                }
            }
        } else {
            db.collection("holes").order(by: "timestamp", descending: true).limit(to: 10).getDocuments { snapshot, error in
                if error == nil{
                    if let snapshot = snapshot{
                        DispatchQueue.main.async {
                            if(snapshot.documents.count < 10){
                                self.canLoadMore = false
                            }
                            
                            for d in snapshot.documents {
                                let timestamp = d["timestamp"] as! Timestamp
                                self.list.append(HoleDisplay(id: d.documentID,
                                                             creator: d["creator"] as? String ?? "",
                                                             title: d["title"] as? String ?? "",
                                                             createdDate: timestamp.dateValue() as NSDate,
                                                             content: d["content"] as? String ?? "",
                                                             answers: d["answers"] as? Int ?? 0,
                                                             views: d["views"] as? Int ?? 0,
                                                             upvotes: d["upvotes"] as? Int ?? 0,
                                                             imageCount: d["imageCount"] as? Int ?? 0,
                                                             isAsk: d["isAsk"] as? Bool ?? false,
                                                             favorites: d["favorites"] as? Int ?? 0,
                                                             reported: d["reported"] as? Bool ?? false
                                                            ))
                            }
                            self.lastLoad = snapshot.documents.last
                            self.isLoadingPage = false
                            
                            self.firstLoad = snapshot.documents.first
                        }
                    }
                }
                else {
                    
                }
            }
        }
        
    }
    
    //    static func addData(userID: String, post: MomentPost.Data) -> String{
    //        let db = Firestore.firestore()
    //
    //        let newDoc = db.collection("explores").addDocument(data: ["user" : userID, "content": post.content, "imageCount": post.imageCount, "timestamp": Timestamp()])
    //
    //        return newDoc.documentID
    //    }
    func addViewCount(holeID: String) {
        let db = Firestore.firestore()
        
        db.collection("holes").document(holeID).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("views") as? Int ?? 0
                    db.collection("holes").document(holeID).updateData([
                        "views" : FieldValue + Int(1)
                    ])
                } else {
                    print("Document does not exist")
                }
            } else {
            }
        }
    }
    
    func getHolesWithArray(holeArray: [String]){
        guard holeArray.count > 0 else {
            return
        }
        let db = Firestore.firestore()
        self.list = []
        for id in holeArray{
            db.collection("holes").document(id).getDocument { snapshot, error in
                if error == nil{
                    if let snapshot = snapshot{
                        if let d = snapshot.data(){
                            DispatchQueue.main.async {
                                let timestamp = d["timestamp"] as! Timestamp
                                
                                self.list.append(HoleDisplay(id: id,
                                                             creator: d["creator"] as? String ?? "",
                                                             title: d["title"] as? String ?? "",
                                                             createdDate: timestamp.dateValue() as NSDate,
                                                             content: d["content"] as? String ?? "",
                                                             answers: d["answers"] as? Int ?? 0,
                                                             views: d["views"] as? Int ?? 0,
                                                             upvotes: d["upvotes"] as? Int ?? 0,
                                                             imageCount: d["imageCount"] as? Int ?? 0,
                                                             isAsk: d["isAsk"] as? Bool ?? false,
                                                             favorites: d["favorites"] as? Int ?? 0,
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
    
    
    
    
    
    
    
    
    static func addDiscover(creator: String, isAsk: Bool, title: String, content: String, imageCount: Int) -> String{
        let db = Firestore.firestore()
        let newDoc = db.collection("holes").addDocument(data: ["title" : title, "isAsk": isAsk, "content": content, "imageCount": imageCount, "creator": creator, "timestamp": Timestamp(), "upvotes": 0, "downvotes": 0]) // Note: default isAsk==false, empty comments, empty answerList
        return newDoc.documentID
    }
    
    func removeDiscover(discoverID: String){
        let db = Firestore.firestore()
        db.collection("holes").document(discoverID).delete()
    }
    
    static func reportDiscover(discoverID: String, content: String, user: String){
        let db = Firestore.firestore()
        let ref = db.collection("holes").document(discoverID)
        ref.updateData([
            "reported" : true,
        ])
            
            //add report to the reports collection
        db.collection("holes").document(discoverID).collection("reports").addDocument(data: ["user" : user, "content": content, "timestamp": Timestamp()])
    }
    
    func getData(){ //Not in use
        let db = Firestore.firestore()
        
        db.collection("holes").order(by: "timestamp", descending: true).limit(to: 50).getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    
                    DispatchQueue.main.async {
                        
                        self.list = snapshot.documents.map { d in
                            
                            
                            let timestamp = d["timestamp"] as! Timestamp
                            
                            return HoleDisplay(id: d.documentID,
                                               creator: d["creator"] as? String ?? "",
                                               title: d["title"] as? String ?? "",
                                               createdDate: timestamp.dateValue() as NSDate,
                                               content: d["content"] as? String ?? "",
                                               answers: d["answers"] as? Int ?? 0,
                                               views: d["views"] as? Int ?? 0,
                                               upvotes: d["upvotes"] as? Int ?? 0,
                                               imageCount: d["imageCount"] as? Int ?? 0,
                                               isAsk: d["isAsk"] as? Bool ?? false,
                                               favorites: d["favorites"] as? Int ?? 0,
                                               reported: d["reported"] as? Bool ?? false
                            )
                        }
                    }
                }
            }
        }
    }
}

class HoleDetailCountViewModel : ObservableObject {
    @Published var answersCount = 0;
    @Published var firstAnswer : HoleAnswer? = nil;
    @Published var viewsCount = 0;
    
    func getCounts(holeID: String) {
        let db = Firestore.firestore()
        
        db.collection("holes").document(holeID).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    self.viewsCount = document.get("views") as? Int ?? 0
                }
            }
        }
        db.collection("holes").document(holeID).collection("answerList").getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.answersCount = snapshot.count
                    }
                }
            }
        }
        db.collection("holes").document(holeID).collection("answerList").order(by: "timestamp", descending: false).limit(to: 1).getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    if(snapshot.documents.count > 0){
                        DispatchQueue.main.async {
                            let d = snapshot.documents[0].data()
                            let timestamp = d["timestamp"] as! Timestamp
                            self.firstAnswer = HoleAnswer(id: snapshot.documents[0].documentID,
                                                          user: d["user"] as? String ?? "",
                                                          content: d["content"] as? String ?? "",
                                                          imageCount: d["imageCount"] as? Int ?? 0,
                                                          createdDate: timestamp.dateValue() as NSDate,
                                                          upvotes: d["upvotes"] as? Int ?? 0,
                                                          downvotes: d["downvotes"] as? Int ?? 0,
                                                          reported: d["reported"] as? Bool ?? false
                            )
                        }
                    }
                }
            }
        }
    }
}

class HoleDetailViewModel: ObservableObject{
    @Published var hole = Hole(id: "", creator: "", title: "", content: "", imageCount: 0, createdDate: Timestamp().dateValue() as NSDate, answers: 0, views: 0, isAsk: false, upvotes: 0, downvotes: 0, favorites: 0, answerList: []) // TODO: should imageCount = 0 ? used to be 1
    @Published var loading = true
    
    func getData(){
        let db = Firestore.firestore()
        
        db.collection("holes").document(hole.id).getDocument { snapshot, error in
            if error == nil{
                if let snapshot = snapshot, snapshot.exists{
                    DispatchQueue.main.async {
                        
                        let data = snapshot.data()
                        
                        let timestamp = data?["timestamp"] as! Timestamp
                        self.hole.createdDate = timestamp.dateValue() as NSDate
                        self.hole.creator = data?["creator"] as! String
                        self.hole.title = data?["title"] as! String
                        self.hole.content = data?["content"] as! String
                        self.hole.imageCount = data?["imageCount"] as! Int
                        // self.hole.isAsk = data?["isAsk"] as! Bool
                        self.hole.upvotes = data?["upvotes"] as? Int ?? 0
                        self.hole.downvotes = data?["downvotes"] as? Int ?? 0
                        self.hole.favorites = data?["favorites"] as? Int ?? 0
                        
                        db.collection("holes").document(self.hole.id).collection("answerList").order(by: "timestamp", descending: true).limit(to: 50).getDocuments { snapshot, error in
                            if error == nil{
                                if let snapshot = snapshot{
                                    DispatchQueue.main.async {
                                        self.hole.answerList = snapshot.documents.map { d in
                                            let timestamp = d["timestamp"] as! Timestamp
                                            return HoleAnswer(id: d.documentID,
                                                              user: d["user"] as? String ?? "",
                                                              content: d["content"] as? String ?? "",
                                                              imageCount: d["imageCount"] as? Int ?? 0,
                                                              createdDate: timestamp.dateValue() as NSDate,
                                                              upvotes: d["upvotes"] as? Int ?? 0,
                                                              downvotes: d["downvotes"] as? Int ?? 0,
                                                              reported: d["reported"] as? Bool ?? false
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        self.loading = false
                    }
                }
            }
            else {
                
            }
        }
    }
    
    func addAnswer(user: String, content: String, imageCount: Int) -> String{
        let db = Firestore.firestore()
        let answer = db.collection("holes").document(self.hole.id).collection("answerList").addDocument(data: ["user" : user, "content": content, "imageCount": imageCount, "timestamp": Timestamp(), "upvotes": 0, "downvotes": 0])
        getData()
        
        return answer.documentID
    }
    
    func deleteAnswer(id: String){
        let db = Firestore.firestore()
        
        self.hole.answerList = self.hole.answerList.filter(){$0.id != id}
        
        db.collection("holes").document(self.hole.id).collection("answerList").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            }
            else {
                print("Comment successfully removed!")
            }
        }
        
        db.collection("holes").document(self.hole.id).collection("subcomments").whereField("comment", isEqualTo: id).getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    for document in snapshot.documents {
                        db.collection("holes").document(self.hole.id).collection("subcomments").document(document.documentID).delete()
                    }
                }
            }
        }
    }
    
    func addUpvote() {
        self.hole.upvotes += 1
        
        let db = Firestore.firestore()
        
        db.collection("holes").document(self.hole.id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("upvotes") as? Int ?? 0
                    db.collection("holes").document(self.hole.id).updateData([
                        "upvotes" : FieldValue + Int(1)
                    ])
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func removeUpvote() {
        self.hole.upvotes -= 1
        
        let db = Firestore.firestore()
        
        db.collection("holes").document(self.hole.id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("upvotes") as? Int ?? 0
                    db.collection("holes").document(self.hole.id).updateData([
                        "upvotes" : FieldValue - Int(1)
                    ])
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func addDownvote() {
        self.hole.downvotes += 1
        
        let db = Firestore.firestore()
        
        db.collection("holes").document(self.hole.id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("downvotes") as? Int ?? 0
                    db.collection("holes").document(self.hole.id).updateData([
                        "downvotes" : FieldValue + Int(1)
                    ])
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func removeDownvote() {
        self.hole.downvotes -= 1
        
        let db = Firestore.firestore()
        
        db.collection("holes").document(self.hole.id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("downvotes") as? Int ?? 0
                    db.collection("holes").document(self.hole.id).updateData([
                        "downvotes" : FieldValue - Int(1)
                    ])
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func addAnswerUpvote(id: String) {
        let index = self.hole.answerList.firstIndex(where: {$0.id == id})
        self.hole.answerList[index!].upvotes += 1
        
        let db = Firestore.firestore()
        
        db.collection("holes").document(self.hole.id).collection("answerList").document(id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("upvotes") as? Int ?? 0
                    db.collection("holes").document(self.hole.id).collection("answerList").document(id).updateData([
                        "upvotes" : FieldValue + Int(1)
                    ])
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func removeAnswerUpvote(id: String) {
        let index = self.hole.answerList.firstIndex(where: {$0.id == id})
        self.hole.answerList[index!].upvotes -= 1
        
        let db = Firestore.firestore()
        
        db.collection("holes").document(self.hole.id).collection("answerList").document(id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("upvotes") as? Int ?? 0
                    db.collection("holes").document(self.hole.id).collection("answerList").document(id).updateData([
                        "upvotes" : FieldValue - Int(1)
                    ])
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func addAnswerDownvote(id: String) {
        let index = self.hole.answerList.firstIndex(where: {$0.id == id}) //TODO: assume all index distinct
        self.hole.answerList[index!].downvotes += 1
        
        let db = Firestore.firestore()
        
        db.collection("holes").document(self.hole.id).collection("answerList").document(id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("downvotes") as? Int ?? 0
                    db.collection("holes").document(self.hole.id).collection("answerList").document(id).updateData([
                        "downvotes" : FieldValue + Int(1)
                    ])
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func removeAnswerDownvote(id: String) {
        let index = self.hole.answerList.firstIndex(where: {$0.id == id}) //TODO: assume all index distinct
        self.hole.answerList[index!].downvotes -= 1
        
        let db = Firestore.firestore()
        
        db.collection("holes").document(self.hole.id).collection("answerList").document(id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("downvotes") as? Int ?? 0
                    db.collection("holes").document(self.hole.id).collection("answerList").document(id).updateData([
                        "downvotes" : FieldValue - Int(1)
                    ])
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func addFavorite() {
        let db = Firestore.firestore()
        self.hole.favorites += 1
        
        db.collection("holes").document(self.hole.id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("favorites") as? Int ?? 0
                    db.collection("holes").document(self.hole.id).updateData([
                        "favorites" : FieldValue + Int(1)
                    ])
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func removeFavorite() {
        let db = Firestore.firestore()
        self.hole.favorites -= 1
        
        db.collection("holes").document(self.hole.id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("favorites") as? Int ?? 0
                    db.collection("holes").document(self.hole.id).updateData([
                        "favorites" : FieldValue - Int(1)
                    ])
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    static func staticRemoveFavorite(id: String) {
        let db = Firestore.firestore()
        
        db.collection("holes").document(id).getDocument { (document, error) in
            if error == nil {
                if let document = document, document.exists {
                    let FieldValue = document.get("favorites") as? Int ?? 0
                    db.collection("holes").document(id).updateData([
                        "favorites" : FieldValue - Int(1)
                    ])
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func reportDiscoverAnswer(answerID: String, content: String, user: String){
        let db = Firestore.firestore()
        let ref = db.collection("holes").document(self.hole.id).collection("answerList").document(answerID)
        ref.updateData([
            "reported" : true,
        ])
        //add report to the reports collection
        db.collection("holes").document(self.hole.id).collection("answerList").document(answerID).collection("reports").addDocument(data: ["user" : user, "content": content, "timestamp": Timestamp()])
    }
}


class HoleSubcommentViewModel: ObservableObject{
    @Published var subcomments = [HoleSubComment]()
    
    var holeID = ""
    var commentID = ""
    let db = Firestore.firestore()
    
    func getSubComments() {
        db.collection("holes").document(self.holeID).collection("subcomments").whereField("comment", isEqualTo: self.commentID).order(by: "timestamp", descending: false).limit(to: 10).getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.subcomments = snapshot.documents.map { d in
                            let timestamp = d["timestamp"] as! Timestamp
                            return HoleSubComment(id: d.documentID,
                                                  comment: d["comment"] as! String,
                                                  toComment: d["toComment"] as? Bool ?? true,
                                                  at: d["at"] as? String ?? "",
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
    
    func addComment(at: String, comment: String, toComment: Bool, user: String, content: String){
        db.collection("holes").document(self.holeID).collection("subcomments").addDocument(data: ["comment" : comment, "toComment" : toComment,"at": at, "user" : user, "content": content, "timestamp": Timestamp()])
        getSubComments()
    }
    
    func deleteComment(id: String){
        self.subcomments.removeAll(where: {$0.id == id})
        db.collection("holes").document(self.holeID).collection("subcomments").document(id).delete()
    }
    
    
}
