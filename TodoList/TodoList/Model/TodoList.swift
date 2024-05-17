//
//  TodoList.swift
//  TodoList
//
//  Created by 신나라 on 5/16/24.
//

import UIKit

struct TodoList {
    var id: Int
    var todoList : String
    var insertdate: String
    var compledate: String
    var status : Int
    var seq: Int
    var image: UIImage
    
    init(id: Int, todoList: String, insertdate: String, compledate: String, status: Int, seq: Int, image: UIImage) {
        self.id = id
        self.todoList = todoList
        self.insertdate = insertdate
        self.compledate = compledate
        self.status = status
        self.seq = seq
        self.image = image
    }
}
