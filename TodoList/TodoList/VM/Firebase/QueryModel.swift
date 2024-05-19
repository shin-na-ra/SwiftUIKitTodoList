//
//  QueryModel.swift
//  TodoList
//
//  Created by 신나라 on 5/18/24.
//

import Foundation
import Firebase

protocol QueryModelProtocol {
    func itemDownloaded(items : [FirebaseModel])
}

struct QueryModel {
    var delegate: QueryModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems() {
        var locations: [FirebaseModel] = []
        
        db.collection("todoLists")
            .order(by: "seq")
            .getDocuments(completion: {(querySnapshot, error) in
                if let error = error {
                    print("error ")
                } else {
                    print("data is downloaded.")
                    
                    for document in querySnapshot!.documents {
                        guard let data = document.data()["todo"] else {return}
                        
                        let query = FirebaseModel(id: document.documentID,
                                                  todoList: document.data()["todo"] as! String,
                                                  insertdate: document.data()["insertdate"] as! String,
                                                  compledate: document.data()["compledate"] as! String,
                                                  status: document.data()["status"] as! Int,
                                                  seq: document.data()["seq"] as! Int,
                                                  image: document.data()["image"] as! String
                                                  )
                        locations.append(query)
                    }
                    
                    DispatchQueue.main.async {
                        self.delegate.itemDownloaded(items: locations)
                    }
                }
            })
    }
}
