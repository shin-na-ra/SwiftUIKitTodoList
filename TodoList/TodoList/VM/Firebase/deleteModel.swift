//
//  deleteModel.swift
//  TodoList
//
//  Created by 신나라 on 5/21/24.
//

import Foundation
import Firebase

struct DeleteModel {
    let db = Firestore.firestore()
    
    func deleteItems(documentId : String) -> Bool {
        var result: Bool = true
        
        db.collection("todoLists").document(documentId).delete(){
            error in
            if error != nil {
                result = false
            } else {
                result = true
            }
        }
        return result
    }
}
