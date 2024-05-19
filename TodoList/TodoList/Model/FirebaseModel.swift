//
//  FirebaseModel.swift
//  TodoList
//
//  Created by 신나라 on 5/18/24.
//

struct FirebaseModel {
    var id: String
    var todoList : String
    var insertdate: String
    var compledate: String
    var status : Int
    var seq: Int
    var image: String
    
    init(id: String, todoList: String, insertdate: String, compledate: String, status: Int, seq: Int, image: String) {
        self.id = id
        self.todoList = todoList
        self.insertdate = insertdate
        self.compledate = compledate
        self.status = status
        self.seq = seq
        self.image = image
    }
}
