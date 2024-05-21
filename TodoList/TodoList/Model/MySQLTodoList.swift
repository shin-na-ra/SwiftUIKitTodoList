//
//  MySQLTodoList.swift
//  TodoList
//
//  Created by 신나라 on 5/21/24.
//

struct MySQLTodoList {
    var id: Int
    var todoList : String
    var insertdate: String
    var compledate: String
    var status : Int
    var seq: Int
    var image: String
    
    init(id: Int, todoList: String, insertdate: String, compledate: String, status: Int, seq: Int, image: String) {
        self.id = id
        self.todoList = todoList
        self.insertdate = insertdate
        self.compledate = compledate
        self.status = status
        self.seq = seq
        self.image = image
    }
}
