//
//  ProgramViewModel.swift
//  Amigo
//
//  Created by Jack Liu on 7/24/22.
//

import Foundation
import Firebase


class ProgramViewModel: ObservableObject {
    @Published var programs = [Program]()
    
    func loadPrograms(){
        let db = Firestore.firestore()
        db.collection("programs").getDocuments { snapshot, error in
            if error == nil, let snapshot = snapshot{
                DispatchQueue.main.async {
                    self.programs = snapshot.documents.map({ d in
                        return Program(id: d.documentID,
                                       title: d["title"] as? String ?? "",
                                       courses: d["courses"] as? [String] ?? [],
                                       creator: d["creator"] as? String ?? "")
                    })
                }
            }
        }
    }
}
