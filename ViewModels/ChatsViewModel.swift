//
//  ChatsViewModel.swift
//  Amigo
//
//  Created by Jack Liu on 6/25/22.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
//

import Foundation
import Firebase
import SwiftUI

class ChatsViewModel: ObservableObject{
    @Published var chats = [Chat]()
    
    func getChats(userID: String){
        let db = Firestore.firestore()
        
        db.collection("chats").whereField("users", arrayContains: userID).addSnapshotListener { snapshot, error in
            if error == nil{
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.chats = snapshot.documents.map { d in
                            let timestamp = d["lastActiveTime"] as! Timestamp
                            
                            return Chat(id: d.documentID,
                                        users: d["users"] as? [String] ?? [],
                                        chatName: d["chatName"] as? String ?? "",
                                        lastActiveTime : timestamp.dateValue() as Date
                            )
                        }
                        
                        self.chats.sort { $0.lastActiveTime > $1.lastActiveTime }
                    }
                }
            }
            else {
                
            }
        }
    }
    
    static func addChat(users: [String]) -> String {
        let db = Firestore.firestore()
        let chatName = users.count > 2 ? "Group Chat" : ""
        let newDoc = db.collection("chats").addDocument(data: ["users" : users, "chatName": chatName, "lastActiveTime": Timestamp()])
        return newDoc.documentID
    }
    
    static func updateLastActiveTime(chatID: String){
        let db = Firestore.firestore()
        db.collection("chats").document(chatID).updateData([
            "lastActiveTime": Timestamp()
        ])
    }
}

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var lastMessageId: String = ""
    
    var chatID: String = ""
    
    let db = Firestore.firestore()
    
    func getMessages() {
        db.collection("chats").document(self.chatID).collection("messages").addSnapshotListener { snapshot, error in
            guard (snapshot?.documents) != nil else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            if let snapshot = snapshot{
                self.messages = snapshot.documents.map { d in
                    let timestamp = d["timeStamp"] as! Timestamp
                    
                    return Message(id: d.documentID,
                                   sender: d["sender"] as! String,
                                   type:  d["type"] as? String ?? "text",
                                   text: d["text"] as! String,
                                   timeStamp : timestamp.dateValue() as Date
                    )
                }
                
                self.messages.sort { $0.timeStamp < $1.timeStamp }
                
                if let id = self.messages.last?.id {
                    self.lastMessageId = id
                }
                
                //Save message to local storage
            }
        }
    }
    
    func sendMessage(sender: String, type: String, text: String) {
        db.collection("chats").document(self.chatID).collection("messages").addDocument(data: ["sender" : sender, "type": type, "text": text, "timeStamp": Timestamp()])
    }
}
