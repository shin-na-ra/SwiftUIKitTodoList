//
//  updateModel.swift
//  TodoList
//
//  Created by 신나라 on 5/21/24.
//

import Foundation
import Firebase

struct UpdateModel {
    let db = Firestore.firestore()
    
    func updateItems (documentId: String ,todo: String) -> Bool {
        var result: Bool = true
        
        db.collection("todoLists").document(documentId).updateData([
            "todo" : todo
        ]) { error in
            if error != nil {
                result = false
            } else {
                result = true
            }
        }
        
        return result
    }
}
