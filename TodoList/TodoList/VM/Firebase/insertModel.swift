//
//  insertModel.swift
//  TodoList
//
//  Created by 신나라 on 5/18/24.
//

import Foundation
import Firebase

struct insertModel {
    
    let db = Firestore.firestore()
    
    
    func insertItems(todo: String, insertdate: String, compledate: String, status: Int, image: String) -> Bool {
        
        var result: Bool = true
        
        db.collection("todoLists").order(by: "seq", descending: true).limit(to: 1).getDocuments { (snapshot, error) in
            if let error = error {
                print("ERROR")
            } else {
//                var seq = 0
//                if let document = snapshot?.documents.first {
//                    seq = document.data()["seq"] as? Int ?? 0
//                    seq += 1
//                    print("seq : \(seq)")
//                } else {
//                    seq = 1
//                }
                
                print("dfdf")
                
                db.collection("todoLists").addDocument(data: [
                    "todo" : todo,
                    "insertdate" : insertdate,
                    "compledate" : compledate,
                    "status" : status,
                    "seq" : 3,
                    "image" : image
                ]) {error in
                    if error != nil {
                        result = false
                    } else {
                        result = true
                    }
                }
                
            }
        }
        return result
    }
    
}
