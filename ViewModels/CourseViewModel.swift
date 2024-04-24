//
//  CourseViewModel.swift
//  Amigo Pet IOS App
//
//  Created by Jack Liu on 1/3/22.
//

import Foundation
import Firebase
import SwiftUI

class CourseViewModel: ObservableObject{
    @Published var list = [Course]()
    @Published var isLoadingPage = false
    @Published var canLoadMore = true
    private var lastLoad : DocumentSnapshot? = nil
    
    //    static func addData(post: MomentPost.Data) -> String{
    //    }
    //    func loadMoreCoursesIfNeeded(currentCourse: Course?){
    //        guard let currentCourse = currentCourse else {
    //          loadMoreCourses()
    //          return
    //        }
    //
    //        let thresholdIndex = list.index(list.endIndex, offsetBy: -5)
    //        if list.firstIndex(where: { $0.id == currentCourse.id }) == thresholdIndex {
    //            loadMoreCourses()
    //        }
    //    }
    
    func loadMoreCourses(){
        guard !isLoadingPage && canLoadMore else {
            return
        }
        isLoadingPage = true
        
        let db = Firestore.firestore()
        if let lastLoad = lastLoad {
            db.collection("courses").order(by: "uploadedTime", descending: true).start(afterDocument: lastLoad).limit(to: 10).getDocuments { snapshot, error in
                if error == nil{
                    if let snapshot = snapshot{
                        DispatchQueue.main.async {
                            if(snapshot.documents.count < 10){
                                self.canLoadMore = false
                            }
                            
                            for d in snapshot.documents {
                                let dict = d["preparation"] as? Dictionary<String, String> ?? [:]
                                var arr : [PreparationItem] = []
                                for (key, value) in dict {
                                    arr.append(PreparationItem(name: key, description: value))
                                }
                                let timestamp = d["uploadedTime"] as? Timestamp ?? Timestamp()
                                self.list.append(Course(id: d.documentID,
                                                        title: d["title"] as? String ?? "",
                                                        skill: d["skill"] as? Int ?? 0,
                                                        numSessions: d["numSessions"] as? Int ?? 0,
                                                        preparation: arr,
                                                        prereq: d["prereq"] as? [String] ?? [],
                                                        totalTime: d["totalTime"] as? String ?? "",
                                                        creator: d["creator"] as? String ?? "",
                                                        category: d["category"] as? String ?? "",
                                                        
                                                        uploadedTime: timestamp.dateValue(),
                                                        isPremium : d["isPremium"] as? Bool ?? false,
                                                        isRecommended: d["isRecommended"] as? Bool ?? false
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
            db.collection("courses").order(by: "uploadedTime", descending: true).limit(to: 10).getDocuments { snapshot, error in
                if error == nil{
                    if let snapshot = snapshot{
                        DispatchQueue.main.async {
                            if(snapshot.documents.count < 10){
                                self.canLoadMore = false
                            }
                            
                            for d in snapshot.documents {
                                let dict = d["preparation"] as? Dictionary<String, String> ?? [:]
                                var arr : [PreparationItem] = []
                                for (key, value) in dict {
                                    arr.append(PreparationItem(name: key, description: value))
                                }
                                let timestamp = d["uploadedTime"] as? Timestamp ?? Timestamp()
                                self.list.append(Course(id: d.documentID,
                                                        title: d["title"] as? String ?? "",
                                                        skill: d["skill"] as? Int ?? 0,
                                                        numSessions: d["numSessions"] as? Int ?? 0,
                                                        preparation: arr,
                                                        prereq: d["prereq"] as? [String] ?? [],
                                                        totalTime: d["totalTime"] as? String ?? "",
                                                        creator: d["creator"] as? String ?? "",
                                                        category: d["category"] as? String ?? "",
                                                        
                                                        uploadedTime: timestamp.dateValue(),
                                                        isPremium : d["isPremium"] as? Bool ?? false,
                                                        isRecommended: d["isRecommended"] as? Bool ?? false
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
        }
        
    }
    
    func getRecommendedCourses(){
        let db = Firestore.firestore()
        
        //.order(by: "timestamp", descending: true)
        db.collection("courses").whereField("isRecommended", isEqualTo: true).getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.list = snapshot.documents.map { d in
                            let dict = d["preparation"] as? Dictionary<String, String> ?? [:]
                            var arr : [PreparationItem] = []
                            for (key, value) in dict {
                                arr.append(PreparationItem(name: key, description: value))
                            }
                            let timestamp = d["uploadedTime"] as? Timestamp ?? Timestamp()
                            return Course(id: d.documentID,
                                          title: d["title"] as? String ?? "",
                                          skill: d["skill"] as? Int ?? 0,
                                          numSessions: d["numSessions"] as? Int ?? 0,
                                          preparation: arr,
                                          prereq: d["prereq"] as? [String] ?? [],
                                          totalTime: d["totalTime"] as? String ?? "",
                                          creator: d["creator"] as? String ?? "",
                                          category: d["category"] as? String ?? "",
                                          
                                          uploadedTime: timestamp.dateValue(),
                                          isPremium : d["isPremium"] as? Bool ?? false,
                                          isRecommended: d["isRecommended"] as? Bool ?? false
                            )
                        }
                    }
                }
            }
            else {
                
            }
        }
    }
    
    func getData(){
        let db = Firestore.firestore()
        
        
        //.order(by: "timestamp", descending: true)
        db.collection("courses").getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.list = snapshot.documents.map { d in
                            let dict = d["preparation"] as? Dictionary<String, String> ?? [:]
                            var arr : [PreparationItem] = []
                            for (key, value) in dict {
                                arr.append(PreparationItem(name: key, description: value))
                            }
                            let timestamp = d["uploadedTime"] as? Timestamp ?? Timestamp()
                            return Course(id: d.documentID,
                                          title: d["title"] as? String ?? "",
                                          skill: d["skill"] as? Int ?? 0,
                                          numSessions: d["numSessions"] as? Int ?? 0,
                                          preparation: arr,
                                          prereq: d["prereq"] as? [String] ?? [],
                                          totalTime: d["totalTime"] as? String ?? "",
                                          creator: d["creator"] as? String ?? "",
                                          category: d["category"] as? String ?? "",
                                          
                                          uploadedTime: timestamp.dateValue(),
                                          isPremium : d["isPremium"] as? Bool ?? false,
                                          isRecommended: d["isRecommended"] as? Bool ?? false
                            )
                        }
                    }
                }
            }
            else {
                
            }
        }
    }
    
    static func addCourse(title: String, skill: Int, numSessions: Int, preparation: Dictionary<String, String>, prereq: [String], totalTime: String, creator: String, category: String, isPremium: Bool, isRecommended: Bool ) -> String {
        let db = Firestore.firestore()
        let newDoc = db.collection("courses").addDocument(data: ["title" : title, "skill" : skill, "numSessions": numSessions, "preparation": preparation, "prereq": prereq, "totalTime": totalTime, "creator": creator, "category": category, "isPremium": isPremium, "isRecommended": isRecommended, "uploadedTime": Timestamp()])
        return newDoc.documentID
    }
    
    func getCoursesWithArray(courseArray: [String]){
        let db = Firestore.firestore()
        
        self.list = [Course](repeating: Course(id: UUID().uuidString, title: "", skill: 0, numSessions: 0, preparation: [], prereq: [], totalTime: "", creator: "", category: "", uploadedTime: Date(), isPremium: false, isRecommended: false), count: courseArray.count)
        
        for i in 0..<courseArray.count{
            let post = courseArray[i]
            db.collection("courses").document(post).getDocument { snapshot, error in
                if error == nil{
                    if let snapshot = snapshot, snapshot.exists{
                        DispatchQueue.main.async {
                            let d = snapshot.data()
                            let dict = d?["preparation"] as? Dictionary<String, String> ?? [:]
                            var arr : [PreparationItem] = []
                            for (key, value) in dict {
                                arr.append(PreparationItem(name: key, description: value))
                            }
                            let timestamp = d?["uploadedTime"] as? Timestamp ?? Timestamp()
                            self.list[i] = Course(id: post,
                                                  title: d?["title"] as? String ?? "",
                                                  skill: d?["skill"] as? Int ?? 0,
                                                  numSessions: d?["numSessions"] as? Int ?? 0,
                                                  preparation: arr,
                                                  prereq: d?["prereq"] as? [String] ?? [],
                                                  totalTime: d?["totalTime"] as? String ?? "",
                                                  creator: d?["creator"] as? String ?? "",
                                                  category: d?["category"] as? String ?? "",
                                                  
                                                  uploadedTime: timestamp.dateValue(),
                                                  isPremium : d?["isPremium"] as? Bool ?? false,
                                                  isRecommended: d?["isRecommended"] as? Bool ?? false
                            )
                        }
                    }
                }
                else {
                    
                }
            }
        }
        
    }
    
    
}

class CourseSessionsViewModel: ObservableObject{
    @Published var sessions = [CourseSession]()
    
    func getData(courseID: String){
        let db = Firestore.firestore()
        
        db.collection("courses").document(courseID).collection("sessions").getDocuments { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.sessions = snapshot.documents.map { d in
                            return CourseSession(id: Int(d.documentID)!,
                                                 title: d["title"] as? String ?? "",
                                                 hasVideo: d["hasVideo"] as? Bool ?? false,
                                                 overview: d["overview"] as? String ?? "",
                                                 steps: d["steps"] as? [String] ?? [],
                                                 stepTimestamps: d["stepTimestamps"] as? [Int] ?? [],
                                                 time: d["time"] as? Int ?? 3,
                                                 endingQuestion: d["endingQuestion"] as? String ?? ""
                            )
                        }
                    }
                }
            }
            else {
                
            }
        }
    }
    
    static func addCourseSession(courseID: String, sessionID: Int, title:String, hasVideo: Bool, overview: String, steps: [String], time:Int, endingQuestion: String){
        let db = Firestore.firestore()
        db.collection("courses").document(courseID).collection("sessions").document("\(sessionID)").setData(["title" : title, "hasVideo" : hasVideo, "overview": overview, "steps": steps, "time": time, "endingQuestion": endingQuestion])
    }
}

