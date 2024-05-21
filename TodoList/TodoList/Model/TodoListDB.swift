//
//  TodoListDB.swift
//  TodoList
//
//  Created by 신나라 on 5/21/24.
//

struct TodoListDB: Codable {
    var id: String
    var todoList : String
    var insertdate: String
    var compledate: String
    var status : Int
    var seq: Int
    var image: String
}

