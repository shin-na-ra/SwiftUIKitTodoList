//
//  TodoListDB.swift
//  TodoList
//
//  Created by 신나라 on 5/21/24.
//

struct MySqlTodoListDB: Codable {
    var todo : String
    var compledate: String
    var image: String
    var insertdate: String
    var id: Int
    var seq: Int
    var status : Int
}

