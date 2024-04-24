//
//  UserCourseHistoryViewModel.swift
//  Amigo
//
//  Created by Jack Liu on 8/10/22.
//
import Firebase
import SwiftUI

class UserCourseHistoryViewModel: ObservableObject {
    @Published var courseHistoryList = [UserCourseHistory]()
    let userID: String
    let db = Firestore.firestore()
    init(id: String){
        self.userID = id
    }
    func getCourseHistory() {
        db.collection("users").document(userID).collection("courseHistory").order(by: "timeVisited", descending: true).getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.courseHistoryList = snapshot.documents.map({ d in
                            let date = d["timeVisited"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
                            return UserCourseHistory(id: d.documentID, courseID: d["courseID"] as! String, timeVisited: date.dateValue())
                        })
                    }
                }
            }
        }
    }
    
    func addCourseHistory(courseID: String){
        db.collection("users").document(userID).collection("courseHistory").addDocument(data: ["courseID": courseID, "timeVisited": Date()])
    }
    
    func removeCourseHistory(documenetID: String){
        self.courseHistoryList = self.courseHistoryList.filter({$0.id != documenetID})
        db.collection("users").document(userID).collection("courseHistory").document(documenetID).delete()
    }
}
